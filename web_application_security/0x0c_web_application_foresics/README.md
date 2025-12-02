# 0x0c. Web Application Forensics

## Description

Ce projet se concentre sur la forensique numérique des applications web, analysant spécifiquement les logs d'authentification pour identifier les incidents de sécurité, tracer l'origine des attaques et développer des stratégies de protection. À travers l'analyse de logs, nous enquêtons sur un système compromis pour comprendre le vecteur d'attaque, identifier les activités malveillantes et établir des protocoles de surveillance de sécurité.

## Objectifs d'apprentissage

- Comprendre les fondamentaux de la forensique numérique et le processus DFIR
- Analyser les logs d'applications web pour identifier les incidents de sécurité
- Tracer l'origine des attaques à l'aide des logs d'authentification
- Identifier les comptes compromis et les modifications système non autorisées
- Développer des stratégies de réponse aux incidents et de remédiation
- Établir des protocoles de surveillance de sécurité

## Ressources

- [ressources.md](ressources.md) - Guide complet sur la forensique numérique, l'analyse de logs et la réponse aux incidents

## Prérequis

- Environnement Ubuntu/Linux
- Scripts Bash
- Fichiers de logs : `auth.log`, `dmseg`
- Outils : `grep`, `awk`, `sed`, `sort`, `uniq`, `comm`, `wc`, `paste`

## Tâches

### 0. Identification du service
**Fichier :** `0-service.sh`

Identifier quel service a été ciblé par les attaquants en analysant le fichier auth.log.

```bash
./0-service.sh
```

**Sortie attendue :** Nom du service avec la plus haute activité d'authentification (SSH/sshd)

---

### 1. Système d'exploitation
**Fichier :** `1-operating.sh`

Extraire la version du système d'exploitation depuis le fichier dmseg.

```bash
./1-operating.sh
```

**Sortie attendue :** Informations sur la version de Linux

---

### 2. Compte compromis
**Fichier :** `2-accounts.sh`

Identifier les comptes utilisateurs qui ont été compromis en trouvant les comptes ayant à la fois des tentatives d'authentification échouées et réussies (indiquant des attaques par force brute).

```bash
./2-accounts.sh
```

**Sortie attendue :** Nom(s) d'utilisateur compromis (root)

**Approche :** Utiliser `comm` pour trouver l'intersection des utilisateurs avec des tentatives de mot de passe échouées et acceptées.

---

### 3. IPs des attaquants
**Fichier :** `3-ips.sh`

Compter le nombre d'adresses IP distinctes qui se sont authentifiées avec succès en tant que root.

```bash
./3-ips.sh
```

**Sortie attendue :** 18

**Approche :** Extraire les IPs des entrées de log "Accepted password for root", dédupliquer et compter.

---

### 4. Règles de pare-feu
**Fichier :** `4-firewall.sh`

Déterminer combien de règles de pare-feu ont été ajoutées au système en analysant les commandes iptables.

```bash
./4-firewall.sh
```

**Sortie attendue :** 6

**Approche :** Rechercher les commandes `iptables -A` (append) et `iptables -I` (insert) dans auth.log.

---

### 5. Comptes utilisateurs
**Fichier :** `5-users.sh`

Lister tous les comptes utilisateurs créés sur le système.

```bash
./5-users.sh
```

**Sortie attendue :** Liste de noms d'utilisateurs séparés par des virgules
```
Aphelios,Debian-exim,Fido,Jax,Nidalee,Senna,dhg,messagebus,mysql,packet,sshd
```

**Approche :** Extraire les noms d'utilisateurs des entrées de log `useradd` avec le pattern "new user:".

---

### 6. Rapport d'incident
**Fichier :** `INCIDENT_REPORT.md`

Rapport d'incident forensique complet documentant :
- **Introduction :** Importance de l'analyse de logs pour la sécurité
- **Rapport d'incident :** Découvertes clés et évaluation de l'impact
- **Plan d'implémentation :** Approche de remédiation étape par étape (4 phases)
- **Protocole de surveillance :** Lignes directrices d'évaluation de sécurité continue

Le rapport résume l'attaque SSH par force brute, la compromission de root, les modifications système non autorisées, et fournit des recommandations actionnables pour la remédiation et la prévention.

---

## Résumé des découvertes clés

| Découverte | Détails |
|------------|---------|
| **Vecteur d'attaque** | Force brute SSH |
| **Compte compromis** | root |
| **IPs des attaquants** | 18 adresses distinctes |
| **Règles de pare-feu ajoutées** | 6 règles iptables |
| **Comptes utilisateurs créés** | 11 au total (5 comptes backdoor suspects) |
| **Sévérité** | CRITIQUE |
| **Version OS** | Ubuntu 2.6.24 (2009) - sévèrement obsolète |

## Utilisation

Tous les scripts doivent être exécutés depuis le répertoire du projet où se trouvent les fichiers de logs (`auth.log`, `dmseg`) :

```bash
# Rendre les scripts exécutables
chmod +x *.sh

# Exécuter les tâches individuelles
./0-service.sh
./1-operating.sh
./2-accounts.sh
./3-ips.sh
./4-firewall.sh
./5-users.sh

# Voir le rapport d'incident
cat INCIDENT_REPORT.md
```

## Dépôt

- **Dépôt GitHub :** `holbertonschool-cyber_security`
- **Répertoire :** `web_application_security/0x0c_web_application_foresics`

## Auteur

Équipe d'analyse de sécurité - Programme Cyber Sécurité Holberton School
