# 0x06. Nmap Advanced Port Scans

## Description

Ce projet explore les techniques avancées de scan de ports avec Nmap. Contrairement aux scans standards (comme le TCP Connect scan), les scans avancés permettent une reconnaissance réseau plus furtive et peuvent révéler des informations sur les règles de pare-feu et les configurations de sécurité.

## Objectifs d'apprentissage

À la fin de ce projet, vous serez capable d'expliquer :

- Comment utiliser Nmap pour des scans de ports avancés
- Les différents types de scans avancés et leurs cas d'utilisation
- Comment fonctionnent les scans Nmap avancés au niveau des paquets TCP
- Les informations détectables avec des scans de ports avancés
- Les différences entre un scan Nmap standard et un scan avancé
- Pourquoi Nmap est essentiel pour sécuriser les ports système

## Types de Scans Avancés

### 1. NULL Scan (`-sN`)

**Principe :** Envoie des paquets TCP vides (aucun flag activé) vers les ports cibles.

**Flags TCP :** Aucun

**Fonctionnement :**
- Les ports ouverts ne répondent généralement pas (silencieux)
- Les ports fermés répondent avec un paquet RST (Reset)
- Selon la RFC 793, un port ouvert doit ignorer un paquet sans flags

**Avantages :**
- Très furtif, peut contourner certains pare-feux basiques
- Moins susceptible d'être détecté par les IDS/IPS

**Cas d'utilisation :**
- Reconnaissance discrète d'un réseau
- Tests de pénétration nécessitant de la furtivité
- Évasion de systèmes de détection basiques

**Limitations :**
- Ne fonctionne pas sur les systèmes Windows (répondent différemment)
- Les pare-feux stateful peuvent détecter ces paquets anormaux

---

### 2. FIN Scan (`-sF`)

**Principe :** Envoie des paquets TCP avec uniquement le flag FIN activé.

**Flags TCP :** FIN

**Fonctionnement :**
- Le flag FIN signale normalement la fin d'une connexion
- Les ports ouverts ignorent ces paquets inattendus
- Les ports fermés répondent avec RST

**Avantages :**
- Contourne certains pare-feux qui ne filtrent pas les paquets FIN
- Plus furtif qu'un scan SYN standard
- Peut être fragmenté pour plus de discrétion

**Cas d'utilisation :**
- Identification de ports furtifs
- Contournement de pare-feux non-stateful
- Tests de sécurité avec fragmentation de paquets

**Options supplémentaires :**
- `-f` : Fragmentation des paquets pour éviter les filtres
- `-T2` : Timing poli/lent pour réduire la détectabilité

---

### 3. Xmas Scan (`-sX`)

**Principe :** Envoie des paquets TCP avec les flags FIN, PSH et URG activés simultanément.

**Flags TCP :** FIN + PSH + URG

**Fonctionnement :**
- Nommé "Xmas" car les flags allumés ressemblent à un arbre de Noël illuminé
- Les ports ouverts ignorent ces paquets anormaux
- Les ports fermés répondent avec RST

**Avantages :**
- Configuration unique de flags facilement reconnaissable
- Efficace pour contourner certains pare-feux
- Utile pour tester les réponses aux paquets malformés

**Cas d'utilisation :**
- Tests de sécurité avancés
- Analyse de réponses à des paquets non-standard
- Évaluation des règles de pare-feu

**Options utiles :**
- `--open` : Affiche uniquement les ports ouverts/possiblement ouverts
- `--packet-trace` : Montre tous les paquets SENT/RCVD
- `--reason` : Explique pourquoi un port est dans un état donné

---

### 4. Maimon Scan (`-sM`)

**Principe :** Envoie des paquets TCP avec les flags FIN et ACK activés ensemble.

**Flags TCP :** FIN + ACK

**Fonctionnement :**
- Technique découverte par Uriel Maimon
- Exploit une anomalie dans certaines implémentations TCP/IP
- Les systèmes BSD ignorent ces paquets si le port est ouvert
- Les ports fermés répondent avec RST

**Avantages :**
- Efficace contre certains systèmes Unix/BSD
- Moins connu, donc moins détecté
- Combine les avantages des scans FIN et ACK

**Cas d'utilisation :**
- Scan de systèmes Unix/BSD spécifiques
- Tests de services critiques (HTTP, HTTPS, FTP, SSH, Telnet)
- Reconnaissance avec verbosité élevée

**Options recommandées :**
- `-vv` : Haute verbosité pour voir tous les détails du scan
- Spécification par nom de service (http, https, ftp, ssh, telnet)

---

### 5. ACK Scan (`-sA`)

**Principe :** Envoie des paquets TCP avec uniquement le flag ACK activé.

**Flags TCP :** ACK

**Fonctionnement :**
- Ne détermine pas si les ports sont ouverts ou fermés
- **Objectif principal :** Analyser les règles de pare-feu
- Les ports non-filtrés répondent avec RST
- Les ports filtrés ne répondent pas ou envoient ICMP unreachable

**Avantages :**
- Excellent pour mapper les règles de pare-feu
- Détermine si un pare-feu est stateful ou non
- Ne déclenche pas d'alertes de connexion

**Cas d'utilisation :**
- Vérification des règles de pare-feu
- Identification de ports filtrés vs non-filtrés
- Tests de configuration de sécurité réseau

**États possibles :**
- `unfiltered` : Le port répond, aucun pare-feu ne filtre
- `filtered` : Aucune réponse, probablement filtré par pare-feu

---

### 6. Window Scan (`-sW`)

**Principe :** Analyse la taille de la fenêtre TCP dans les paquets RST retournés.

**Flags TCP :** ACK (comme l'ACK scan)

**Fonctionnement :**
- Raffinement de la technique ACK scan
- Examine le champ "TCP Window Size" dans les réponses RST
- Fenêtre non-nulle = port ouvert
- Fenêtre nulle = port fermé

**Avantages :**
- Plus précis que l'ACK scan pour déterminer l'état des ports
- Fonctionne quand les scans SYN sont bloqués
- Révèle des informations subtiles sur l'état des ports

**Cas d'utilisation :**
- Alternative quand les scans standards sont bloqués
- Analyse fine de l'état des ports
- Exclusion de plages de ports spécifiques

**Fonctionnalités avancées :**
- `--exclude-ports` : Exclure des plages de ports du scan

---

### 7. Custom Scan (`--scanflags`)

**Principe :** Permet de définir manuellement n'importe quelle combinaison de flags TCP.

**Flags TCP :** Personnalisables (URG, ACK, PSH, RST, SYN, FIN)

**Fonctionnement :**
- Créez des paquets avec n'importe quelle combinaison de flags
- Testez les réponses à des configurations spécifiques
- Simulez des comportements d'attaquants sophistiqués

**Avantages :**
- Flexibilité totale dans la configuration des paquets
- Utile pour les tests de vulnérabilité avancés
- Permet de tester les réponses à des paquets anormaux

**Cas d'utilisation :**
- Tests de sécurité personnalisés
- Recherche de vulnérabilités spécifiques
- Évaluation de la robustesse des pare-feux

**Exemple :** Tous les flags activés (URGACKPSHRSTSYNFIN)

---

## Différences : Scan Standard vs Scan Avancé

### TCP Connect Scan (`-sT`) - Standard

- Établit une connexion TCP complète (Three-Way Handshake)
- SYN → SYN-ACK → ACK
- Très détectable et enregistré dans les logs
- Ne nécessite pas de privilèges root
- Fiable mais bruyant

### SYN Scan (`-sS`) - Semi-Avancé

- N'établit pas de connexion complète (Half-Open)
- SYN → SYN-ACK → RST
- Plus furtif que TCP Connect
- Nécessite des privilèges root
- Scan par défaut avec sudo

### Scans Avancés (NULL, FIN, Xmas, etc.)

- Utilisent des configurations de flags non-standard
- Plus furtifs et moins détectables
- Peuvent contourner certains pare-feux
- Exploitent les subtilités des implémentations TCP/IP
- Nécessitent des privilèges root

---

## Différences : TCP Connect Scan vs SYN Scan

| Critère | TCP Connect (`-sT`) | SYN Scan (`-sS`) |
|---------|---------------------|------------------|
| **Connexion** | Complète (3-way handshake) | Incomplète (half-open) |
| **Détectabilité** | Haute (enregistré dans les logs) | Moyenne (moins de logs) |
| **Privilèges** | Utilisateur normal | Root/Administrateur |
| **Vitesse** | Plus lent | Plus rapide |
| **Furtivité** | Faible | Moyenne |
| **Fiabilité** | Très haute | Haute |
| **Cas d'usage** | Scan autorisé, tests internes | Pentest, reconnaissance |

---

## ACK Scan et Règles de Pare-feu

L'ACK scan est spécialement conçu pour analyser les pare-feux :

### Pare-feu Stateless

- Filtre basé uniquement sur les règles de paquets individuels
- Ne garde pas trace des connexions établies
- L'ACK scan peut révéler quels ports sont filtrés

### Pare-feu Stateful

- Maintient l'état des connexions
- Sait si un paquet ACK appartient à une connexion légitime
- Bloque les paquets ACK non sollicités
- Plus difficile à contourner

### Analyse des résultats ACK scan

- **Unfiltered** : Le port répond → Aucun pare-feu ou pare-feu stateless
- **Filtered** : Pas de réponse → Pare-feu bloque les paquets
- Cette information aide à comprendre l'architecture de sécurité

---

## Scans FIN, NULL et Xmas : Détection d'État des Ports

Ces trois scans exploitent le même principe de la RFC 793 :

### Principe RFC 793

> "Si le port est fermé, un RST doit être envoyé en réponse à tout paquet entrant ne contenant pas RST. Si le port est ouvert, les paquets sans SYN, RST ou ACK doivent être ignorés."

### Comportement attendu

| État du Port | Réponse | Interprétation Nmap |
|--------------|---------|---------------------|
| **Ouvert** | Aucune réponse | `open\|filtered` |
| **Fermé** | RST | `closed` |
| **Filtré** | ICMP unreachable ou timeout | `filtered` |

### Pourquoi trois types différents ?

- **NULL** : Aucun flag (cas le plus basique)
- **FIN** : Simule la fermeture d'une connexion
- **Xmas** : Flags multiples pour tester les réponses aux paquets anormaux

### Limitations

- Ne fonctionnent pas sur Windows (comportement différent de la RFC)
- Résultats souvent `open|filtered` (ambigus)
- Efficaces principalement sur systèmes Unix/Linux

---

## Pourquoi utiliser Nmap pour sécuriser les ports ?

### 1. Découverte de vulnérabilités

- Identifie les ports ouverts inutilement
- Détecte les services exposés non intentionnellement
- Révèle les mauvaises configurations

### 2. Audit de sécurité

- Vérification des règles de pare-feu
- Test de la détection par les IDS/IPS
- Validation des politiques de sécurité

### 3. Tests de pénétration

- Reconnaissance réseau avant exploitation
- Identification de vecteurs d'attaque
- Cartographie de la surface d'attaque

### 4. Maintenance proactive

- Surveillance continue de l'exposition réseau
- Détection de changements non autorisés
- Documentation de l'architecture réseau

### 5. Conformité

- Respect des normes de sécurité (PCI-DSS, HIPAA, etc.)
- Preuves d'audits de sécurité réguliers
- Rapports pour la gouvernance

---

## Informations révélées par les scans avancés

### 1. État des ports

- Ouverts, fermés, filtrés
- Services en écoute
- Ports furtifs ou cachés

### 2. Règles de pare-feu

- Ports filtrés vs non-filtrés
- Type de pare-feu (stateful vs stateless)
- Configuration des ACL (Access Control Lists)

### 3. Système d'exploitation

- Comportement spécifique aux OS (empreinte digitale)
- Implémentation de la pile TCP/IP
- Réponses aux paquets malformés

### 4. Dispositifs de sécurité

- Présence d'IDS/IPS
- Systèmes de détection d'intrusion
- Proxies et load balancers

### 5. Topologie réseau

- Segmentation réseau
- Zones DMZ
- Architecture multi-tiers

### 6. Services et versions

- Applications en écoute
- Versions de services (avec `-sV`)
- Bannières de services

---

## Exigences techniques

### Environnement

- Testé sur **Kali Linux**
- Éditeurs autorisés : `vi`, `vim`, `emacs`

### Format des scripts

- Tous les scripts doivent faire **exactement 2 lignes**
- Première ligne : `#!/bin/bash`
- Deuxième ligne : La commande commençant par `sudo`
- Fin de fichier avec une nouvelle ligne

### Variables d'arguments

- `$1` : Hôte cible (sans guillemets)
- `$2` : Ports ou plage de ports (si applicable)
- `$3` : Ports à exclure (si applicable)

### Restrictions

- Pas de backticks, `&&`, `||` ou `;`
- Pas d'utilisation de `echo`
- Style Betty obligatoire
- Tous les fichiers doivent être exécutables
- Utiliser un simple tiret `-` pour les flags Nmap

---

## Scripts du projet

| Fichier | Description | Arguments |
|---------|-------------|-----------|
| `0-null_scan.sh` | NULL scan sur ports 20-25 | `$1` (hôte) |
| `1-fin_scan.sh` | FIN scan avec fragmentation et timing sur ports 80-85 | `$1` (hôte) |
| `2-xmas_scan.sh` | Xmas scan avec trace de paquets sur ports 440-450 | `$1` (hôte) |
| `3-maimon_scan.sh` | Maimon scan sur services critiques (http, https, ftp, ssh, telnet) | `$1` (hôte) |
| `4-ask_scan.sh` | ACK scan avec timeout pour analyse de pare-feu | `$1` (hôte), `$2` (ports) |
| `5-window_scan.sh` | Window scan avec exclusion de ports | `$1` (hôte), `$2` (plage), `$3` (exclusions) |
| `6-custom_scan.sh` | Scan personnalisé avec tous les flags TCP | `$1` (hôte), `$2` (ports) |

---

## Exemples d'utilisation

### NULL Scan
```bash
./0-null_scan.sh www.example.com
```

### FIN Scan avec options de furtivité
```bash
./1-fin_scan.sh 192.168.1.1
```

### Xmas Scan avec trace de paquets
```bash
./2-xmas_scan.sh scanme.nmap.org
```

### Maimon Scan haute verbosité
```bash
./3-maimon_scan.sh www.example.com
```

### ACK Scan pour test de pare-feu
```bash
./4-ask_scan.sh 10.0.0.1 80,22,25
```

### Window Scan avec exclusions
```bash
./5-window_scan.sh 192.168.1.100 20-30 25-28
```

### Custom Scan avec sauvegarde
```bash
./6-custom_scan.sh www.example.com 80-90
cat custom_scan.txt
```

---

## Considérations légales et éthiques

### Avertissement

Les techniques de scan de ports peuvent être considérées comme intrusives et potentiellement illégales si utilisées sans autorisation.

### Utilisation autorisée uniquement

- Réseau dont vous êtes propriétaire
- Autorisation écrite explicite du propriétaire du réseau
- Environnements de test et laboratoires
- Programmes de bug bounty autorisés

### Conséquences potentielles d'usage non autorisé

- Poursuites judiciaires
- Violations de la CFAA (Computer Fraud and Abuse Act)
- Sanctions pénales et civiles
- Bannissement et blocage IP

### Bonnes pratiques

- Toujours obtenir une autorisation écrite
- Limiter les scans aux plages IP autorisées
- Documenter toutes les activités de scan
- Respecter les politiques de sécurité de l'organisation

---

## Ressources

### Documentation officielle

- [Nmap Official Documentation](https://nmap.org/book/)
- [RFC 793 - TCP Protocol](https://tools.ietf.org/html/rfc793)
- [Nmap Port Scanning Techniques](https://nmap.org/book/man-port-scanning-techniques.html)

### Livres recommandés

- "Nmap Network Scanning" par Gordon "Fyodor" Lyon
- "The Hacker Playbook" par Peter Kim
- "Network Security Assessment" par Chris McNab

### Outils complémentaires

- Wireshark (analyse de paquets)
- tcpdump (capture de trafic)
- Zenmap (interface graphique pour Nmap)

---

## Auteur

Projet réalisé dans le cadre du cursus **Holberton School - Cybersecurity**

## Licence

Ce projet est à des fins éducatives uniquement.
