# 0x04. Buffer Overflow

## Description

Ce projet explore les concepts de débordement de tampon (buffer overflow) et la manipulation de la mémoire des processus sous Linux.

## Objectifs d'apprentissage

À la fin de ce projet, vous devriez être capable d'expliquer :

- Qu'est-ce qu'un tampon (buffer) ?
- Qu'est-ce qu'un débordement de tampon (Buffer Overflow) ?
- Qu'est-ce qu'une attaque par débordement de tampon ?
- Quelles sont les causes des attaques par débordement de tampon ?
- Comment les attaquants orchestrent-ils les attaques par débordement de tampon ?
- Quels sont les différents types d'attaques par débordement de tampon ?
- Comment détecter un débordement de tampon ?
- Quelles sont les conséquences d'un débordement de tampon ?
- Comment prévenir et atténuer les attaques par débordement de tampon ?

## Ressources

- [ressources.md](ressources.md) - Documentation complète sur les buffer overflows en français
- [WALKTHROUGH.md](WALKTHROUGH.md) - Guide détaillé étape par étape pour la tâche 0

## Requirements

### Python Scripts

- Éditeurs autorisés : `vi`, `vim`, `emacs`
- Tous les fichiers seront interprétés/compilés sur Ubuntu 14.04 LTS avec `python3` (version 3.4.3)
- Tous les fichiers doivent se terminer par une nouvelle ligne
- La première ligne de tous les fichiers doit être exactement `#!/usr/bin/python3`
- Votre code doit utiliser le style PEP 8
- Tous vos fichiers doivent être exécutables
- Documentation obligatoire :
  - Module : `python3 -c 'print(__import__("my_module").__doc__)'`
  - Classes : `python3 -c 'print(__import__("my_module").MyClass.__doc__)'`
  - Fonctions : `python3 -c 'print(__import__("my_module").my_function.__doc__)'`

## Tâches

### 0. Hack the VM

**Objectif** : Écrire un script qui trouve une chaîne dans le heap d'un processus en cours d'exécution et la remplace par une autre chaîne.

**Fichier** : `read_write_heap.py`

**Usage** :
```bash
./read_write_heap.py pid search_string replace_string
```

**Où** :
- `pid` est l'identifiant du processus en cours d'exécution
- `search_string` et `replace_string` sont des chaînes ASCII
- Le script ne doit chercher que dans le heap du processus

**Exemple** :

Terminal 1 - Programme cible :
```bash
gcc -Wall -pedantic -Werror -Wextra main.c -o main
./main
[0] Holberton (0x555e646e02a0)
[1] Holberton (0x555e646e02a0)
[2] Holberton (0x555e646e02a0)
...
[92] maroua (0x555e646e02a0)  # Changement après exécution du script
[93] maroua (0x555e646e02a0)
```

Terminal 2 - Exécution du script :
```bash
ps aux | grep ./main
# maroua    6515 0.0  0.0   2776  1040 pts/1    S+   10:53   0:00 ./main

sudo python3 ./read_write_heap.py 6515 Holberton maroua
```

**Concepts clés** :

1. **Système de fichiers /proc** :
   - `/proc/[PID]/maps` : Carte mémoire du processus
   - `/proc/[PID]/mem` : Accès direct à la mémoire du processus

2. **Zones mémoire d'un processus** :
   - Stack (pile) : Variables locales, adresses de retour
   - Heap (tas) : Allocations dynamiques (malloc, strdup)
   - Data : Variables globales
   - Text : Code exécutable

3. **Manipulation de la mémoire** :
   - Lecture des mappings mémoire
   - Recherche de chaînes dans le heap
   - Écriture directe en mémoire
   - Gestion des permissions (nécessite sudo)

## Auteur

Projet réalisé dans le cadre du cursus Holberton School - Cybersécurité

## Notes importantes

⚠️ **Sécurité** : Ce projet est à des fins éducatives uniquement. La manipulation de la mémoire de processus nécessite des privilèges élevés et doit être utilisée de manière responsable.

⚠️ **Permissions** : Le script nécessite des permissions root (sudo) pour accéder à `/proc/[PID]/mem`.

⚠️ **Buffer Overflow** : Le script inclut des protections pour éviter d'écrire au-delà de la taille de la chaîne originale, prévenant ainsi les buffer overflows.

## Tests

Pour tester le script :

1. Compiler le programme test :
```bash
gcc -Wall -pedantic -Werror -Wextra main.c -o main
```

2. Lancer le programme dans un terminal :
```bash
./main
```

3. Dans un autre terminal, trouver le PID et exécuter le script :
```bash
pidof main
sudo python3 ./read_write_heap.py [PID] Holberton [votre_nom]
```

4. Observer le changement dans le premier terminal

## Vérifications

### Style PEP 8
```bash
pycodestyle read_write_heap.py
```

### Documentation
```bash
python3 -c 'print(__import__("read_write_heap").__doc__)'
python3 -c 'print(__import__("read_write_heap").find_heap.__doc__)'
python3 -c 'print(__import__("read_write_heap").get_heap.__doc__)'
python3 -c 'print(__import__("read_write_heap").write_heap.__doc__)'
python3 -c 'print(__import__("read_write_heap").main.__doc__)'
```

### Permissions
```bash
ls -l read_write_heap.py
# Doit afficher : -rwxr-xr-x
```