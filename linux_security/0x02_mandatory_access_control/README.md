# 0x02. Mandatory Access Control (MAC)

## Description

Ce projet explore les mecanismes de **Controle d'Acces Obligatoire (MAC)** sous Linux, principalement **SELinux** et **AppArmor**. Vous apprendrez a configurer, gerer et auditer ces systemes de securite avances qui protegent votre systeme au-dela des permissions traditionnelles (DAC).

Le MAC est une couche de securite essentielle qui confine les processus, limite les privileges et protege contre les compromissions meme avec des privileges root.

## Concepts Cles

### Qu'est-ce que le MAC ?

Le **Mandatory Access Control (MAC)** est un modele de securite ou l'acces aux ressources est controle par une **politique centralisee** que les utilisateurs ne peuvent pas modifier.

**Difference avec DAC :**

| DAC (Discretionary) | MAC (Mandatory) |
|---------------------|-----------------|
| Le proprietaire controle (chmod, chown) | La politique systeme controle |
| Root peut tout faire | Meme root est restreint |
| Permissions basiques : rwx | Labels de securite + politiques complexes |

### SELinux vs AppArmor

| Caracteristique | SELinux | AppArmor |
|----------------|---------|----------|
| **Mecanisme** | Labels (attributs etendus) | Chemins de fichiers |
| **Complexite** | Elevee | Faible a moyenne |
| **Distributions** | RHEL, Fedora, CentOS | Ubuntu, SUSE |
| **Granularite** | Tres fine | Moyenne |
| **Configuration** | Contextes (user:role:type:level) | Profils textuels |

### Composants SELinux

#### Modes de SELinux
- **Enforcing** : Politique appliquee, violations bloquees
- **Permissive** : Violations journalisees mais autorisees (debug)
- **Disabled** : SELinux desactive (non recommande)

#### Labels (Contextes)
Format : `user:role:type:level`

Exemple : `system_u:object_r:httpd_sys_content_t:s0`

#### Booleens
Interrupteurs on/off pour modifier la politique sans recompilation.

Exemple : `httpd_can_sendmail`, `httpd_enable_homedirs`

## Objectifs d'Apprentissage

A la fin de ce projet, vous serez capable d'expliquer :

- Ce qu'est le MAC sous Linux
- Comment SELinux applique le MAC
- Les differences entre SELinux et AppArmor
- Le role des politiques dans les systemes MAC
- Comment fonctionnent les labels dans SELinux
- Type Enforcement, RBAC et Multi-Level Security
- Comment verifier le statut de SELinux
- Les commandes de gestion SELinux courantes
- Comment definir les contextes de fichiers
- Ce qu'est un profil AppArmor
- Comment recharger les profils AppArmor
- Le principe du moindre privilege dans MAC
- Comment depanner les problemes SELinux
- L'importance des logs d'audit
- Le concept de capacites Linux
- Comment utiliser semanage

## Ressources

- [ressources.md](./ressources.md) - Documentation complete sur MAC, SELinux et AppArmor
- [Red Hat SELinux Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/)
- [Ubuntu AppArmor Documentation](https://ubuntu.com/server/docs/security-apparmor)
- [SELinux Project](https://github.com/SELinuxProject)

## Prerequis

- Systeme Linux (RHEL/Fedora pour SELinux, Ubuntu pour AppArmor)
- Acces root/sudo
- Connaissances de base en Bash
- Comprehension des permissions Linux de base

## Exigences

- Environnement : Ubuntu 20.04 LTS ou RHEL 8
- Tous les scripts doivent commencer par `#!/bin/bash`
- Tous les scripts doivent etre executables
- Utilisation de `semanage`, `sestatus`, `aa-status` selon les besoins
- Respect des bonnes pratiques de securite

## Structure du Projet

```
0x02_mandatory_access_control/
├── README.md
├── ressources.md
├── 0-analyse_mode.sh
├── 1-security_match.sh
├── 2-list_http.sh
├── 3-add_port.sh
├── 4-list_user.sh
├── 5-add_selinux.sh
├── 6-list_booleans.sh
└── 7-set_sendmail.sh
```

## Taches

### 0. Is your Linux feeling like Fort Knox or a wide-open saloon today?
**Fichier :** [0-analyse_mode.sh](0-analyse_mode.sh)

Script Bash qui affiche le **mode actuel de SELinux** sur le systeme.

**Commande utilisee :** `sestatus`

**Sortie exemple :**
```bash
$ sudo ./0-analyse_mode.sh
SELinux status:                 disabled
```

**Concepts :**
- Verification du statut SELinux
- Modes : Enforcing, Permissive, Disabled

---

### 1. AppArmor & SELinux: security socks - sometimes a match, sometimes a clash!
**Fichier :** [1-security_match.sh](1-security_match.sh)

Script Bash qui affiche le **statut des profils AppArmor** sur le systeme.

**Commande utilisee :** `aa-status`

**Sortie exemple :**
```bash
$ sudo ./1-security_match.sh
apparmor module is loaded.
30 profiles are loaded.
27 profiles are in enforce mode.
3 profiles are in complain mode.
```

**Concepts :**
- Profils AppArmor
- Modes enforce vs complain
- Verification du statut AppArmor

---

### 2. Sudo, show me the SELinux's secret stash of HTTP ports!
**Fichier :** [2-list_http.sh](2-list_http.sh)

Script Bash qui liste tous les **ports geres par SELinux** et filtre ceux lies aux services HTTP.

**Commandes utilisees :** `semanage port -l | grep http`

**Sortie exemple :**
```bash
$ sudo ./2-list_http.sh
http_cache_port_t              tcp      3128, 8080, 8118, 10001-10010
http_port_t                    tcp      80, 443, 488, 8008, 8009, 8443, 8448
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
```

**Concepts :**
- Gestion des ports SELinux
- Types de ports (http_port_t, http_cache_port_t)
- Filtrage avec grep

---

### 3. Adding a touch of SELinux magic to TCP port!
**Fichier :** [3-add_port.sh](3-add_port.sh)

Script Bash qui ajoute un **nouveau port SELinux** (tcp/81) au type `http_port_t`.

**Commande utilisee :** `semanage port -a -t http_port_t -p tcp 81`

**Verification :**
```bash
# Avant
$ sudo semanage port -l | grep "http_port_t"
http_port_t                    tcp      80, 443, 488, 8008, 8009, 8443, 8448

# Execution
$ sudo ./3-add_port.sh

# Apres
$ sudo semanage port -l | grep "http_port_t"
http_port_t                    tcp      81, 80, 443, 488, 8008, 8009, 8443, 8448
```

**Concepts :**
- Ajout de ports SELinux
- Options : -a (add), -t (type), -p (protocol)
- Persistance des modifications

---

### 4. SELinux: Where user mappings are the gatekeepers of the security circus!
**Fichier :** [4-list_user.sh](4-list_user.sh)

Script Bash qui liste tous les **utilisateurs SELinux** (mappings).

**Commande utilisee :** `semanage user -l`

**Sortie exemple :**
```bash
$ sudo ./4-list_user.sh

                Labeling   MLS/       MLS/
SELinux User    Prefix     MCS Level  MCS Range                      SELinux Roles

root            sysadm     s0         s0-s0:c0.c1023                 staff_r sysadm_r system_r
staff_u         staff      s0         s0-s0:c0.c1023                 staff_r sysadm_r
system_u        user       s0         s0-s0:c0.c1023                 system_r
unconfined_u    unconfined s0         s0-s0:c0.c1023                 system_r unconfined_r
user_u          user       s0         s0                             user_r
```

**Concepts :**
- Utilisateurs SELinux vs utilisateurs Linux
- Roles SELinux (RBAC)
- Niveaux MLS/MCS

---

### 5. SELinux: Where user gets his VIP pass to the security party!
**Fichier :** [5-add_selinux.sh](5-add_selinux.sh)

Script Bash qui ajoute un **mapping login** entre un utilisateur Linux et l'utilisateur SELinux `user_u`.

**Commande utilisee :** `semanage login -a -s user_u $1`

**Usage :**
```bash
$ sudo ./5-add_selinux.sh alice
```

**Verification :**
```bash
# Avant
$ sudo semanage login -l
Login Name           SELinux User         MLS/MCS Range        Service
__default__          unconfined_u         s0-s0:c0.c1023       *
root                 unconfined_u         s0-s0:c0.c1023       *

# Apres
$ sudo semanage login -l
Login Name           SELinux User         MLS/MCS Range        Service
__default__          unconfined_u         s0-s0:c0.c1023       *
alice                user_u               s0                   *
root                 unconfined_u         s0-s0:c0.c1023       *
```

**Concepts :**
- Mapping utilisateur Linux → utilisateur SELinux
- Confinement des utilisateurs
- Arguments de script ($1)

---

### 6. SELinux booleans: where security settings get sassy!
**Fichier :** [6-list_booleans.sh](6-list_booleans.sh)

Script Bash qui liste tous les **booleens SELinux** definis sur le systeme.

**Commande utilisee :** `semanage boolean -l`

**Sortie exemple :**
```bash
$ sudo ./6-list_booleans.sh
SELinux boolean                State  Default Description

aide_mmap_files                (off  ,  off)  Control if AIDE can mmap files...
allow_cvs_read_shadow          (off  ,  off)  Determine whether cvs can read shadow...
httpd_can_sendmail             (off  ,  off)  Determine whether httpd can send mail.
httpd_enable_homedirs          (off  ,  off)  Allow httpd to read home directories
...
```

**Concepts :**
- Booleens SELinux (interrupteurs on/off)
- State vs Default
- Modification de la politique sans recompilation

---

### 7. Sending emails with SELinux? Don't mind if we do!
**Fichier :** [7-set_sendmail.sh](7-set_sendmail.sh)

Script Bash qui active le booleen SELinux `httpd_can_sendmail` de maniere **permanente**.

**Commande utilisee :** `setsebool -P httpd_can_sendmail on`

**Verification :**
```bash
# Execution
$ sudo ./7-set_sendmail.sh

# Verification
$ sudo semanage boolean -lC
SELinux boolean                State  Default Description
httpd_can_sendmail             (on   ,   on)  Determine whether httpd can send mail.
```

**Concepts :**
- Activation de booleens
- Option -P pour persistance (survit aux redemarrages)
- Verification avec semanage boolean -lC (customized only)

---

## Commandes Essentielles

### SELinux

| Commande | Description | Exemple |
|----------|-------------|---------|
| `sestatus` | Afficher le statut SELinux | `sestatus` |
| `getenforce` | Afficher le mode actuel | `getenforce` |
| `setenforce` | Changer le mode (temporaire) | `setenforce 0` |
| `semanage port -l` | Lister les ports | `semanage port -l | grep http` |
| `semanage port -a` | Ajouter un port | `semanage port -a -t http_port_t -p tcp 81` |
| `semanage user -l` | Lister les utilisateurs SELinux | `semanage user -l` |
| `semanage login -l` | Lister les mappings login | `semanage login -l` |
| `semanage login -a` | Ajouter un mapping | `semanage login -a -s user_u alice` |
| `semanage boolean -l` | Lister les booleens | `semanage boolean -l` |
| `setsebool` | Modifier un booleen | `setsebool -P httpd_can_sendmail on` |
| `getsebool` | Afficher un booleen | `getsebool httpd_can_sendmail` |

### AppArmor

| Commande | Description | Exemple |
|----------|-------------|---------|
| `aa-status` | Afficher le statut AppArmor | `aa-status` |
| `aa-enforce` | Mettre un profil en mode enforce | `aa-enforce /usr/bin/firefox` |
| `aa-complain` | Mettre un profil en mode complain | `aa-complain /usr/bin/firefox` |
| `apparmor_parser -r` | Recharger un profil | `apparmor_parser -r /etc/apparmor.d/usr.bin.firefox` |

## Principe du Moindre Privilege

> Chaque processus doit avoir uniquement les permissions minimales strictement necessaires pour accomplir sa tache, rien de plus.

**Exemple SELinux :**
```
Processus Apache (httpd_t) :
✓ Peut lire /var/www/html/ (httpd_sys_content_t)
✓ Peut ecrire /var/log/httpd/ (httpd_log_t)
✗ Ne peut PAS lire /etc/shadow (shadow_t)
✗ Ne peut PAS ecrire /home/user/ (user_home_t)
```

Meme si Apache tourne en root, SELinux l'empeche d'acceder aux ressources non autorisees !

## Depannage

### SELinux ne fonctionne pas ?

1. **Verifier le mode :**
```bash
getenforce
```

2. **Passer en permissive pour tester :**
```bash
sudo setenforce 0
# Tester l'application
sudo setenforce 1
```

3. **Consulter les logs :**
```bash
sudo ausearch -m avc -ts recent
```

### semanage : command not found ?

**Installer les outils :**
```bash
# RHEL/Fedora/CentOS
sudo dnf install policycoreutils-python-utils

# Debian/Ubuntu
sudo apt install policycoreutils-python-utils
```

### AppArmor bloque une application ?

1. **Mettre en mode complain :**
```bash
sudo aa-complain /usr/bin/application
```

2. **Analyser les logs :**
```bash
sudo aa-logprof
```

3. **Remettre en enforce :**
```bash
sudo aa-enforce /usr/bin/application
```

## Bonnes Pratiques

1. **Ne JAMAIS desactiver MAC en production**
   - Plutot ajuster la politique
   - Utiliser le mode permissive/complain pour debugger

2. **Toujours tester avant d'appliquer**
   - Utiliser `-P` avec `setsebool` pour persistance
   - Verifier avec `semanage ... -lC` les modifications personnalisees

3. **Documenter les changements**
   - Noter pourquoi un booleen est active
   - Garder trace des ports ajoutes

4. **Auditer regulierement**
   - Verifier les logs d'audit
   - Lister les booleens actifs
   - Controler les mappings utilisateurs

## Securite

**Attention :** Les modifications de politiques MAC peuvent :
- Bloquer des services critiques si mal configurees
- Creer des trous de securite si trop permissives
- Necessite des privileges root/sudo

**Recommandations :**
- Tester en environnement de dev d'abord
- Utiliser le mode permissive pour observer
- Lire la documentation avant de modifier

## Auteur

Projet realise dans le cadre de la formation **Holberton School - Cyber Security**

## Repository

- **GitHub repository:** `holbertonschool-cyber_security`
- **Directory:** `linux_security/0x02_mandatory_access_control`

---

**Note :** Ce projet est a but educatif. Les techniques apprises doivent etre utilisees de maniere responsable et ethique, uniquement sur des systemes dont vous avez l'autorisation.
