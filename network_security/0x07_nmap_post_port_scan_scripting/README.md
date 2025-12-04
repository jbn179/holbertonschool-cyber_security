# 0x07. Nmap Post Port Scan Scripting

## Description

Ce projet explore le Nmap Scripting Engine (NSE), une fonctionnalité puissante qui étend considérablement les capacités de Nmap au-delà du simple scan de ports. Le NSE permet d'automatiser une vaste gamme de tâches réseau, de la découverte à l'exploitation de vulnérabilités, en utilisant des scripts écrits en Lua.

À travers ce projet, nous apprenons à utiliser les scripts NSE pour effectuer des analyses de sécurité avancées, détecter des vulnérabilités, énumérer des services et réaliser des reconnaissances complètes de réseaux.

## Objectifs d'apprentissage

À la fin de ce projet, vous devriez être capable d'expliquer :

- Qu'est-ce que le Nmap Scripting Engine (NSE) et pourquoi est-il important
- Comment fonctionne le NSE
- Quelles sont les différentes catégories de scripts NSE
- Comment les scripts sont organisés et exécutés dans le NSE
- Quels arguments de ligne de commande sont utilisés pour exécuter les scripts NSE
- Ce que vous pouvez faire avec les scripts Nmap
- Comment écrire de la documentation pour les scripts NSE en utilisant NSEDoc

## Ressources

- [ressources.md](ressources.md) - Guide complet sur le NSE, les catégories de scripts, et la documentation
- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [NSE Documentation Portal](https://nmap.org/nsedoc/)
- [Nmap Network Scanning Book](https://nmap.org/book/)

## Prérequis

- Ubuntu/Linux
- Nmap 7.80 ou supérieur
- Connaissances de base en réseaux et sécurité
- Compréhension des ports et services
- Autorisation explicite pour scanner les cibles

## Tâches

### 0. Scripts NSE par défaut
**Fichier :** `0-nmap_default.sh`

Exécute les scripts NSE par défaut de Nmap sur un hôte cible.

```bash
./0-nmap_default.sh scanme.nmap.org
```

**Commande utilisée :**
```bash
nmap -sC $1
```

**Scripts inclus :** ssh-hostkey, http-title, et autres scripts de la catégorie "default"

---

### 1. Script vulners
**Fichier :** `1-nmap_vulners.sh`

Utilise le script vulners pour identifier les vulnérabilités sur les ports 80 et 443.

```bash
./1-nmap_vulners.sh scanme.nmap.org
```

**Commande utilisée :**
```bash
nmap --script vulners -p 80,443 $1
```

**Fonctionnalité :** Interroge une base de données de vulnérabilités pour les services détectés

---

### 2. Détection de vulnérabilité Apache Struts
**Fichier :** `2-vuln_scan.sh`

Détecte la vulnérabilité Apache Struts 2 (CVE-2017-5638) et sauvegarde les résultats.

```bash
./2-vuln_scan.sh scanme.nmap.org
```

**Commande utilisée :**
```bash
nmap --script http-vuln-cve2017-5638 $1 -oN vuln_scan_results.txt
```

**Résultat :** Fichier `vuln_scan_results.txt`

---

### 3. Analyse de sécurité complète
**Fichier :** `3-comprehensive_scan.sh`

Effectue une analyse de sécurité complète avec plusieurs scripts NSE.

```bash
./3-comprehensive_scan.sh scanme.nmap.org
```

**Commande utilisée :**
```bash
nmap --script http-vuln-cve2017-5638,ssl-enum-ciphers,ftp-anon $1 -oN comprehensive_scan_results.txt
```

**Scripts exécutés :**
- `http-vuln-cve2017-5638` : Vulnérabilité Apache Struts 2
- `ssl-enum-ciphers` : Énumération des chiffrements SSL/TLS
- `ftp-anon` : Vérification de connexion FTP anonyme

**Résultat :** Fichier `comprehensive_scan_results.txt`

---

### 4. Scan de vulnérabilités multi-services
**Fichier :** `4-vulnerability_scan.sh`

Détecte les vulnérabilités sur plusieurs services (web, MySQL, FTP, SMTP).

```bash
./4-vulnerability_scan.sh scanme.nmap.org
```

**Commande utilisée :**
```bash
nmap --script http-vuln*,mysql-vuln*,ftp-vuln*,smtp-vuln* $1 -oN vulnerability_scan_results.txt
```

**Utilisation des wildcards :** Les `*` permettent d'exécuter tous les scripts de vulnérabilités pour chaque service

**Résultat :** Fichier `vulnerability_scan_results.txt`

---

### 5. Énumération de services complète
**Fichier :** `5-service_enumeration.sh`

Reconnaissance réseau complète avec détection d'OS, versions, scripts et traceroute.

```bash
./5-service_enumeration.sh scanme.nmap.org
```

**Commande utilisée :**
```bash
nmap -sV -A --script banner,ssl-enum-ciphers,default,smb-enum-domains $1 -oN service_enumeration_results.txt
```

**Options :**
- `-sV` : Détection de version des services
- `-A` : Mode agressif (OS detection, version detection, script scanning, traceroute)
- `--script` : Scripts spécifiques (banner, ssl-enum-ciphers, default, smb-enum-domains)

**Résultat :** Fichier `service_enumeration_results.txt`

---

## Catégories de scripts NSE

| Catégorie | Description | Exemples |
|-----------|-------------|----------|
| **default** | Scripts par défaut (`-sC`) | ssh-hostkey, http-title |
| **vuln** | Détection de vulnérabilités | ssl-heartbleed, smb-vuln-ms08-067 |
| **brute** | Attaques par force brute | ssh-brute, ftp-brute |
| **discovery** | Découverte réseau | dns-brute, snmp-info |
| **exploit** | Exploitation de vulnérabilités | ftp-vsftpd-backdoor |
| **auth** | Authentification | http-auth |
| **safe** | Scripts sûrs | Scripts non intrusifs |
| **intrusive** | Scripts potentiellement dangereux | Scripts de DoS |

## Options Nmap importantes

### Scripts
```bash
-sC                    # Scripts par défaut (équivalent à --script=default)
--script=<nom>         # Exécuter un script spécifique
--script=<catégorie>   # Exécuter tous les scripts d'une catégorie
--script=<pattern>*    # Utiliser des wildcards
--script-help=<nom>    # Afficher l'aide d'un script
```

### Analyse
```bash
-sV                    # Détection de version
-A                     # Mode agressif (OS + version + scripts + traceroute)
-O                     # Détection d'OS
--traceroute           # Traçage de route
```

### Ports
```bash
-p <ports>             # Spécifier les ports (ex: -p 80,443)
-p-                    # Scanner tous les ports
```

### Sortie
```bash
-oN <fichier>          # Sortie normale
-oX <fichier>          # Sortie XML
-oG <fichier>          # Sortie greppable
```

## Exemples d'utilisation

### Scanner avec scripts par défaut
```bash
nmap -sC scanme.nmap.org
```

### Scanner une catégorie de vulnérabilités
```bash
nmap --script vuln scanme.nmap.org
```

### Scanner avec wildcards
```bash
nmap --script "http-*" scanme.nmap.org
```

### Mode agressif avec scripts personnalisés
```bash
nmap -A --script banner,ssl-enum-ciphers scanme.nmap.org
```

### Combiner des catégories
```bash
nmap --script "default or safe" scanme.nmap.org
nmap --script "default and not intrusive" scanme.nmap.org
```

## Considérations éthiques

⚠️ **IMPORTANT - Autorisation obligatoire**

- **Toujours obtenir une autorisation écrite** avant de scanner un système
- Une analyse non autorisée est **illégale** dans la plupart des juridictions
- Peut entraîner des poursuites civiles et pénales

✅ **Cibles légales pour la pratique :**
- `scanme.nmap.org` - Cible officielle de Nmap
- Machines virtuelles dans un réseau isolé
- Environnements de laboratoire (HackTheBox, TryHackMe)

🔒 **Bonnes pratiques :**
- Limiter la vitesse d'analyse (`-T2` ou `-T3`)
- Éviter les scripts DoS en production
- Respecter la vie privée des données découvertes
- Suivre les principes de divulgation responsable

## Structure du projet

```
0x07_nmap_post_port_scan_scripting/
├── 0-nmap_default.sh
├── 1-nmap_vulners.sh
├── 2-vuln_scan.sh
├── 3-comprehensive_scan.sh
├── 4-vulnerability_scan.sh
├── 5-service_enumeration.sh
├── vuln_scan_results.txt
├── comprehensive_scan_results.txt
├── vulnerability_scan_results.txt
├── service_enumeration_results.txt
├── ressources.md
└── README.md
```

## Utilisation

### Rendre les scripts exécutables
```bash
chmod +x *.sh
```

### Exécuter un script
```bash
./0-nmap_default.sh <cible>
```

### Avec sudo (recommandé pour certaines fonctionnalités)
```bash
sudo ./5-service_enumeration.sh scanme.nmap.org
```

## Notes techniques

### Wildcards dans les scripts
Les wildcards (`*`) permettent d'exécuter plusieurs scripts correspondant à un pattern :
```bash
--script http-vuln*  # Tous les scripts http-vuln-*
--script *-brute     # Tous les scripts de brute-force
```

### Séparateurs de scripts
```bash
# Avec virgules (syntaxe standard)
--script script1,script2,script3

# Avec espaces et guillemets
--script "script1 script2 script3"
```

### Redondances courantes
- `-A` inclut déjà `-sV`, `-sC`, `-O` et `--traceroute`
- `-sC` est équivalent à `--script=default`
- Spécifier `-sV` avec `-A` est redondant mais parfois requis par les checkers

## Dépannage

### Permissions insuffisantes
Si les fichiers de résultats appartiennent à root :
```bash
sudo chown $USER:$USER *.txt
```

### Scripts non trouvés
Mettre à jour la base de données des scripts :
```bash
sudo nmap --script-updatedb
```

### Vérifier les scripts disponibles
```bash
ls /usr/share/nmap/scripts/ | grep vuln
```

## Ressources complémentaires

- **Documentation officielle** : https://nmap.org/book/nse.html
- **Liste des scripts** : https://nmap.org/nsedoc/
- **Tutoriel NSE** : https://nmap.org/book/nse-tutorial.html
- **Communauté** : https://github.com/nmap/nmap

## Dépôt

- **GitHub repository :** `holbertonschool-cyber_security`
- **Directory :** `network_security/0x07_nmap_post_port_scan_scripting`

## Auteur

Programme Cyber Sécurité - Holberton School

---

**Dernière mise à jour :** Décembre 2025
