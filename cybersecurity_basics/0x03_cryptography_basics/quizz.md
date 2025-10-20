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

## R�ponses et Explications

### Question #0 - R�ponse : secret writing
La cryptographie vient du grec "kryptos" (cach�) et "graphein" (�crire), signifiant litt�ralement "�criture secr�te".

### Question #1 - R�ponses : Entity authentication, Nonrepudiation of messages, Security
La cryptographie fournit les quatre piliers de la s�curit� : confidentialit�, int�grit�, authentification et non-r�pudiation.

### Question #2 - R�ponses : Toutes
En cryptographie, on utilise diff�rents types de cl�s selon le syst�me : cl�s secr�tes (sym�triques), cl�s priv�es et publiques (asym�triques).

### Question #3 - R�ponse : Secure Hash Algorithm
SHA signifie "Secure Hash Algorithm", une famille d'algorithmes de hachage cryptographiques.

### Question #4 - R�ponse : Used to conceal the contents of block or stream of data of any size
Le chiffrement sym�trique utilise la m�me cl� pour chiffrer et d�chiffrer des donn�es de toute taille.

### Question #5 - R�ponse : Proof of authenticity of the sender
Les signatures num�riques prouvent l'authenticit� de l'exp�diteur et garantissent la non-r�pudiation.

### Question #6 - R�ponse : Changed
Les fonctions de hachage permettent de v�rifier l'int�grit� des donn�es en d�tectant toute modification.

### Question #7 - R�ponse : Hash function
Un "message digest" fait r�f�rence au r�sultat d'une fonction de hachage.

### Question #8 - R�ponses : John the Ripper, hashcat
Ces deux outils sont les standards pour le craquage de mots de passe sous Kali Linux.

### Question #9 - R�ponses : Toutes
John the Ripper supporte plusieurs modes : Single crack, Incremental, Wordlist et External.

### Question #10 - R�ponse : Passwords
John the Ripper est sp�cifiquement con�u pour �valuer la robustesse des mots de passe.

### Question #11 - R�ponse : -a
L'option `-a` dans hashcat sp�cifie le mode d'attaque, incluant la combinaison de wordlists.