# Shared license check for GOAD windows_activation (MAS / TSforge / eval images).
function Get-GoadWindowsLicenseState {
    $result = [ordered]@{
        IsLicensed    = $false
        LicensedCount = 0
        Method        = ''
        SlmgrXpr      = ''
        ProductType   = (Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue).ProductType
    }

    $xpr = ''
    try {
        $xpr = (& cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /xpr 2>&1 | Out-String).Trim()
        $result.SlmgrXpr = $xpr
        if ($xpr -match '(?i)permanently activated|machine is permanently activated') {
            $result.IsLicensed = $true
            $result.Method = 'slmgr-xpr-permanent'
        }
        elseif ($xpr -match '(?i)volume activation will expire|retail activation will expire') {
            # KMS / TSforge often reports a far-future expiry — still activated for lab use.
            $result.IsLicensed = $true
            $result.Method = 'slmgr-xpr-expiry'
        }
    }
    catch { }

    try {
        $dli = (& cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1 | Out-String).Trim()
        if ($dli -match '(?i)License Status:\s*Licensed') {
            $result.IsLicensed = $true
            $result.Method = 'slmgr-dli'
        }
    }
    catch { }

    $products = Get-CimInstance SoftwareLicensingProduct -Filter "ApplicationID='55c92734-d682-4d71-983e-d6ec31516909'" -ErrorAction SilentlyContinue
    # 1=Licensed, 2=OOB grace, 3=OOT grace, 6=extended grace (common on eval after TSforge).
    $active = @($products | Where-Object { $_.PartialProductKey -and ($_.LicenseStatus -in 1, 2, 3, 6) })
    $result.LicensedCount = $active.Count
    if (-not $result.IsLicensed -and $active.Count -gt 0) {
        $result.IsLicensed = $true
        $result.Method = 'wmi-license-status'
    }

    $result
}
