# 0x0B - Réponse Rapide aux Incidents d'Applications Web

## 📋 Description

Ce projet se concentre sur les compétences essentielles de **réponse rapide aux incidents** pour les applications web. À travers l'analyse forensique de logs d'attaque réels, vous apprendrez à identifier, contenir et documenter une attaque par déni de service (DoS) en utilisant des outils en ligne de commande Bash.

Le projet simule une situation réelle où une application web a été ciblée par une attaque DoS, et vous devez analyser les logs pour déterminer l'origine de l'attaque, sa nature et son ampleur.

## 🎯 Objectifs d'Apprentissage

À la fin de ce projet, vous serez capable d'expliquer à quiconque, **sans l'aide de Google** :

### Concepts de Base

- **Qu'est-ce qu'une attaque par déni de service (DoS) ?**
  - Comment elle fonctionne
  - Quelle est sa différence avec une attaque DDoS
  - Comment la détecter dans les logs

- **Comment analyser des logs d'application web ?**
  - Structure des logs au format Apache/Nginx
  - Identification des patterns suspects
  - Extraction d'informations critiques

- **Qu'est-ce qu'une réponse aux incidents ?**
  - Les 6 phases du cycle de réponse aux incidents
  - Pourquoi la rapidité est cruciale
  - Comment documenter un incident

### Compétences Techniques

- **Analyse de logs avec Bash**
  - Utilisation de `awk` pour traiter des données structurées
  - Utilisation de `grep` pour filtrer des informations
  - Pipeline de commandes pour l'analyse forensique

- **Identification des Indicateurs de Compromission (IOCs)**
  - Adresses IP suspectes
  - User-Agents anormaux
  - Patterns d'attaque

- **Documentation professionnelle**
  - Rédaction d'un rapport d'incident
  - Présentation des preuves techniques
  - Recommandations de mitigation

## 📚 Concepts Abordés

### 1. Attaque par Déni de Service (DoS)

Une **attaque DoS** vise à rendre une application ou un service indisponible pour ses utilisateurs légitimes en saturant ses ressources (CPU, mémoire, bande passante).

**Caractéristiques d'une attaque DoS :**
- Volume élevé de requêtes en peu de temps
- Souvent automatisée (scripts, bots)
- Cible généralement des endpoints critiques
- Peut provenir d'une seule source (DoS) ou multiples (DDoS)

**Dans ce projet :**
- Source unique : 1 adresse IP
- Volume : 5 000 requêtes
- Cible : Endpoint racine (`/`)
- Outil : Script Python (python-requests)

### 2. Analyse Forensique de Logs

L'**analyse forensique** consiste à examiner des données après un incident pour comprendre ce qui s'est passé, comment, et par qui.

**Format des logs web (Apache/Nginx) :**
```
IP - - [Date:Heure] "METHODE URL HTTP/VERSION" CODE TAILLE "REFERRER" "USER-AGENT"
```

**Exemple réel de ce projet :**
```
54.145.34.34 - - [14/Jun/2024:17:26:35 +0000] "POST / HTTP/1.1" 200 1941 "-" "python-requests/2.31.0" "-"
```

**Éléments clés à analyser :**
- **IP source** : Qui fait la requête ?
- **Date/Heure** : Quand l'attaque a-t-elle eu lieu ?
- **Méthode HTTP** : GET, POST, etc.
- **URL** : Quel endpoint est ciblé ?
- **Code de statut** : 200 (succès), 404 (non trouvé), 500 (erreur serveur)
- **User-Agent** : Quel client/outil est utilisé ?

### 3. Outils de Ligne de Commande

#### AWK - Traitement de Données Structurées

`awk` est un langage de programmation conçu pour traiter des fichiers texte structurés en colonnes.

**Syntaxe de base :**
```bash
awk '{print $1}' fichier.txt     # Affiche la 1ère colonne
awk -F':' '{print $1}' fichier   # Utilise ':' comme séparateur
```

**Dans ce projet :**
```bash
# Extraire les adresses IP (1ère colonne)
awk '{print $1}' logs.txt

# Extraire les requêtes HTTP (entre guillemets)
awk -F'"' '{print $2}' logs.txt
```

**Pourquoi AWK plutôt que GREP ?**
- Plus adapté aux données en colonnes
- Plus rapide pour extraire des champs spécifiques
- Code plus lisible et maintenable

#### GREP - Recherche et Filtrage

`grep` recherche des patterns dans des fichiers.

**Options utiles :**
- `-c` : Compte les lignes correspondantes
- `-o` : Affiche uniquement la partie correspondante
- `-E` : Active les expressions régulières étendues

**Dans ce projet :**
```bash
# Compter les requêtes d'une IP spécifique
grep -c "^54.145.34.34" logs.txt

# Filtrer les logs de l'attaquant
grep "^54.145.34.34" logs.txt
```

#### Pipeline Unix

Le **pipeline** (`|`) permet de chaîner des commandes.

**Exemple du projet :**
```bash
awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1
```

**Décomposition :**
1. `awk '{print $1}'` → Extrait les IPs
2. `sort` → Trie les IPs
3. `uniq -c` → Compte les occurrences uniques
4. `sort -nr` → Trie numériquement en ordre décroissant
5. `head -n 1` → Prend la première ligne (IP avec le plus de requêtes)

### 4. Indicateurs de Compromission (IOCs)

Les **IOCs** sont des éléments techniques qui indiquent qu'un incident s'est produit.

**IOCs identifiés dans ce projet :**

| Type | Valeur | Signification |
|------|--------|---------------|
| **IP Source** | 54.145.34.34 | Adresse de l'attaquant (AWS EC2) |
| **User-Agent** | python-requests/2.31.0 | Outil utilisé (script Python) |
| **Méthode HTTP** | POST | Type de requête |
| **Endpoint** | / | Cible de l'attaque |
| **Volume** | 5000 requêtes | Ampleur de l'attaque |
| **Pattern** | Requêtes rapides successives | Comportement automatisé |

**Utilité des IOCs :**
- Bloquer l'attaquant (firewall, WAF)
- Détecter des attaques similaires futures
- Partager avec la communauté (threat intelligence)
- Documentation légale

### 5. Cycle de Réponse aux Incidents

Le cycle de réponse aux incidents suit **6 phases** (basé sur NIST SP 800-61) :

#### Phase 1 : Préparation
- Mettre en place des outils de surveillance
- Former l'équipe
- Créer des playbooks

#### Phase 2 : Détection et Analyse
**C'est la phase couverte par ce projet !**
- Analyser les logs
- Identifier l'attaquant
- Déterminer la portée de l'attaque

#### Phase 3 : Confinement
- Bloquer l'IP attaquante
- Isoler les systèmes compromis
- Empêcher la propagation

#### Phase 4 : Éradication
- Supprimer la cause de l'incident
- Corriger les vulnérabilités
- Nettoyer les systèmes

#### Phase 5 : Récupération
- Restaurer les services
- Surveiller activement
- Valider le retour à la normale

#### Phase 6 : Leçons Apprises
- Documenter l'incident
- Améliorer les processus
- Mettre à jour les défenses

### 6. Mitigation d'Attaques DoS

#### Rate Limiting

Le **rate limiting** limite le nombre de requêtes par IP/utilisateur sur une période donnée.

**Exemple Nginx :**
```nginx
http {
    limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;

    server {
        location / {
            limit_req zone=mylimit burst=20 nodelay;
        }
    }
}
```

**Explication :**
- `rate=10r/s` : Maximum 10 requêtes par seconde
- `burst=20` : Autorise des pics temporaires de 20 requêtes
- `nodelay` : Rejette immédiatement l'excès

#### Web Application Firewall (WAF)

Un **WAF** filtre le trafic HTTP/HTTPS malveillant avant qu'il n'atteigne l'application.

**Solutions courantes :**
- CloudFlare (cloud)
- AWS WAF (cloud)
- ModSecurity (open-source)

**Avantages :**
- Protection contre les attaques courantes (OWASP Top 10)
- Blocage d'IPs suspectes
- Rate limiting intégré
- Protection DDoS

#### Surveillance et Alertes

**Outils recommandés :**
- **SIEM** : Splunk, ELK Stack, Graylog
- **Monitoring** : Prometheus, Grafana, Datadog
- **IDS/IPS** : Snort, Suricata, Fail2Ban

**Métriques à surveiller :**
- Requêtes par seconde (RPS) par IP
- Taux d'erreurs HTTP
- Latence moyenne
- Utilisation CPU/Mémoire

## 🛠️ Technologies Utilisées

- **Bash** : Scripting pour l'automatisation
- **AWK** : Traitement de données structurées
- **GREP** : Recherche et filtrage de patterns
- **Sort/Uniq** : Tri et dédoublonnage
- **Logs Apache/Nginx** : Analyse forensique

## 📁 Structure du Projet

```
0x0b_web_application_fast_incident_response/
├── README.md                       # Ce fichier
├── ressources.md                   # Guide complet de réponse aux incidents
├── logs.txt                        # Logs d'attaque à analyser (533 Ko)
├── 0-attack_ip.sh                  # Script : Identifier l'IP attaquante
├── 1-endpoint.sh                   # Script : Identifier l'endpoint ciblé
├── 2-count_attack.sh               # Script : Compter les requêtes
├── 3-library.sh                    # Script : Identifier l'outil utilisé
├── INCIDENT_REPORT.md              # Rapport d'incident détaillé (Markdown)
├── INCIDENT_REPORT_FINAL.txt       # Rapport d'incident (texte brut)
└── INCIDENT_REPORT.html            # Rapport d'incident (HTML formaté)
```

## 📝 Tâches du Projet

### Tâche 0 : Identifier l'IP Source de l'Attaque
**Fichier :** `0-attack_ip.sh`

**Objectif :** Créer un script Bash qui identifie l'adresse IP responsable du plus grand nombre de requêtes dans le fichier de logs.

**Fonctionnalité :**
- Extraire les adresses IP du fichier de logs
- Compter les occurrences de chaque IP
- Identifier et afficher l'IP avec le plus de requêtes

**Résultat attendu :**
```bash
$ ./0-attack_ip.sh
54.145.34.34
```

**Script :**
```bash
#!/bin/bash
awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
```

**Explication technique :**
1. `awk '{print $1}'` : Extrait la première colonne (IP)
2. `sort` : Trie les IPs
3. `uniq -c` : Compte les occurrences uniques
4. `sort -nr` : Trie numériquement en ordre décroissant
5. `head -n 1` : Prend la première ligne
6. `awk '{print $2}'` : Affiche la deuxième colonne (l'IP)

---

### Tâche 1 : Identifier l'Endpoint Attaqué
**Fichier :** `1-endpoint.sh`

**Objectif :** Trouver l'endpoint (URL) qui a reçu le plus de requêtes, indiquant qu'il était la cible de l'attaque.

**Fonctionnalité :**
- Extraire les URLs demandées du fichier de logs
- Compter les occurrences de chaque endpoint
- Identifier l'endpoint le plus fréquemment demandé

**Résultat attendu :**
```bash
$ ./1-endpoint.sh
/
```

**Script :**
```bash
#!/bin/bash
awk -F'"' '{print $2}' logs.txt | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
```

**Explication technique :**
1. `awk -F'"' '{print $2}'` : Utilise `"` comme délimiteur, extrait le contenu entre les premières guillemets (la requête HTTP)
2. `awk '{print $2}'` : Extrait le deuxième mot (l'URL)
3. `sort | uniq -c` : Compte les occurrences
4. `sort -nr | head -n 1` : Trouve le plus fréquent
5. `awk '{print $2}'` : Affiche l'URL

---

### Tâche 2 : Compter les Requêtes de l'Attaquant
**Fichier :** `2-count_attack.sh`

**Objectif :** Déterminer combien de requêtes l'attaquant a envoyées, où l'attaquant est identifié comme l'IP avec le plus de requêtes.

**Fonctionnalité :**
- Identifier l'IP avec le plus de requêtes (l'attaquant)
- Compter le nombre total de requêtes faites par cette IP

**Résultat attendu :**
```bash
$ ./2-count_attack.sh
5000
```

**Script :**
```bash
#!/bin/bash
grep -c "^$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')" logs.txt
```

**Explication technique :**
1. `$(...)` : Sous-commande qui identifie l'IP de l'attaquant (même logique que tâche 0)
2. `grep -c "^$ATTACKER_IP"` : Compte les lignes commençant par cette IP
3. `-c` : Option de grep pour compter au lieu d'afficher

---

### Tâche 3 : Identifier la Bibliothèque Utilisée
**Fichier :** `3-library.sh`

**Objectif :** Découvrir quel outil ou bibliothèque l'attaquant a utilisé en analysant les chaînes User-Agent.

**Fonctionnalité :**
- Filtrer les logs pour les requêtes de l'attaquant
- Extraire et compter les chaînes User-Agent
- Identifier l'outil/bibliothèque utilisé

**Résultat attendu :**
```bash
$ ./3-library.sh
python-requests/2.31.0
```

**Script :**
```bash
#!/bin/bash
grep "^$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')" logs.txt | awk -F'"' '{print $6}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
```

**Explication technique :**
1. `grep "^$ATTACKER_IP"` : Filtre uniquement les logs de l'attaquant
2. `awk -F'"' '{print $6}'` : Extrait le 6ème champ délimité par `"` (le User-Agent)
3. `sort | uniq -c | sort -nr` : Compte et trie
4. `head -n 1 | awk '{print $2}'` : Affiche le User-Agent le plus fréquent

---

## 🔐 Exigences Techniques

### Général
- **Éditeurs autorisés :** vi, vim, emacs
- **Environnement de test :** Kali Linux
- **Fin de ligne :** Tous les fichiers doivent se terminer par une nouvelle ligne
- **Shebang :** La première ligne de tous les scripts doit être `#!/bin/bash`
- **README.md :** Obligatoire à la racine du projet
- **Restrictions :** Pas d'utilisation de backticks (`` ` ``), `&&`, `||` ou `;`
- **Permissions :** Tous les fichiers doivent être exécutables

### Format des Scripts

**Structure requise :**
```bash
#!/bin/bash
commande1 | commande2 | commande3
```

**Pas de :**
```bash
#!/bin/bash
var=$(commande1)
commande2 $var
```

## 📖 Ressources Complémentaires

### Documentation Officielle
- [NIST SP 800-61 Rev. 2](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final) - Guide de gestion des incidents
- [MITRE ATT&CK](https://attack.mitre.org/) - Framework des tactiques et techniques d'attaque
- [OWASP](https://owasp.org/) - Top 10 des vulnérabilités web

### Tutoriels et Guides
- [AWK Tutorial](https://www.grymoire.com/Unix/Awk.html) - Guide complet sur AWK
- [Bash Scripting Tutorial](https://linuxconfig.org/bash-scripting-tutorial) - Bases du scripting Bash
- [Log Analysis Guide](https://www.loggly.com/ultimate-guide/analyzing-linux-logs/) - Analyse de logs sous Linux

### Outils Utiles
- **GoAccess** - Analyseur de logs en temps réel
- **AWStats** - Statistiques web avancées
- **Fail2Ban** - Prévention d'intrusions

## 🎓 Compétences Acquises

Après avoir complété ce projet, vous aurez développé :

### Compétences Techniques
✅ Maîtrise de l'analyse de logs avec Bash
✅ Utilisation experte de AWK pour le traitement de données
✅ Compréhension des pipelines Unix
✅ Extraction d'IOCs (Indicators of Compromise)
✅ Scripting Bash pour l'automatisation

### Compétences en Cybersécurité
✅ Identification d'attaques DoS
✅ Analyse forensique de logs
✅ Documentation d'incidents de sécurité
✅ Compréhension du cycle de réponse aux incidents
✅ Recommandations de mitigation

### Compétences Professionnelles
✅ Rédaction de rapports techniques
✅ Présentation de preuves forensiques
✅ Communication d'incidents de sécurité
✅ Pensée analytique et résolution de problèmes

## 🚀 Pour Aller Plus Loin

### Projets Supplémentaires

1. **Automatiser la Détection**
   - Créer un script de monitoring en temps réel
   - Envoyer des alertes par email lors d'anomalies
   - Bloquer automatiquement les IPs suspectes

2. **Visualisation des Données**
   - Générer des graphiques avec gnuplot
   - Créer un dashboard avec Grafana
   - Cartographier les attaques par géolocalisation

3. **Améliorer les Scripts**
   - Accepter le fichier de logs en paramètre
   - Ajouter des options (verbose, output format)
   - Gérer plusieurs types de logs (Apache, Nginx, IIS)

### Certifications Recommandées

- **CEH** (Certified Ethical Hacker) - EC-Council
- **GCIH** (GIAC Certified Incident Handler) - SANS
- **ECIH** (EC-Council Certified Incident Handler)
- **CompTIA Security+**

### Lecture Recommandée

- "The Art of Memory Forensics" - Michael Hale Ligh
- "Incident Response & Computer Forensics" - Jason Luttgens
- "Blue Team Handbook: Incident Response Edition" - Don Murdoch

## 👥 Auteur

**Holberton School - Projet de Cybersécurité**
Module : Web Application Security
Sous-module : 0x0B - Fast Incident Response

## 📄 Licence

Ce projet est à des fins éducatives dans le cadre du programme Holberton School.

---

**Note :** Ce projet simule une attaque réelle à des fins d'apprentissage. Les techniques apprises doivent être utilisées de manière éthique et légale uniquement.
