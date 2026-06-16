# deploy-sysmon-config.ps1 - Install Sysmon with bundled ZSEC lab config
# Bundled config (sysmonconfig.xml) is deployed by Ansible before this script runs.
# Internet download is only attempted if the bundled config is somehow missing.
param([switch]$Force)

$ErrorActionPreference = "Continue"
$SysmonDir = "C:\Tools\Sysmon"
$SysmonExe = Join-Path $SysmonDir "Sysmon64.exe"
$ConfigUrl = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
$ConfigPath = "$SysmonDir\sysmonconfig.xml"
$BootstrapPath = "$SysmonDir\sysmonconfig-bootstrap.xml"
$Script:LastSysmonOutput = ""

function Get-Sha256Hex {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return $null
    }
    if (Get-Command Get-FileHash -ErrorAction SilentlyContinue) {
        return (Get-FileHash -Path $Path -Algorithm SHA256).Hash.ToLower()
    }
    $sha = New-Object System.Security.Cryptography.SHA256Managed
    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-", "").ToLower()
    } finally {
        $sha.Dispose()
    }
}

function Invoke-SysmonCli {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$ArgumentList
    )

    $stdoutFile = Join-Path $env:TEMP ("sysmon-out-{0}.log" -f ([guid]::NewGuid().ToString("N")))
    $stderrFile = Join-Path $env:TEMP ("sysmon-err-{0}.log" -f ([guid]::NewGuid().ToString("N")))
    $Script:LastSysmonOutput = ""

    try {
        $proc = Start-Process -FilePath $SysmonExe `
            -ArgumentList $ArgumentList `
            -Wait -PassThru -NoNewWindow `
            -RedirectStandardOutput $stdoutFile `
            -RedirectStandardError $stderrFile
        $chunks = @()
        foreach ($file in @($stdoutFile, $stderrFile)) {
            if (Test-Path $file) {
                $text = Get-Content -Path $file -ErrorAction SilentlyContinue
                if ($text) {
                    $joined = $text -join [Environment]::NewLine
                    $chunks += $joined
                    Write-Host $joined
                }
            }
        }
        $Script:LastSysmonOutput = ($chunks -join [Environment]::NewLine)
        return $proc.ExitCode
    } finally {
        Remove-Item -Path $stdoutFile, $stderrFile -Force -ErrorAction SilentlyContinue
    }
}

function Test-SysmonConfigApplied {
    param(
        [Parameter(Mandatory = $true)]
        [int]$ExitCode
    )

    if ($Script:LastSysmonOutput -match "Configuration file validated") {
        return $true
    }
    if ($ExitCode -eq 0) {
        return $true
    }
    # Sysmon validates config before checking elevation.
    if ($ExitCode -eq 740 -and $Script:LastSysmonOutput -match "schema version") {
        return $true
    }
    return $false
}

function Test-SysmonRunning {
    $svc = Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue
    return ($svc -and $svc.Status -eq "Running")
}

function Install-SysmonBase {
    if (Test-Path $BootstrapPath) {
        Write-Host "[*] Installing Sysmon64 with bootstrap config..." -ForegroundColor Yellow
        $exitCode = Invoke-SysmonCli @("-accepteula", "-i", $BootstrapPath)
    } else {
        Write-Host "[*] Installing Sysmon64 with default profile..." -ForegroundColor Yellow
        $exitCode = Invoke-SysmonCli @("-accepteula", "-i")
    }
    if ($exitCode -ne 0 -and -not (Test-SysmonRunning)) {
        throw "Sysmon base install failed (exit code: $exitCode)"
    }

    Start-Sleep -Seconds 3
}

function Apply-SysmonConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Write-Host "[*] Applying Sysmon config: $Path" -ForegroundColor Yellow
    $configHash = Get-Sha256Hex -Path $Path
    if ($configHash) {
        Write-Host "[+] Config SHA256: $configHash" -ForegroundColor Green
    }

    $exitCode = Invoke-SysmonCli @("-c", $Path)
    if (Test-SysmonConfigApplied -ExitCode $exitCode) {
        return
    }

    throw "Sysmon config apply failed (exit code: $exitCode). Config SHA256: $configHash. Output did not contain 'Configuration file validated'."
}

Write-Host "[*] Deploying Sysmon configuration..." -ForegroundColor Cyan

if (Test-Path $ConfigPath) {
    Write-Host "[+] Using bundled Sysmon config: $ConfigPath" -ForegroundColor Green
} else {
    Write-Host "[!] Bundled config not found -- attempting download..." -ForegroundColor Yellow
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if ($PSVersionTable.PSVersion.Major -ge 3) {
            Invoke-WebRequest -Uri $ConfigUrl -OutFile $ConfigPath -UseBasicParsing
        } else {
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile($ConfigUrl, $ConfigPath)
        }
        Write-Host "[+] Downloaded Sysmon config to $ConfigPath" -ForegroundColor Green
    } catch {
        Write-Host "[!] Download failed: $_" -ForegroundColor Red
        Write-Host "[!] No config available -- aborting Sysmon install" -ForegroundColor Red
        exit 1
    }
}

$sysmonService = Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue
if ($sysmonService -and -not $Force) {
    Write-Host "[*] Sysmon already installed, updating config..." -ForegroundColor Yellow
    try {
        Apply-SysmonConfig -Path $ConfigPath
    } catch {
        Write-Host "[!] Config update failed: $_" -ForegroundColor Red
        Write-Host "[*] Retrying with clean reinstall (bootstrap + full config)..." -ForegroundColor Yellow
        Invoke-SysmonCli @("-u", "force") | Out-Null
        Start-Sleep -Seconds 2
        Install-SysmonBase
        Apply-SysmonConfig -Path $ConfigPath
    }
} else {
    if ($sysmonService -or (Test-Path "$env:Windir\Sysmon64.exe")) {
        Write-Host "[*] Removing stale Sysmon installation..." -ForegroundColor Yellow
        Invoke-SysmonCli @("-u", "force") | Out-Null
        Start-Sleep -Seconds 2
    }

    Install-SysmonBase
    Apply-SysmonConfig -Path $ConfigPath
}

Start-Sleep -Seconds 2

if (Test-SysmonRunning) {
    Write-Host "[+] Sysmon64 is running" -ForegroundColor Green
} else {
    throw "Sysmon64 service not running -- install may have failed silently"
}
