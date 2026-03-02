# 0x00 What The Shell

Challenges de bypass de blacklist shell. L'objectif dans chaque tâche est de lire `/home/user/flag` malgré des restrictions croissantes.

---

## Tâche 0 — `1-flag.txt`

**Technique : quotes vides pour fragmenter un nom de fichier**

Le filtre bloque la chaîne `flag` et les wildcards `*`. En insérant des quotes vides `''` ou `""` dans le nom, le shell résout le chemin normalement mais la blacklist ne reconnaît plus le mot :

```bash
cat /home/user/fla''g
cat /home/user/fla""g
```

---

## Tâche 1 — `2-flag.txt`

**Technique : `$IFS` comme substitut de l'espace**

En plus des restrictions précédentes, le caractère espace est blacklisté. La variable `$IFS` (Internal Field Separator) est interprétée par le shell comme séparateur de mots, ce qui permet de remplacer l'espace entre une commande et son argument :

```bash
cat${IFS}/home/user/fla''g
```

Une tabulation réelle fonctionne aussi comme séparateur :

```bash
cat	/home/user/fla''g
```

---

## À retenir

- Les blacklists basées sur du matching de chaînes sont contournables en fragmentant les mots clés (quotes vides, variables).
- `$IFS` est une alternative au space reconnue par bash mais souvent ignorée des filtres.
- En l'absence de `cat`, d'autres commandes lisent des fichiers : `less`, `more`, `tac`, `dd`, `python3`.
