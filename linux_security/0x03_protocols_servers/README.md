# 0x03. Protocoles & Serveurs

## Description

Ce projet se concentre sur la compréhension et la sécurisation des protocoles réseau et des serveurs dans les environnements Linux. À travers des exercices de scripting pratiques, vous apprendrez à auditer des configurations, identifier des vulnérabilités, implémenter des mesures de sécurité et tester la résilience de divers services réseau.

## Objectifs d'apprentissage

À la fin de ce projet, vous devez être capable d'expliquer à n'importe qui, sans l'aide de Google :

### Compréhension des protocoles réseau
- **Quel est le but du protocole NFS ?**
  - NFS (Network File System) permet le partage de fichiers à travers le réseau, permettant aux systèmes distants de monter et accéder à des répertoires comme s'ils étaient locaux

- **Comment fonctionne SMTP pour envoyer des emails ?**
  - SMTP (Simple Mail Transfer Protocol) gère la transmission d'emails entre serveurs de messagerie, utilisant des commandes comme HELO, MAIL FROM, RCPT TO et DATA pour transférer les messages

- **Quelles informations SNMP fournit-il sur les périphériques réseau ?**
  - SNMP (Simple Network Management Protocol) fournit des données de surveillance sur les périphériques réseau incluant l'état de santé système, les métriques de performance, les détails de configuration et le statut opérationnel

- **Comment SMB permet-il le partage de fichiers entre différents systèmes d'exploitation ?**
  - SMB (Server Message Block) fournit un protocole commun pour le partage de fichiers et d'imprimantes qui fonctionne sur Windows, Linux et autres systèmes d'exploitation

- **Quel est le rôle de LDAP dans l'authentification et l'autorisation ?**
  - LDAP (Lightweight Directory Access Protocol) fournit des services d'annuaire centralisés pour l'authentification, l'autorisation et la gestion des utilisateurs/ressources à travers les réseaux

### Concepts de sécurité
- **Expliquez les risques de sécurité associés à l'utilisation de RDP**
  - Les risques RDP (Remote Desktop Protocol) incluent : attaques par force brute, vol d'identifiants, attaques man-in-the-middle, exploitation de vulnérabilités non patchées et accès non autorisé s'il n'est pas correctement sécurisé

- **Différenciez les protocoles sécurisés comme HTTPS et SFTP de leurs homologues non sécurisés**
  - HTTPS vs HTTP : HTTPS chiffre le trafic web avec SSL/TLS, empêchant l'écoute clandestine et la falsification
  - SFTP vs FTP : SFTP tunnel FTP via SSH avec chiffrement, tandis que FTP envoie identifiants et données en texte clair

- **Expliquez les avantages d'utiliser SSH pour l'accès distant sécurisé**
  - SSH fournit : communication chiffrée, authentification forte, transferts de fichiers sécurisés, capacités de redirection de ports et protection contre diverses attaques réseau

### Fondamentaux de la sécurité réseau
- **Expliquez le concept des numéros de port et leur importance dans la communication réseau**
  - Les numéros de port (0-65535) identifient des services/applications spécifiques sur un hôte, permettant à plusieurs services réseau de fonctionner simultanément sur la même adresse IP
  - Ports bien connus (0-1023) : SSH (22), HTTP (80), HTTPS (443)
  - Ports enregistrés (1024-49151) : Services spécifiques aux applications
  - Ports dynamiques/privés (49152-65535) : Connexions temporaires

- **Différenciez les différents types de protocoles de chiffrement réseau**
  - SSL/TLS : Sécurise les communications web et email
  - SSH : Sécurise l'accès distant et les transferts de fichiers
  - IPSec : Sécurise les communications IP au niveau de la couche réseau
  - WPA2/WPA3 : Sécurise les réseaux sans fil

- **Expliquez l'importance de garder les protocoles réseau à jour et patchés**
  - Prévient l'exploitation de vulnérabilités connues, protège contre les attaques zero-day, assure la compatibilité avec les standards de sécurité et maintient l'intégrité système

## Prérequis

### Environnement
- Système Linux Ubuntu/Debian
- Privilèges root/sudo pour la plupart des scripts

### Outils requis
- `grep` - Recherche de texte
- `find` - Navigation dans le système de fichiers
- `iptables` - Gestion du pare-feu
- `lynis` - Outil d'audit de sécurité
- `nmap` - Scan réseau et tests de sécurité
- `hping3` - Génération de paquets et tests
- `showmount` - Énumération des partages NFS
- `sed/awk` - Traitement de texte (optionnel)

### Commandes d'installation
```bash
# Installer les outils requis
sudo apt update
sudo apt install lynis nmap hping3 nfs-common

# Vérifier les installations
lynis --version
nmap --version
hping3 --version
showmount --version
```

## Tâches du projet

| Tâche | Script | Description | Concepts clés |
|-------|--------|-------------|---------------|
| 0 | `0-iptables.sh` | Apprendre les options iptables et bases du pare-feu | Règles de pare-feu, filtrage de paquets |
| 1 | `1-audit.sh` | Auditer la configuration SSH pour paramètres non-standard | Sécurité SSH, audit de configuration |
| 2 | `2-harden.sh` | Trouver et sécuriser les répertoires world-writable | Permissions de fichiers, prévention escalade privilèges |
| 3 | `3-identify.sh` | Exécuter audit Lynis pour identifier les vulnérabilités | Scan de sécurité, évaluation des vulnérabilités |
| 4 | `4-nfs.sh` | Scanner les partages NFS non sécurisés | Protocole NFS, risques de partage de fichiers réseau |
| 5 | `5-snmp.sh` | Auditer SNMP pour configurations d'accès public | Sécurité SNMP, chaînes de communauté |
| 6 | `6-smtp.sh` | Vérifier SMTP pour la sécurité STARTTLS | Sécurité email, chiffrement de transport |
| 7 | `7-dos.sh` | Simuler une attaque DoS sur serveur HTTP | Résilience réseau, vecteurs d'attaque |
| 8 | `8-cipher.sh` | Tester les ciphers SSL/TLS pour chiffrement faible | Cryptographie, communications sécurisées |
| 9 | `9-firewall.sh` | Implémenter règles de pare-feu basiques | Sécurité réseau, contrôle d'accès |

## Exemples d'utilisation

### Tâche 1 : Audit de configuration SSH
```bash
sudo ./1-audit.sh
# Sortie : Paramètres de configuration SSH actifs
```
**Apprentissage clé** : Comprendre quels paramètres SSH sont actifs vs commentés aide à identifier les erreurs de configuration de sécurité potentielles.

### Tâche 2 : Durcissement des permissions de répertoires
```bash
sudo ./2-harden.sh
# Trouve les répertoires world-writable et retire les permissions d'écriture pour 'others'
```
**Apprentissage clé** : Les répertoires world-writable sont des risques de sécurité - n'importe quel utilisateur peut modifier/supprimer des fichiers, conduisant potentiellement à une escalade de privilèges.

### Tâche 3 : Audit de vulnérabilités système
```bash
sudo ./3-identify.sh
# Exécute un audit de sécurité complet avec Lynis
```
**Apprentissage clé** : Les outils de sécurité automatisés comme Lynis fournissent des évaluations systématiques de vulnérabilités et des recommandations de durcissement.

### Tâche 4 : Énumération des partages NFS
```bash
sudo ./4-nfs.sh 192.168.1.100
# Liste les exports NFS et leurs permissions d'accès
```
**Apprentissage clé** : Les partages NFS accessibles par "everyone" (*) peuvent exposer des données sensibles aux utilisateurs réseau non autorisés.

### Tâche 5 : Audit de configuration SNMP
```bash
sudo ./5-snmp.sh
# Identifie les configurations SNMP avec chaînes de communauté par défaut/publiques
```
**Apprentissage clé** : Les chaînes de communauté SNMP par défaut comme "public" permettent à n'importe qui d'interroger les informations des périphériques - une vulnérabilité de sécurité majeure.

### Tâche 6 : Vérification de sécurité SMTP
```bash
sudo ./6-smtp.sh
# Vérifie si STARTTLS est configuré pour le chiffrement email
```
**Apprentissage clé** : Sans STARTTLS, les identifiants et contenus email sont transmis en texte clair, vulnérables à l'interception.

### Tâche 7 : Simulation d'attaque DoS
```bash
sudo ./7-dos.sh 192.168.1.100
# Simule une attaque SYN flood (USAGE ÉDUCATIF UNIQUEMENT)
```
**Apprentissage clé** : Comprendre les vecteurs d'attaque aide à implémenter des défenses appropriées (limitation de débit, SYN cookies, règles de pare-feu).

⚠️ **AVERTISSEMENT** : Utilisez uniquement sur des systèmes que vous possédez ou pour lesquels vous avez une permission explicite. Les attaques DoS non autorisées sont illégales.

### Tâche 8 : Test des ciphers SSL/TLS
```bash
sudo ./8-cipher.sh 192.168.1.100
# Énumère les ciphers SSL/TLS supportés et identifie les faibles
```
**Apprentissage clé** : Les ciphers faibles (DES, RC4, basés sur MD5) peuvent être cassés par les attaquants. Les systèmes modernes devraient uniquement supporter des ciphers forts (AES-GCM, ChaCha20).

### Tâche 9 : Implémentation de pare-feu
```bash
sudo ./9-firewall.sh
# Configure un pare-feu basique : autoriser SSH, bloquer tout le reste
```
**Apprentissage clé** : Les politiques par défaut de refus (bloquer tout sauf ce qui est explicitement autorisé) suivent le principe du moindre privilège.

## Considérations de sécurité

### Avertissements importants

1. **Script d'attaque DoS (Tâche 7)**
   - Utilisez UNIQUEMENT dans des environnements de laboratoire contrôlés
   - N'exécutez JAMAIS contre des systèmes de production ou des systèmes que vous ne possédez pas
   - L'utilisation non autorisée est illégale et contraire à l'éthique

2. **Scripts de pare-feu**
   - Testez d'abord dans un environnement sûr
   - Assurez-vous que l'accès SSH est autorisé avant de bloquer tout le trafic
   - Gardez une méthode d'accès de secours (console/accès physique)

3. **Modifications système**
   - Les scripts de ce projet modifient les configurations système
   - Comprenez ce que fait chaque commande avant l'exécution
   - Testez d'abord dans une VM ou environnement de laboratoire

### Bonnes pratiques démontrées

- **Principe du moindre privilège** : Autoriser uniquement les services nécessaires (Tâche 9)
- **Défense en profondeur** : Multiples couches de sécurité (pare-feu + durcissement de service)
- **Audit régulier** : Scans de sécurité automatisés (Tâche 3)
- **Chiffrement** : Toujours utiliser des protocoles chiffrés (Tâches 6, 8)
- **Durcissement de configuration** : Retirer les permissions inutiles (Tâche 2)

## Commandes et concepts clés

### grep - Correspondance de motifs
```bash
# Trouver les configurations actives (ignorer commentaires et lignes vides)
grep -Ev '^#|^$' /chemin/vers/config

# Trouver un paramètre spécifique en début de ligne
grep '^nom_parametre' /chemin/vers/config
```

### find - Recherche dans le système de fichiers
```bash
# Trouver les répertoires world-writable
find / -type d -perm -002

# Options :
# -xdev : Ne pas traverser les limites de système de fichiers
# -exec : Exécuter une commande sur les résultats
# {} + : Passer plusieurs résultats à la commande (efficace)
```

### iptables - Gestion du pare-feu
```bash
# Ajouter une règle pour autoriser un service
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Définir la politique par défaut
iptables -P INPUT DROP

# Options :
# -A : Ajouter une règle
# -P : Définir la politique
# -j : Sauter vers la cible (ACCEPT/DROP/REJECT)
```

### nmap - Scan réseau
```bash
# Scanner les ciphers SSL/TLS
nmap --script ssl-enum-ciphers -p 443 <cible>

# Les scripts NSE fournissent des tests de sécurité spécialisés
```

### hping3 - Création de paquets
```bash
# Simulation de SYN flood
hping3 -S --flood --rand-source -p 80 <cible>

# Options :
# -S : Flag SYN
# --flood : Envoyer les paquets aussi vite que possible
# --rand-source : Randomiser l'IP source
```

## Référence des ports

Ports communs rencontrés dans ce projet :

| Port | Protocole | Service | Notes de sécurité |
|------|-----------|---------|-------------------|
| 22 | TCP | SSH | Accès distant sécurisé - garder ouvert avec authentification forte |
| 25 | TCP | SMTP | Transmission email - utiliser STARTTLS |
| 80 | TCP | HTTP | Trafic web - non chiffré, utiliser HTTPS à la place |
| 161 | UDP | SNMP | Surveillance réseau - changer les chaînes de communauté par défaut |
| 443 | TCP | HTTPS | Trafic web chiffré - vérifier la force des ciphers |
| 2049 | TCP/UDP | NFS | Partage de fichiers - restreindre l'accès, utiliser NFSv4 avec Kerberos |

## Dépannage

### Erreurs de permission refusée
```bash
# La plupart des scripts nécessitent des privilèges root
sudo ./script.sh
```

### Commande introuvable
```bash
# Installer les outils manquants
sudo apt install <nom-outil>
```

### Bloqué par le pare-feu
```bash
# Si vous perdez l'accès SSH après des changements de pare-feu :
# 1. Accéder via console/accès physique
# 2. Vider les règles iptables :
sudo iptables -F
sudo iptables -P INPUT ACCEPT
```

## Ressources

- [Bonnes pratiques de configuration SSH](https://www.ssh.com/academy/ssh/sshd_config)
- [Outil d'audit de sécurité Lynis](https://cisofy.com/lynis/)
- [Guide de référence Nmap](https://nmap.org/book/man.html)
- [Tutoriel iptables](https://www.netfilter.org/documentation/)
- [Protection de la couche transport OWASP](https://owasp.org/www-project-web-security-testing-guide/)

## Auteur

Créé dans le cadre du programme Holberton School Cyber Security.

## Licence

Projet éducatif - à utiliser de manière responsable et éthique.
