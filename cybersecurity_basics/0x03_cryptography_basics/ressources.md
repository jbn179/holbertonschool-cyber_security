# Synthèse sur le Craquage de Mots de Passe et la Cryptographie

## Résumé Exécutif

Ce document de synthèse analyse les concepts fondamentaux, les outils et les techniques liés au craquage de mots de passe et à la cryptographie, en s'appuyant exclusivement sur les contextes sources fournis. Le craquage de mots de passe est une discipline essentielle du piratage éthique, qui consiste à retrouver des mots de passe en clair à partir de leurs empreintes cryptographiques (hashes). Les systèmes ne stockant que rarement les mots de passe en clair, cette compétence est cruciale pour évaluer la sécurité d'un système.

### Outils Principaux

Deux outils majeurs dominent ce domaine :

- **Hashcat** : reconnu comme l'outil de récupération de mots de passe le plus rapide au monde, optimisé pour les processeurs graphiques (GPU) et capable de gérer plus de 450 types de hashes différents
- **John the Ripper (JTR)** : un outil open source polyvalent apprécié des testeurs d'intrusion, notamment dans sa version "Jumbo" qui prend en charge des centaines de formats de hash pour une vaste gamme de systèmes, d'applications et de types de fichiers

### Concepts Cryptographiques Clés

Ces outils reposent sur les principes de la cryptographie, la science de la sécurisation de l'information. Les concepts clés incluent :

1. **Le Hachage** : Une fonction mathématique à sens unique qui transforme des données en une chaîne de caractères de taille fixe (le hash). Il est utilisé pour stocker les mots de passe en toute sécurité et vérifier l'intégrité des données.

2. **La Cryptographie Symétrique** : Utilise une seule clé secrète partagée pour le chiffrement et le déchiffrement. Efficace pour le stockage local et le chiffrement de masse.

3. **La Cryptographie Asymétrique** : Utilise une paire de clés (une publique pour chiffrer, une privée pour déchiffrer) pour établir des canaux de communication sécurisés sur des réseaux non sécurisés et pour l'authentification.

### Objectifs de Sécurité

La cryptographie vise à atteindre quatre objectifs de sécurité fondamentaux : la confidentialité, l'intégrité, l'authentification et la non-répudiation. Ses applications pratiques sont omniprésentes, allant du chiffrement des appareils personnels (BYOD) et des bases de données à la sécurisation des e-mails et des transactions web via HTTPS.


---

## 1. Introduction au Craquage de Mots de Passe

Le craquage de mots de passe est une compétence fondamentale dans les domaines du piratage éthique et des tests d'intrusion (penetration testing). Son objectif principal est d'obtenir l'accès à un système ou à un serveur en découvrant les mots de passe des utilisateurs.

### Le Rôle du Hachage

Dans les systèmes et bases de données modernes, les mots de passe sont rarement stockés en texte clair pour des raisons de sécurité évidentes. Ils sont systématiquement transformés à l'aide d'une fonction de hachage avant d'être enregistrés.

- **Fonction de Hachage** : C'est un processus qui convertit un texte d'entrée (le mot de passe) en une chaîne de texte de taille fixe, appelée "hash" ou "valeur de hachage", via une fonction mathématique. Des algorithmes comme MD5 et SHA-256 sont des exemples courants de fonctions de hachage.

- **Processus de Vérification** : Lorsqu'un utilisateur se connecte, le mot de passe qu'il saisit est haché en utilisant le même algorithme. Le hash résultant est ensuite comparé à celui stocké dans la base de données. S'ils correspondent, l'accès est accordé.

**Objectif du craquage** : La tâche du craquage de mot de passe consiste donc à prendre un hash connu et à utiliser divers outils et techniques pour retrouver le texte clair original qui l'a produit.


---

## 2. Outils de Craquage de Mots de Passe

Deux outils principaux sont mis en avant comme des standards dans l'industrie pour le craquage de hashes.

### 2.1. Hashcat

Décrit comme "l'outil de récupération de mot de passe le plus rapide au monde", Hashcat est conçu pour casser des mots de passe très complexes en un temps record. Il est capable de mener des attaques par liste de mots (wordlist) et par force brute.

#### Caractéristiques Clés

- **Gratuit et Open Source** : Distribué sous la licence MIT.
- **Multi-Plateforme et Multi-OS** : Fonctionne sur Linux, Windows et macOS et prend en charge une variété de plateformes de calcul (CPU, GPU, APU) via des runtimes comme OpenCL et CUDA.
- **Optimisation GPU** : Une variante de l'outil est spécialement conçue pour les unités de traitement graphique (GPU), qui peuvent craquer les hashes beaucoup plus rapidement que les CPU.
- **Prise en charge étendue des Hashes** : Implémente plus de 450 types de hashes, couvrant un large éventail d'algorithmes et d'applications.

#### Fonctionnalités Avancées

- Craquage de multiples hashes simultanément
- Support pour les réseaux de craquage distribués
- Pause/reprise interactive des sessions
- Système d'évaluation des performances (benchmarking) intégré
- Surveillance thermique (thermal watchdog) intégrée

#### Exemple d'Utilisation (sous Linux)

1. **Préparation** : S'assurer que le système est à jour et installer Hashcat si nécessaire
   ```bash
   sudo apt update && sudo apt upgrade
   sudo apt-get install hashcat
   ```

2. **Création de Hashes** : Pour les tests, des hashes peuvent être générés en ligne de commande
   ```bash
   echo -n "geekflare" | md5sum | tr -d "-" >> crackhash.txt
   ```

3. **Lancement de l'Attaque** : La commande générale de Hashcat suit ce format :
   ```bash
   hashcat -a [mode_attaque] -m [type_hash] [fichier_hash] [fichier_wordlist]
   ```
   
   - `-a 0` spécifie une attaque par dictionnaire (Straight)
   - `-m 0` spécifie le type de hash MD5
   - `rockyou.txt` est une liste de mots de passe couramment utilisée
   
   **Commande finale** :
   ```bash
   hashcat -a 0 -m 0 ./crackhash.txt rockyou.txt
   ```

4. **Résultat** : Si le mot de passe est trouvé dans la liste de mots, Hashcat l'affichera à côté du hash correspondant
   ```
   8276b0e763d7c9044d255e025fe0c212:geekflare@987654
   ```

> **Note** : Une erreur "Token length exception" peut survenir avec des processeurs peu puissants lors du traitement de plusieurs hashes dans un seul fichier. La solution consiste à séparer chaque hash dans son propre fichier.

### 2.2. John the Ripper (JTR)

John the Ripper est un autre outil de craquage de mots de passe open source très populaire auprès des testeurs d'intrusion. Sa version "jumbo" étend considérablement ses capacités, prenant en charge des centaines de types de hashes et de chiffrements.

#### Domaines d'Application

- **Systèmes d'Exploitation** : Mots de passe d'utilisateurs Unix (Linux, *BSD, Solaris), macOS, Windows
- **Applications Web** : WordPress, etc.
- **Serveurs de Bases de Données** : SQL, LDAP
- **Fichiers Chiffrés** : 
  - Clés privées (SSH, GnuPG)
  - Portefeuilles de cryptomonnaies
  - Systèmes de fichiers (fichiers .dmg macOS, BitLocker Windows)
  - Archives (ZIP, RAR, 7z)
  - Documents (PDF, Microsoft Office)

#### Défis Courants lors de l'Utilisation de JTR

- **Identification du Format** : Reconnaître le format d'un hash peut être difficile
- **Formatage des Hashes** : Les hashes collectés doivent souvent être réarrangés ("munged") dans un format que JTR peut comprendre
- **Détection Incorrecte** : JTR peut parfois mal identifier un type de hash car certains formats sont visuellement identiques (par exemple, "Raw MD5" et "LM DES")

**Solution** : JTR propose une option de ligne de commande `--format=<type>` pour forcer l'utilisation d'un type de hash spécifique.

#### Tableau d'Exemples de Formats de Hash pour JTR

| Format (Option --format) | Description | Exemple de Hash | Reconnaissance Auto |
|:--------------------------|:------------|:----------------|:-------------------|
| `bf` | OpenBSD Blowfish | `$2a$05$CCCCCCCCCCCCCCCCCCCCC.7uG0VCzI2bS7j6ymqJi9CdcdxiRTWNy` | Oui |
| `des` | Traditional DES | `SDbsugeBiC58A` | Oui |
| `raw-md5` | Raw MD5 | `5a105e8b9d40e1329780d62ea2265d8a` | Non (détecté comme LM) |
| `raw-sha1` | Raw SHA-1 | `A9993E364706816ABA3E25717850C26C9CD0D89D` | Oui |
| `raw-sha256` | Raw SHA-256 | `5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8` | Non (détecté comme po) |
| `nt` | NT MD4 | `$NT$8846f7eaee8fb117ad06bdd830b7586c` | Oui |
| `mysql-sha1` | MySQL 4.1 double-SHA-1 | `*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19` | Oui |
| `rar` | Fichier RAR | `$rar3$*0*c9dea41b149b53b4*fcbdb66122d8ebdb32532c22ca7ab9ec*24` | Oui |
| `zip` | Fichier ZIP | `$zip$*0*1*8005b1b7d077708d*dee4` | Oui |


---

## 3. Fondamentaux de la Cryptographie

La cryptographie est l'art de sécuriser l'information en la transformant en une forme que seuls les destinataires prévus peuvent comprendre. Elle est le fondement de la cybersécurité moderne.

### Terminologie de Base

- **Texte en clair (Plaintext)** : Le message original, lisible par l'homme
- **Texte chiffré (Ciphertext)** : Le message transformé, qui apparaît comme du charabia
- **Algorithme** : La série d'opérations mathématiques utilisée pour la transformation
- **Clé (Key)** : Une information (généralement un nombre) qui spécifie comment l'algorithme est appliqué

### 3.1. Objectifs de la Cryptographie

La cryptographie permet d'atteindre plusieurs objectifs de sécurité fondamentaux :

1. **Confidentialité** : Garder le contenu des données secret pour les tiers non autorisés
2. **Intégrité** : S'assurer que les données n'ont pas été modifiées pendant leur stockage ou leur transit
3. **Authentification** : Vérifier l'identité de l'expéditeur et du destinataire d'un message
4. **Non-répudiation** : Empêcher un expéditeur de nier avoir envoyé un message

### 3.2. Principes Cryptographiques

#### Principe de Kerckhoffs
"Un système cryptographique doit être sûr même si tout ce qui le concerne, à l'exception de la clé, est de notoriété publique." 

Ce principe, résumé par Claude Shannon comme "l'ennemi connaît le système", souligne que la sécurité doit reposer uniquement sur le secret de la clé, et non sur celui de l'algorithme.

#### Fonctions à Sens Unique
Ce sont des opérations mathématiques faciles à calculer dans un sens mais extrêmement difficiles à inverser. Un exemple classique est la multiplication de deux très grands nombres premiers. Ces fonctions sont à la base du hachage et de la cryptographie asymétrique.


---

## 4. Les Types de Cryptographie 

Les algorithmes cryptographiques sont généralement classés en trois catégories principales.

### 4.1. Cryptographie Symétrique (à Clé Secrète)

Dans ce modèle, la même clé est utilisée pour chiffrer et déchiffrer les données. Les deux parties communicantes doivent partager cette clé secrète au préalable.

- **Exemple Historique** : Le chiffre de César, où la clé est le nombre de positions pour décaler les lettres dans l'alphabet
- **Algorithmes Modernes** : Triple DES, AES (Advanced Encryption Standard), Blowfish
- **Cas d'Utilisation** : Idéale pour chiffrer de grandes quantités de données rapidement, comme le contenu d'un disque dur local ou des flux de données après qu'un canal sécurisé a été établi

### 4.2. Cryptographie Asymétrique (à Clé Publique)

Ce système utilise une paire de clés mathématiquement liées pour chaque participant :

- **Clé Publique** : Partagée avec tout le monde, elle sert à chiffrer les messages destinés au propriétaire de la clé
- **Clé Privée** : Gardée secrète, elle est la seule à pouvoir déchiffrer les messages chiffrés avec la clé publique correspondante
- **Algorithmes Courants** : RSA, Diffie-Hellman, ElGamal
- **Cas d'Utilisation** : Essentielle pour établir des communications sécurisées sur des réseaux non fiables comme Internet. Elle est souvent utilisée pour échanger en toute sécurité une clé symétrique qui sera ensuite utilisée pour chiffrer le reste de la session, combinant ainsi la sécurité de l'asymétrique avec la vitesse du symétrique. Elle est également au cœur de l'infrastructure à clé publique (PKI) qui gère l'authentification et les signatures numériques.

### 4.3. Fonctions de Hachage

Une fonction de hachage est un algorithme de chiffrement à sens unique. Une fois les données hachées, il est impossible de récupérer le texte en clair original à partir du hash.

#### Propriétés Clés
- Pour une fonction de hachage sécurisée, il est pratiquement impossible que deux entrées différentes produisent le même hash (résistance aux collisions)

#### Algorithmes Courants
- **MD5** (maintenant considéré comme non sécurisé pour de nombreux usages)
- **SHA-1** (déprécié)
- **SHA-256, SHA-512** (recommandés)

#### Cas d'Utilisation
- **Stockage de Mots de Passe** : Les systèmes stockent les hashes des mots de passe au lieu des mots de passe en clair
- **Vérification de l'Intégrité des Données** : En comparant le hash d'un fichier avant et après sa transmission, on peut s'assurer qu'il n'a pas été altéré


---

## 5. Applications Pratiques de la Cryptographie

La cryptographie est un pilier de la sécurité informatique moderne, avec des applications dans presque tous les aspects de la vie numérique.

### Principales Applications

#### Chiffrement des Appareils BYOD (Bring Your Own Device)
Sécurise les données sur les téléphones et ordinateurs personnels des employés, qui sont souvent utilisés sur des réseaux publics non sécurisés.

#### Sécurisation des E-mails
Le chiffrement de bout en bout garantit que seuls l'expéditeur et le destinataire peuvent lire le contenu des e-mails.

#### Chiffrement des Bases de Données
Des technologies comme le TDE (Transparent Data Encryption) protègent les données au repos, qu'elles soient stockées sur site ou dans le cloud. Cela inclut :
- Les données clients
- Les informations sur les employés  
- La propriété intellectuelle

#### HTTPS pour la Sécurité des Sites Web
Le protocole HTTPS chiffre le trafic entre le navigateur d'un utilisateur et un site web, garantissant :
- La confidentialité des transactions en ligne
- L'intégrité des données
- La protection contre des attaques comme le DNS spoofing
