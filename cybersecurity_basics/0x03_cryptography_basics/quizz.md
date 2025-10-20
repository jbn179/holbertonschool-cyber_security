# Quiz Cryptographie et Craquage de Mots de Passe

## Question #0
**Cryptography, a word with Greek origins, means**

- [ ] corrupting data
- [ ] open writing
- [x] secret writing
- [ ] closed writing

## Question #1
**Cryptography can provide**

- [x] Entity authentication
- [ ] Encryption Size
- [x] Nonrepudiation of messages
- [x] Security

## Question #2
**Keys used in cryptography are**

- [x] Secret key
- [x] Private key
- [x] Public key
- [x] symmetric key

## Question #3
**SHA means**

- [ ] Secret Hash Algorithm
- [x] Secure Hash Algorithm
- [ ] Sneaky Hash Algorithm
- [ ] Super Hash Algorithm

## Question #4
**Symmetric encryption is**

- [ ] Used to conceal small blocks of data, such as encryption keys and hash function values, which are used in digital signatures
- [x] Used to conceal the contents of block or stream of data of any size, including messages, files, encryption keys, and passwords
- [ ] Used to protect blocks of data, such as messages, from alteration
- [ ] These are schemes based on the use of cryptographic algorithms designed to authenticate the identity of entities

## Question #5
**Digital Signatures are**

- [x] Proof of authenticity of the sender
- [ ] Proof of authenticity of the verifier
- [ ] Proof of authenticity of the receiver
- [ ] Proof of authenticity of Alice

## Question #6
**A hash function is a way to verify that a message has not been**

- [ ] Replaced
- [x] Changed
- [ ] Over view
- [ ] Deleted

## Question #7
**Message digest is referred to**

- [ ] Digital signature
- [x] Hash function
- [ ] Digital signature with hash function
- [ ] RSA

## Question #8
**Which tool is used for password cracking in Kali Linux**

- [x] John the Ripper
- [x] hashcat
- [ ] Aircrack-ng
- [ ] Wireshark

## Question #9
**What are the different modes of operation supported by John the Ripper**

- [x] Single crack
- [x] Incremental
- [x] Wordlist
- [x] External

## Question #10
**John the Ripper is a tool that can be used to assess to**

- [ ] Usernames
- [ ] Firewall rulesets
- [x] Passwords
- [ ] File permissions

## Question #11
**What is the hashcat's option that used to combine two wordlists**

- [ ] -b
- [ ] stdout
- [x] -a
- [ ] -m

---

## Réponses et Explications

### Question #0 - Réponse : secret writing
La cryptographie vient du grec "kryptos" (caché) et "graphein" (écrire), signifiant littéralement "écriture secrète".

### Question #1 - Réponses : Entity authentication, Nonrepudiation of messages, Security
La cryptographie fournit les quatre piliers de la sécurité : confidentialité, intégrité, authentification et non-répudiation.

### Question #2 - Réponses : Toutes
En cryptographie, on utilise différents types de clés selon le système : clés secrètes (symétriques), clés privées et publiques (asymétriques).

### Question #3 - Réponse : Secure Hash Algorithm
SHA signifie "Secure Hash Algorithm", une famille d'algorithmes de hachage cryptographiques.

### Question #4 - Réponse : Used to conceal the contents of block or stream of data of any size
Le chiffrement symétrique utilise la même clé pour chiffrer et déchiffrer des données de toute taille.

### Question #5 - Réponse : Proof of authenticity of the sender
Les signatures numériques prouvent l'authenticité de l'expéditeur et garantissent la non-répudiation.

### Question #6 - Réponse : Changed
Les fonctions de hachage permettent de vérifier l'intégrité des données en détectant toute modification.

### Question #7 - Réponse : Hash function
Un "message digest" fait référence au résultat d'une fonction de hachage.

### Question #8 - Réponses : John the Ripper, hashcat
Ces deux outils sont les standards pour le craquage de mots de passe sous Kali Linux.

### Question #9 - Réponses : Toutes
John the Ripper supporte plusieurs modes : Single crack, Incremental, Wordlist et External.

### Question #10 - Réponse : Passwords
John the Ripper est spécifiquement conçu pour évaluer la robustesse des mots de passe.

### Question #11 - Réponse : -a
L'option `-a` dans hashcat spécifie le mode d'attaque, incluant la combinaison de wordlists.