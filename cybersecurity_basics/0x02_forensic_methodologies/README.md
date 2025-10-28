# 0x02. Méthodologies Forensiques

## Description

Ce projet explore les principes fondamentaux, les procédures et les méthodologies de l'informatique légale (forensique numérique). L'informatique légale est une branche essentielle de la cybersécurité qui se concentre sur la récupération, l'investigation, la préservation et l'analyse des preuves numériques dans le respect des normes juridiques.

## Table des Matières

1. [Qu'est-ce que l'Informatique Légale ?](#quest-ce-que-linformatique-légale-)
2. [Principes Fondamentaux](#principes-fondamentaux)
3. [Processus d'Investigation](#processus-dinvestigation)
4. [Types de Forensique Numérique](#types-de-forensique-numérique)
5. [Outils et Technologies](#outils-et-technologies)
6. [Défis Modernes](#défis-modernes)
7. [Normes et Organisations](#normes-et-organisations)
8. [Ressources](#ressources)

## Qu'est-ce que l'Informatique Légale ?

L'**informatique légale** (ou forensique numérique) est une branche de la science forensique qui traite de la récupération, de l'investigation, de la préservation et de l'analyse des preuves numériques tout en respectant les normes légales.

### Contexte Historique

- Le FBI a lancé son premier programme d'informatique légale en **1984**
- Initialement appelée "computer forensics", la discipline s'est étendue à tous les appareils numériques
- Tout appareil numérique (ordinateur, smartphone, serveur) est considéré comme une **scène de crime potentielle**

### Utilisateurs Principaux

1. **Forces de l'ordre** : Utilisation dans les affaires pénales et civiles pour soutenir condamnations ou acquittements
2. **Équipes de réponse aux incidents (IR)** : Intervention lors de cyberattaques (violations de données, ransomwares) pour enquêter et planifier la remédiation

### Cas d'Usage en Entreprise

- Activités anormales sur le réseau
- Espionnage industriel
- Vol de propriété intellectuelle
- Audits de conformité
- Investigations internes

## Principes Fondamentaux

Les principes de l'**ACPO** (Association of Chief Police Officers) constituent la référence centrale pour garantir l'intégrité et l'admissibilité des preuves numériques.

### Les 4 Principes Clés de l'ACPO

| Principe | Description |
|----------|-------------|
| **1. Non-altération des données** | Aucune action ne doit modifier les données originales susceptibles d'être utilisées comme preuve |
| **2. Compétence et justification** | L'intervenant doit être compétent et capable d'expliquer ses actions et leur impact |
| **3. Traçabilité et reproductibilité** | Un journal d'audit complet doit permettre à un expert tiers de reproduire le processus et parvenir aux mêmes conclusions |
| **4. Responsabilité** | L'enquêteur principal a la responsabilité globale du respect de ces principes |

### Techniques de Conformité

- **Copie binaire complète** (bit copy image) de la mémoire de l'appareil
- **Bloqueur d'écriture matériel** (write blocker) pour prévenir toute modification accidentelle
- **Hachage cryptographique** pour garantir l'intégrité des données

## Processus d'Investigation

Le modèle du **DFRWS** (Digital Forensic Research Workshop, 2001) définit une méthodologie systématique en plusieurs étapes.

### 1. Préparation et Identification

**Objectifs :**
- Confirmer qu'un incident ou crime a eu lieu
- Obtenir les autorisations nécessaires (mandats, assignations)
- Préparer les outils et le personnel adéquat
- Valider les outils matériels et logiciels

**Sources de détection :**
- Victimes
- Systèmes de détection d'intrusion (IDS/IPS)
- Auditeurs internes
- Alertes automatisées

### 2. Préservation et Collecte

**Préservation de la scène :**
- Créer un "instantané" de l'état du système
- Gérer les systèmes en cours d'exécution (challenge majeur)
- Établir et maintenir la **chaîne de possession** (chain of custody)

**Types de données :**

| Type | Description | Priorité | Persistance |
|------|-------------|----------|-------------|
| **Données volatiles** | Stockées en mémoire temporaire (RAM) | HAUTE - Collecte immédiate | Perdues à l'extinction |
| **Données non volatiles** | Stockées sur supports permanents (disques durs, SSD) | Normale | Persistent après extinction |

**Vérification de l'intégrité :**
- Utilisation d'algorithmes de **hachage** (MD5, SHA-256)
- Génération d'une "empreinte digitale" numérique unique
- Comparaison des hachages original/copie pour confirmer l'identité

### 3. Examen et Analyse

**Examen :**
- Travail exclusif sur des **copies** (images forensiques)
- Recherche par mots-clés
- Récupération de fichiers supprimés
- Extraction de données cachées
- Filtrage pour réduire le volume d'informations

**Méthodes d'analyse :**

```
┌─────────────────────────────────────────────────────────┐
│ ANALYSE RELATIONNELLE                                   │
│ Relier personnes, lieux, objets et événements          │
│ → Créer des réseaux et des liens                       │
├─────────────────────────────────────────────────────────┤
│ ANALYSE FONCTIONNELLE                                   │
│ Comprendre le fonctionnement d'un système              │
│ → Particulièrement utile pour l'analyse de malwares   │
├─────────────────────────────────────────────────────────┤
│ ANALYSE TEMPORELLE                                      │
│ Examiner la chronologie des événements                 │
│ → Identifier schémas d'activité et lacunes temporelles│
└─────────────────────────────────────────────────────────┘
```

**Considérations importantes :**
- Interpréter les informations en **contexte**
- Éviter les conclusions hâtives
- Distinguer corrélation et causalité

### 4. Présentation et Rapport

**Caractéristiques d'un bon rapport :**

- **Complet** : Toutes les actions, informations et leur pertinence
- **Factuel** : Conclusions étayées par des preuves
- **Reproductible** : Suffisamment détaillé pour permettre la réplication

**Structure type :**
1. Résumé exécutif
2. Méthodologie détaillée
3. Résultats et preuves
4. Analyse et interprétation
5. Conclusions
6. Annexes techniques

**Outils de visualisation :**
- Chronologies (timelines)
- Diagrammes de liens (link analysis)
- Graphiques pour audience non technique

### 5. Décision

Sur la base du rapport, les décideurs déterminent :
- Si l'enquête est terminée
- Si des investigations supplémentaires sont nécessaires
- Les actions légales ou correctives à entreprendre

## Types de Forensique Numérique

| Type | Description | Cas d'Usage |
|------|-------------|-------------|
| **Forensique sur ordinateur** | Analyse des systèmes informatiques (desktops, laptops) | Investigations générales, vol de données |
| **Forensique de réseau** | Analyse du trafic réseau | Détection d'intrusions, exfiltration de données |
| **Forensique de base de données** | Extraction de données et métadonnées de BDD | Fraude, manipulation de données |
| **Forensique de disque** | Récupération depuis dispositifs de stockage non volatils | Récupération de fichiers supprimés |
| **Forensique de mémoire vive** | Analyse des données volatiles (RAM) | Malware en mémoire, processus actifs |
| **Forensique du cloud** | Investigation d'informations hébergées dans le cloud | Infractions impliquant services cloud |
| **Forensique d'e-mail** | Récupération et analyse des communications e-mail | Phishing, communications illicites |
| **Forensique de malware** | Identification de la source et des dommages de malwares | Réponse aux incidents, reverse engineering |
| **Forensique mobile** | Analyse de smartphones et tablettes | Géolocalisation, communications, applications |
| **E-discovery** | Analyse et préservation dans un contexte réglementaire | Litiges civils, conformité |

## Outils et Technologies

### Catégories d'Outils

- **Analyseurs de fichiers** : Extraction et analyse de métadonnées
- **Analyseurs de réseau** : Wireshark, tcpdump, NetworkMiner
- **Analyseurs de registre Windows** : RegRipper, Registry Explorer
- **Scanners d'e-mails** : Mailxaminer, Aid4Mail
- **Outils mobiles** : Cellebrite, Oxygen Forensic Detective
- **Suites complètes** : EnCase, FTK (Forensic Toolkit), Autopsy

### Validation des Outils

Le **CFTT Program** (Computer Forensics Tool Testing) du **NIST** établit :
- Méthodologie de test standardisée
- Garantie de précision et d'objectivité des résultats
- Certification des outils forensiques

## Défis Modernes

### Trois Tendances Technologiques Majeures

```
┌──────────────────────────────────────────────────────────┐
│ 1. MÉDIAS SOCIAUX                                        │
│    • 1,5+ milliards d'utilisateurs sur Facebook          │
│    • Génération massive de données pertinentes           │
│    • Interactions sociales comme preuves                 │
├──────────────────────────────────────────────────────────┤
│ 2. APPAREILS MOBILES                                     │
│    • 75% des entreprises adoptent le BYOD                │
│    • Mélange données professionnelles/personnelles       │
│    • Complexité des OS mobiles                           │
├──────────────────────────────────────────────────────────┤
│ 3. CLOUD COMPUTING                                       │
│    • Dispersion géographique des données                 │
│    • Questions de juridiction                            │
│    • Dépendance vis-à-vis des fournisseurs              │
└──────────────────────────────────────────────────────────┘
```

### Conséquences

- **Explosion du volume de données** : Traitement de pétaoctets d'informations
- **Dispersion géographique** : Un document peut exister simultanément dans plusieurs pays
- **Complexité juridictionnelle** : Législations différentes selon les pays
- **Frontière vie privée/professionnelle** : Distinction de plus en plus floue

### Considérations Éthiques

- **Confidentialité** : Protection de la vie privée des individus
- **Rôle de "gardien"** : Ne rapporter que les informations pertinentes à l'enquête
- **Politiques d'entreprise** : Informer les employés des politiques d'inspection (manuels, chartes)
- **Consentement** : Clarté sur les droits et attentes en matière de vie privée

## Normes et Organisations

### Organismes Clés

| Organisation | Rôle | Contribution |
|--------------|------|--------------|
| **NIST** (National Institute of Standards and Technology) | Organisme gouvernemental US | Programme CFTT, guides de bonnes pratiques |
| **DFRWS** (Digital Forensic Research Workshop) | Organisation bénévole à but non lucratif | Conférences, orientation de la recherche |
| **SWGDE** (Scientific Working Group on Digital Evidence) | Groupe de travail scientifique | Documents consensuels, standards de qualité |
| **ISFCE** (International Society of Forensic Computer Examiners) | Organisme de certification | Formation, certification CCE (Certified Computer Examiner) |
| **ACPO** (Association of Chief Police Officers) | Association britannique | Principes fondamentaux de l'informatique légale |

### Certifications Reconnues

- **CCE** (Certified Computer Examiner) - ISFCE
- **GCFE** (GIAC Certified Forensic Examiner) - SANS
- **CFCE** (Certified Forensic Computer Examiner) - IACIS
- **EnCE** (EnCase Certified Examiner) - Guidance Software

### Ressources Communautaires

- **Forensic Focus** : Plateforme de partage de connaissances
- **Conférences** : DFRWS, CEIC, Magnet User Summit
- **Publications** : Digital Investigation Journal, Journal of Digital Forensics

## Concepts Clés à Retenir

1. **Préservation de l'intégrité** : Les données originales ne doivent JAMAIS être modifiées
2. **Chaîne de possession** : Documentation méticuleuse de chaque manipulation de preuve
3. **Reproductibilité** : Un expert tiers doit pouvoir reproduire l'analyse et obtenir les mêmes résultats
4. **Contexte** : L'interprétation des données doit toujours tenir compte du contexte
5. **Volatilité** : Les données volatiles doivent être collectées en priorité
6. **Hachage** : Garantie de l'intégrité par empreintes cryptographiques
7. **Documentation** : Chaque action doit être consignée dans un journal d'audit
8. **Compétence** : Seuls des professionnels qualifiés doivent mener les investigations

## Glossaire

- **Acquisition live** : Collecte de données sur un système en fonctionnement
- **Bit copy** : Copie binaire exacte bit par bit d'un support de stockage
- **Chain of custody** : Chaîne de possession documentant toutes les manipulations de preuve
- **E-discovery** : Processus de découverte et préservation de preuves électroniques
- **Hachage** : Fonction cryptographique générant une empreinte unique de données
- **Image forensique** : Copie exacte d'un support de stockage pour analyse
- **Volatile data** : Données temporaires perdues à l'extinction du système
- **Write blocker** : Dispositif empêchant toute écriture sur un support de stockage

## Ressources

### Documentation Officielle

- [NIST Computer Forensics Tool Testing Program](https://www.nist.gov/itl/ssd/software-quality-group/computer-forensics-tool-testing-program-cftt)
- [ACPO Good Practice Guide for Digital Evidence](https://www.digital-detective.net/digital-forensics-documents/ACPO_Good_Practice_Guide_for_Digital_Evidence_v5.pdf)
- [SWGDE Guidelines](https://www.swgde.org/)

### Formations et Certifications

- [SANS Digital Forensics Courses](https://www.sans.org/cyber-security-courses/digital-forensics-essentials/)
- [ISFCE CCE Certification](https://www.isfce.com/)
- [Autopsy Training](https://www.autopsy.com/support/training/)

### Outils Open Source

- [Autopsy](https://www.autopsy.com/) - Plateforme forensique open source
- [Volatility](https://www.volatilityfoundation.org/) - Framework d'analyse de mémoire
- [The Sleuth Kit](https://www.sleuthkit.org/) - Collection d'outils CLI pour analyse forensique

### Communauté

- [Forensic Focus](https://www.forensicfocus.com/)
- [r/computerforensics](https://www.reddit.com/r/computerforensics/)
- [DFRWS Conference Proceedings](https://dfrws.org/)

---

**Auteur** : [Votre nom]
**Projet** : Holberton School - Cybersecurity Basics
**Date** : 2025
