# 0x00. Ruby Scripting

Ce projet introduit les fondamentaux de la programmation Ruby avec un focus sur le scripting et les tâches d'automatisation couramment utilisées en cybersécurité.

## Objectifs d'apprentissage

À la fin de ce projet, vous comprendrez :
- La syntaxe de base de Ruby et les concepts de programmation
- La programmation orientée objet en Ruby
- Les opérations d'entrée/sortie sur les fichiers
- Les requêtes HTTP avec Ruby
- Le parsing et la manipulation de JSON
- La gestion des arguments en ligne de commande
- La construction d'applications CLI

## Prérequis

- Tous les scripts testés sur Kali Linux
- Version de Ruby compatible avec les bibliothèques standard
- Tous les fichiers doivent être exécutables
- Première ligne de tous les fichiers : `#!/usr/bin/env ruby`
- Le code doit suivre les conventions de style Ruby avec une indentation de 2 espaces

## Tâches

### 0. Hello World avec une fonction
Introduction aux fonctions Ruby avec une fonction de salutation simple qui accepte un paramètre chaîne de caractères et affiche un message formaté.

**Concepts couverts :**
- Définition de fonction avec `def`
- Interpolation de chaînes avec `#{}`
- La méthode `puts` pour l'affichage

### 1. Hello World avec une classe
Les bases de la programmation orientée objet en créant une classe avec des variables d'instance et des méthodes.

**Concepts couverts :**
- Définition de classe avec `class`
- La méthode `initialize` (constructeur)
- Les variables d'instance avec `@`
- Les méthodes publiques

### 2. Vérificateur de nombres premiers
Travail avec la bibliothèque standard de Ruby pour vérifier si un nombre est premier.

**Concepts couverts :**
- `require` pour importer des bibliothèques
- Utilisation de la classe `Prime` de la bibliothèque standard Ruby
- Valeurs de retour booléennes
- Conventions de nommage Ruby (méthodes se terminant par `?`)

### 3. Lecture d'un fichier
Lecture et parsing de données JSON, puis analyse des données.

**Concepts couverts :**
- Lecture de fichier avec `File.read`
- Parsing JSON avec `JSON.parse`
- Opérations sur les Hash avec `Hash.new(0)`
- Itération sur les tableaux avec `.each`
- Tri avec `.sort`

### 4. Écriture dans un fichier
Fusion de données JSON provenant de plusieurs fichiers et écriture du résultat sur le disque.

**Concepts couverts :**
- Lecture de plusieurs fichiers JSON
- Concaténation de tableaux avec `+`
- Écriture de fichiers avec `File.write`
- Formatage JSON avec `JSON.pretty_generate`

### 5. Chiffrement et déchiffrement César
Implémentation d'un algorithme cryptographique classique en utilisant les principes de la programmation orientée objet.

**Concepts couverts :**
- Méthodes privées avec `private`
- Conversion ASCII avec `.ord` et `.chr`
- Arithmétique modulaire pour le bouclage
- Vérification de plages de caractères
- Expressions régulières avec `.match?`

### 6. Requête HTTP simple
Réalisation de requêtes HTTP GET et gestion des réponses.

**Concepts couverts :**
- La bibliothèque `net/http`
- Parsing d'URI
- Gestion SSL/HTTPS avec `http.use_ssl`
- Parsing de réponses JSON
- Gestion des erreurs avec `begin...rescue`

### 7. Arguments en ligne de commande
Traitement des arguments en ligne de commande passés à un script Ruby.

**Concepts couverts :**
- Le tableau `ARGV`
- Vérification de tableaux vides avec `.empty?`
- Itération avec des compteurs
- Logique conditionnelle

### 8. Requête HTTP POST
Envoi de données à un serveur web en utilisant HTTP POST avec des payloads JSON.

**Concepts couverts :**
- Création de requêtes POST avec `Net::HTTP::Post`
- Définition des en-têtes HTTP
- Conversion de hashes Ruby en JSON avec `.to_json`
- Gestion de différents codes de réponse

### 9. Téléchargement d'un fichier
Téléchargement de fichiers depuis des URLs et sauvegarde locale.

**Concepts couverts :**
- La bibliothèque `open-uri` pour un accès HTTP simplifié
- Écriture de fichiers binaires avec le mode `'wb'`
- Validation des arguments en ligne de commande
- Codes de sortie pour la gestion des erreurs

### 10. Casseur de mots de passe
Implémentation d'une attaque par dictionnaire utilisant le hachage SHA-256.

**Concepts couverts :**
- La bibliothèque `digest` pour le hachage
- Hachage SHA-256 avec `Digest::SHA256.hexdigest`
- Lecture de fichiers ligne par ligne avec `File.foreach`
- Nettoyage de chaînes avec `.strip`
- Sortie de boucles avec `break`

### 11. Création d'une application CLI basique
Construction d'un gestionnaire de tâches en ligne de commande complet utilisant le parsing d'options.

**Concepts couverts :**
- La bibliothèque `optparse` pour les arguments CLI
- Définition d'options avec `.on`
- Opérations sur les fichiers (ajout, lecture, écriture)
- Manipulation de tableaux (`.delete_at`, `.readlines`)
- Vérification d'existence de fichiers avec `File.exist?`
- Détection de fichiers vides avec `File.zero?`

## Technologies utilisées

- **Ruby** : Langage de programmation principal
- **Bibliothèques standard** :
  - `prime` - Opérations sur les nombres premiers
  - `json` - Parsing et génération JSON
  - `net/http` - Fonctionnalité client HTTP
  - `uri` - Parsing d'URL
  - `digest` - Hachage cryptographique
  - `optparse` - Parsing d'options en ligne de commande
  - `open-uri` - Accès HTTP simplifié
  - `fileutils` - Opérations sur les fichiers

## Structure du projet

```
0x00-ruby_scripting/
├── 0-hello_world_function.rb
├── 1-hello_world_class.rb
├── 2-prime.rb
├── 3-read_file.rb
├── 4-write_file.rb
├── 5-cipher.rb
├── 6-get.rb
├── 7-args.rb
├── 8-post.rb
├── 9-download_file.rb
├── 10-password_cracked.rb
├── 11-cli.rb
├── file.json
├── file2.json
├── dictionary.txt
├── tasks.txt
└── README.md
```

## Auteur

Ce projet fait partie du cursus Cyber Security de Holberton School.
