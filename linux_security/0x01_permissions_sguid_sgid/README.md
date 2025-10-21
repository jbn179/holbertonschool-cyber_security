# 0x01. Permissions, SUID & SGID

## Description

Ce projet explore en profondeur le système de permissions Linux, avec un focus particulier sur les permissions spéciales (SUID, SGID et Sticky Bit). À travers une série de scripts Bash, vous apprendrez à gérer les utilisateurs, les groupes, et à manipuler les permissions pour sécuriser et auditer un système Linux.

Les permissions spéciales constituent une couche de contrôle avancée au-delà des permissions de base (lecture, écriture, exécution). Elles permettent une gestion granulaire des privilèges et sont essentielles pour la sécurité des systèmes multi-utilisateurs.

## Concepts Clés

### Permissions Spéciales Linux

#### SUID (Set User ID) - Bit 4000
- Appliqué à un fichier exécutable
- Permet l'exécution avec les privilèges du **propriétaire** du fichier
- Représentation : `s` dans les permissions utilisateur (ex: `-rwsr-xr-x`)
- Cas d'usage : `/usr/bin/passwd` qui doit modifier `/etc/shadow` (fichier root)
- **Risque de sécurité** : Élévation de privilèges si le programme est vulnérable

#### SGID (Set Group ID) - Bit 2000
- **Sur un fichier** : Exécution avec les privilèges du **groupe** propriétaire
- **Sur un répertoire** : Les nouveaux fichiers héritent du groupe du répertoire parent
- Représentation : `s` dans les permissions groupe (ex: `-rwxr-sr-x`)
- Cas d'usage : Répertoires collaboratifs où tous les fichiers doivent appartenir au même groupe

#### Sticky Bit - Bit 1000
- S'applique uniquement aux **répertoires**
- Restreint la suppression : seul le propriétaire peut supprimer ses fichiers
- Représentation : `t` dans les permissions autres (ex: `drwxrwxrwt`)
- Cas d'usage : `/tmp` où plusieurs utilisateurs créent des fichiers temporaires

### Commandes Essentielles

| Commande | Fonction | Exemple |
|----------|----------|---------|
| `chmod` | Modifier les permissions | `chmod u+s fichier`, `chmod 4755 fichier` |
| `chown` | Changer le propriétaire | `chown user3 fichier` |
| `chgrp` | Changer le groupe | `chgrp admin fichier` |
| `find` | Rechercher des fichiers | `find / -perm -4000` |
| `adduser` | Créer un utilisateur (interactif) | `adduser alice` |
| `useradd` | Créer un utilisateur (système) | `useradd -m alice` |
| `addgroup` | Créer un groupe | `addgroup developers` |

### Notation des Permissions

#### Symbolique
```bash
chmod u+s fichier    # Ajouter SUID
chmod g+s répertoire # Ajouter SGID
chmod o+t répertoire # Ajouter Sticky Bit
chmod o-wx fichier   # Retirer write et execute pour others
```

#### Octale (4 chiffres)
```
[Spécial][User][Group][Others]
   4000   + 755  = 4755  (SUID + rwxr-xr-x)
   2000   + 770  = 2770  (SGID + rwxrwx---)
   1000   + 777  = 1777  (Sticky + rwxrwxrwx)
```

## Ressources

- [Permissions Linux - Guide complet](./ressources.md)
- [chmod man page](https://man7.org/linux/man-pages/man1/chmod.1.html)
- [find man page](https://man7.org/linux/man-pages/man1/find.1.html)
- [Understanding SUID, SGID and Sticky Bit](https://www.redhat.com/sysadmin/suid-sgid-sticky-bit)

## Objectifs d'Apprentissage

À la fin de ce projet, vous serez capable de :

- Comprendre et expliquer le système de permissions Linux (rwx)
- Identifier et manipuler les permissions spéciales (SUID, SGID, Sticky Bit)
- Utiliser `find` avec des options avancées pour auditer la sécurité
- Gérer les utilisateurs et groupes Linux
- Configurer `sudo` et comprendre les risques de sécurité
- Automatiser la gestion des permissions avec des scripts Bash
- Identifier les vulnérabilités liées aux permissions mal configurées

## Prérequis

- Système Linux (Ubuntu/Debian recommandé)
- Accès root/sudo
- Connaissances de base en Bash
- Compréhension des concepts de base Linux

## Exigences

- Tous les scripts doivent commencer par `#!/bin/bash`
- Tous les scripts doivent être exécutables
- La longueur des fichiers doit être de **2 lignes maximum**
- Utiliser les redirections d'erreurs quand nécessaire (`2>/dev/null`)
- Suivre les bonnes pratiques de sécurité

## Structure du Projet

```
0x01_permissions_sguid_sgid/
├── README.md
├── ressources.md
├── 0-add_user.sh
├── 1-add_group.sh
├── 2-sudo_nopass.sh
├── 3-find_files.sh
├── 4-find_suid.sh
├── 5-find_sgid.sh
├── 6-check_files.sh
├── 7-file_read.sh
├── 8-change_user.sh
└── 9-empty_file.sh
```

## Tâches

### 0. Create a new user
**Fichier :** `0-add_user.sh`

Crée un nouveau compte utilisateur.
- Accepte le nom d'utilisateur en argument `$1`
- Utilise `useradd` ou `adduser`

```bash
sudo ./0-add_user.sh alice
```

---

### 1. Create a new group and add user
**Fichier :** `1-add_group.sh`

Crée un nouveau groupe et y ajoute un utilisateur.
- Accepte le nom du groupe en argument `$1`
- Accepte le nom d'utilisateur en argument `$2`

```bash
sudo ./1-add_group.sh developers alice
```

---

### 2. Grant sudo privileges without password
**Fichier :** `2-sudo_nopass.sh`

Configure les permissions sudo sans mot de passe pour un utilisateur.
- Accepte le nom d'utilisateur en argument `$1`
- Modifie `/etc/sudoers` pour ajouter `NOPASSWD`

```bash
sudo ./2-sudo_nopass.sh alice
```

**⚠️ Attention :** Utiliser `visudo` en production pour éviter les erreurs de syntaxe.

---

### 3. Find files with SUID vulnerabilities
**Fichier :** `3-find_files.sh`

Recherche les fichiers avec SUID dans un répertoire spécifié.
- Accepte le répertoire cible en argument `$1`
- Affiche les détails des fichiers (format `ls -l`)
- Supprime les erreurs de l'affichage

```bash
sudo ./3-find_files.sh /usr/bin
```

**Sortie attendue :**
```
-rwsr-xr-x 1 root root 76096 Aug 20 20:14 /usr/bin/su
-rwsr-xr-x 1 root root 68248 Mar 23  2023 /usr/bin/passwd
...
```

**Concepts utilisés :**
- `find` avec `-perm -4000`
- `-exec ls -l {} \;`
- Redirection des erreurs `2>/dev/null`

---

### 4. List files with SUID
**Fichier :** `4-find_suid.sh`

Liste tous les fichiers avec SUID dans un répertoire.
- Accepte le répertoire en argument `$1`
- Affiche uniquement les chemins (pas les détails)

```bash
sudo ./4-find_suid.sh Security
```

**Sortie attendue :**
```
Security/holberton.sh
Security/flag.txt
```

**Différence avec la tâche 3 :**
- Tâche 3 : affichage détaillé (`ls -l`)
- Tâche 4 : affichage simple (chemins uniquement)

---

### 5. List files with SGID
**Fichier :** `5-find_sgid.sh`

Liste tous les fichiers avec SGID dans un répertoire.
- Accepte le répertoire en argument `$1`
- Similaire à la tâche 4, mais pour SGID (bit 2000)

```bash
sudo ./5-find_sgid.sh Security
```

---

### 6. Check files modified in last 24h with SUID/SGID
**Fichier :** `6-check_files.sh`

Trouve les fichiers modifiés dans les dernières 24h avec SUID ou SGID.
- Accepte le répertoire en argument `$1`
- Utilise `-mtime -1` pour filtrer par date
- Affiche les détails des fichiers

```bash
sudo ./6-check_files.sh Security
```

**Sortie attendue :**
```
---S------ 1 maroua maroua 0 Jan  3 11:26 Security/100-flag.txt
```

**Concepts utilisés :**
- Combinaison de filtres : `-perm /6000` (SUID OU SGID)
- Filtrage temporel : `-mtime -1`
- Groupement avec parenthèses : `\( -perm /4000 -o -perm /2000 \)`

---

### 7. Set read-only permissions for others
**Fichier :** `7-file_read.sh`

Change les permissions de tous les fichiers d'un répertoire en lecture seule pour "others".
- Accepte le répertoire en argument `$1`
- Ne modifie pas les permissions du propriétaire/groupe
- Résultat : others ont uniquement `r--`

```bash
sudo ./7-file_read.sh Security/
```

**Avant :**
```
-rwxrwxr-x 1 maroua maroua 33 Dec 19 11:00 0-arpscan.sh
```

**Après :**
```
-rwxrwxr-- 1 maroua maroua 33 Dec 19 11:00 0-arpscan.sh
```

**Solution :** `chmod o-wx` (retire write et execute pour others)

---

### 8. Change owner conditionally
**Fichier :** `8-change_user.sh`

Change le propriétaire de `user2` vers `user3`, uniquement pour les fichiers appartenant à `user2`.
- Accepte le répertoire en argument `$1`
- Utilise `find -user` pour filtrer par propriétaire

```bash
sudo ./8-change_user.sh Security/
```

**Avant :**
```
-rwxrwxr-- 1 user2 maroua 33 Dec 19 11:00 0-arpscan.sh
```

**Après :**
```
-rwxrwxr-- 1 user3 maroua 33 Dec 19 11:00 0-arpscan.sh
```

**Concepts utilisés :**
- `find -user user2` : filtrer par propriétaire
- `chown user3` : changer le propriétaire

---

### 9. Full permissions for empty files
**Fichier :** `9-empty_file.sh`

Trouve tous les fichiers vides et leur donne des permissions complètes (777).
- Accepte le répertoire en argument `$1`
- Utilise `-empty` pour trouver les fichiers vides

```bash
sudo ./9-empty_file.sh Security/
```

**Avant :**
```
-rw-r--r-- 1 maroua maroua 0 Dec 20 09:40 cybersecurity.txt
```

**Après :**
```
-rwxrwxrwx 1 maroua maroua 0 Jan  3 14:16 cybersecurity.txt
```

**Note :** `-empty` est plus explicite et portable que `-size 0`

---

## Techniques Avancées de `find`

### Opérateurs de Permissions

```bash
# Exactement ces permissions
find . -perm 755

# Au moins ces bits sont activés
find . -perm -755

# N'importe lequel de ces bits est activé
find . -perm /755
```

### Combinaison de Conditions

```bash
# ET logique (par défaut)
find . -type f -size +1M

# OU logique avec -o
find . -name "*.txt" -o -name "*.sh"

# Groupement avec parenthèses
find . \( -name "*.txt" -o -name "*.sh" \) -mtime -1
```

### Options d'Exécution

```bash
# Exécuter une commande par fichier
find . -type f -exec chmod 644 {} \;

# Exécuter avec plusieurs fichiers à la fois (plus rapide)
find . -type f -exec chmod 644 {} +

# Affichage détaillé intégré
find . -type f -ls
```

## Considérations de Sécurité

### Risques des Permissions Spéciales

1. **SUID sur des fichiers non sécurisés**
   - Peut permettre une escalade de privilèges
   - Auditer régulièrement avec `find / -perm -4000`

2. **SGID mal configuré**
   - Partage involontaire de fichiers sensibles
   - Vérifier les répertoires avec `find / -perm -2000`

3. **Sudo sans mot de passe**
   - Compromission complète du système si le compte est piraté
   - Utiliser uniquement pour des tâches spécifiques

### Bonnes Pratiques

- Utiliser `visudo` pour modifier `/etc/sudoers`
- Limiter les permissions SUID/SGID au strict nécessaire
- Auditer régulièrement les fichiers avec permissions spéciales
- Ne jamais donner 777 sur des fichiers sensibles
- Documenter toutes les modifications de permissions

## Exemples Pratiques

### Audit de Sécurité Complet

```bash
# Trouver tous les fichiers SUID/SGID
find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -ldb {} \; 2>/dev/null

# Trouver les fichiers world-writable
find / -type f -perm -002 -exec ls -l {} \; 2>/dev/null

# Trouver les fichiers sans propriétaire
find / -nouser -o -nogroup 2>/dev/null
```

### Gestion de Projet Collaboratif

```bash
# Créer un répertoire de projet avec SGID
mkdir /projet
chgrp developers /projet
chmod 2775 /projet

# Maintenant tous les fichiers créés appartiendront au groupe developers
```

### Nettoyage de Fichiers Temporaires

```bash
# Trouver et supprimer les fichiers vides de plus de 30 jours
find /tmp -type f -empty -mtime +30 -delete

# Trouver les fichiers temporaires volumineux
find /tmp -type f -size +100M -mtime +7 -exec ls -lh {} \;
```

## Débogage

### Problèmes Courants

**Le script ne trouve rien :**
- Vérifiez que vous utilisez `sudo` si nécessaire
- Testez sans `2>/dev/null` pour voir les erreurs
- Vérifiez que les fichiers existent avec les permissions attendues

**Permission denied :**
- Assurez-vous d'exécuter avec `sudo` pour les opérations système
- Vérifiez que le script est exécutable : `chmod +x script.sh`

**Syntaxe find incorrecte :**
- Échappez les parenthèses : `\(` et `\)`
- Terminez `-exec` avec `\;` ou `+`
- Placez `2>/dev/null` à la fin de la commande complète

## Auteur

Projet réalisé dans le cadre de la formation **Holberton School - Cyber Security**

## Repository

- **GitHub repository:** `holbertonschool-cyber_security`
- **Directory:** `linux_security/0x01_permissions_sguid_sgid`

---

**Note :** Ce projet est à but éducatif. Les techniques apprises doivent être utilisées de manière responsable et éthique, uniquement sur des systèmes dont vous avez l'autorisation.
