# 0x03. Cryptography Basics

## Concepts Abordés

### Cryptographie Fondamentale
- **Définition et importance** : La cryptographie est l'art de sécuriser l'information en la transformant en un format illisible pour les personnes non autorisées
- **Types de cryptographie** : Symétrique (clé unique), asymétrique (paire de clés), et hachage (fonction à sens unique)
- **Chiffrement vs Déchiffrement** : Processus de transformation des données en texte chiffré et vice versa

### Fonctions de Hachage
- **Concept** : Transformation irréversible d'une donnée en une empreinte numérique fixe
- **Propriétés** : Déterministe, résistance aux collisions, effet avalanche
- **Algorithmes étudiés** :
  - **MD5** : 128 bits, obsolète pour la sécurité (vulnérable aux collisions)
  - **SHA-1** : 160 bits, dépréciée pour les nouvelles applications
  - **SHA-256** : 256 bits, standard actuel sécurisé
  - **SHA-512** : 512 bits, version renforcée

### Sécurisation des Mots de Passe
- **Salage (Salt)** : Ajout d'une valeur aléatoire pour renforcer la sécurité
- **OpenSSL** : Outil polyvalent pour les opérations cryptographiques
- **Bonnes pratiques** : Utilisation de sels uniques et d'algorithmes résistants

### Cryptanalyse et Tests de Sécurité
- **John the Ripper** : Outil de cassage de mots de passe
  - Mode dictionnaire (wordlist)
  - Formats spécialisés (NTLM/NTHash pour Windows)
  - Attaques par force brute
- **Hashcat** : Moteur de récupération de mots de passe haute performance
  - Attaques directes (straight attack)
  - Attaques combinatoires
  - Optimisation GPU

### Applications en Cybersécurité
- **Authentification** : Vérification d'identité sans stocker le mot de passe en clair
- **Intégrité des données** : Détection de modifications non autorisées
- **Audit de sécurité** : Évaluation de la robustesse des mots de passe
- **Tests d'intrusion** : Identification des vulnérabilités

## Ressources
- [What is cryptography](https://example.com)
- [The importance of cryptography](https://example.com)
- [What is cryptography in cyber security](https://example.com)
- [Cryptography](https://example.com)
- [OpenSSL](https://www.openssl.org/)
- [John The Ripper Hash Formats](https://example.com)
- [How to use hashcat](https://example.com)
- [John the Ripper](https://www.openwall.com/john/)
- [hashcat](https://hashcat.net/hashcat/)

## Objectifs Pédagogiques
À la fin de ce projet, vous devriez être capable d'expliquer :

- Le rôle de la cryptographie en cybersécurité
- Les différents types de cryptographie et leurs usages
- Les processus de chiffrement et déchiffrement
- L'importance et les applications de la cryptographie
- Le fonctionnement des algorithmes de hachage
- La signification de SHA (Secure Hash Algorithm)
- L'utilisation de John the Ripper pour les tests de sécurité
- Les techniques avancées de cassage de hachages
- L'emploi de hashcat pour l'audit de mots de passe

## Requirements

### General
- **Allowed editors:** vi, vim, emacs
- **Testing environment:** Kali Linux
- **Script length:** Exactly two lines (verified with `wc -l`)
- **Parameter substitution:** Use `$1` for input arguments
- **File endings:** All files must end with a new line
- **Shebang:** First line must be `#!/bin/bash`
- **Executable:** All files must be executable
- **Prohibited:** No backticks, `&&`, `||`, or `;`
- **Code style:** Betty style compliance
- **Algorithm format:** Use lowercase for cryptographic algorithms (e.g., sha256)

## Exercices Pratiques

### Implémentation des Algorithmes de Hachage
**Fichiers :** `0-sha1.sh`, `1-sha256.sh`, `2-md5.sh`

**Concept exploré :** Compréhension pratique des différents algorithmes de hachage et de leurs spécificités. Comparaison entre MD5 (vulnérable), SHA-1 (dépréciée) et SHA-256 (sécurisée).

### Hachage Sécurisé avec Salt
**Fichier :** `3-password_hash.sh`

**Concept exploré :** Implémentation du salage pour renforcer la sécurité des mots de passe. Utilisation d'OpenSSL pour générer des hachages SHA-512 robustes contre les attaques par tables arc-en-ciel.

### Attaques par Dictionnaire
**Fichiers :** `4-wordlist_john.sh`, `4-password.txt`

**Concept exploré :** Utilisation de listes de mots communs (RockYou) pour tester la résistance des mots de passe. Comprendre l'importance de choisir des mots de passe complexes.

### Formats de Hachage Spécialisés
**Fichiers :** `5-windows_john.sh`, `5-password.txt`

**Concept exploré :** Audit des systèmes Windows via le craquage des hachages NTLM/NTHash. Compréhension des mécanismes d'authentification spécifiques aux environnements Microsoft.

### Tests de Robustesse Génériques
**Fichiers :** `6-crack_john.sh`, `6-password.txt`

**Concept exploré :** Application des techniques de cryptanalyse sur différents formats de hachage pour évaluer la sécurité des implémentations.

### Optimisation avec Hashcat
**Fichiers :** `7-crack_hashcat.sh`, `7-password.txt`

**Concept exploré :** Utilisation d'outils optimisés pour GPU afin d'accélérer les tests de sécurité. Comparaison des performances entre différents moteurs de cryptanalyse.

### Génération de Listes Combinées
**Fichier :** `8-combination_hashcat.sh`

**Concept exploré :** Création de dictionnaires personnalisés par combinaison de mots. Stratégies d'attaque basées sur des modèles de création de mots de passe humains.

### Attaques Combinatoires Avancées
**Fichiers :** `9-attack_hashcat.sh`, `9-password.txt`

**Concept exploré :** Mise en œuvre d'attaques sophistiquées utilisant des combinaisons de mots pour reproduire les habitudes utilisateur dans la création de mots de passe.

## Implications en Cybersécurité

### Défense
- **Choix d'algorithmes** : Privilégier SHA-256/SHA-512 plutôt que MD5/SHA-1
- **Implémentation sécurisée** : Utilisation systématique de sels uniques
- **Politique de mots de passe** : Définir des critères basés sur la résistance aux attaques

### Audit et Test d'Intrusion
- **Évaluation des vulnérabilités** : Identifier les mots de passe faibles
- **Sensibilisation** : Démontrer l'importance de la robustesse cryptographique
- **Conformité** : Vérifier le respect des standards de sécurité

## Repository Information
- **GitHub repository:** holbertonschool-cyber_security
- **Directory:** cybersecurity_basics/0x03_cryptography_basics

## Avertissements
⚠️ **Format** : Utilisez systématiquement la notation en minuscules pour les algorithmes cryptographiques (sha256, md5, etc.).

⚠️ **Éthique** : Ce projet est à des fins éducatives uniquement. Assurez-vous d'avoir l'autorisation appropriée avant d'effectuer des tests de sécurité.
