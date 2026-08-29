# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
Param (
    [ValidateSet("Install", "Uninstall", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Msi     = Get-ChildItem -Filter "*.msi"
    $LogFile = "$($env:SystemDrive)\AppInstallLogs\Install-Pwsh.log"
    $Params  = [ordered]@{
        FilePath     = "msiexec.exe"
        ArgumentList = "/i $($Msi.Name) /qn /norestart /l*v `"$($LogFile)`""
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
    }

    $Proc = Start-Process @Params
    exit $Proc.ExitCode
}

function Uninstall-Application {
    $ProductCode = "{92D9A5DC-8C64-40D5-B1BC-98DB9C7FDB7F}"
    $LogFile     = "$($env:SystemDrive)\AppInstallLogs\Uninstall-Pwsh.log"
    $Params      = [ordered]@{
        FilePath     = "msiexec.exe"
        ArgumentList = "/x $($ProductCode) /qn /norestart /l*v `"$($LogFile)`""
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
        ErrorAction  = "SilentlyContinue"
    }

    Get-Process | Where-Object { $_.Path -match "PowerShell\\7" } | Stop-Process -Force
    $Proc = Start-Process @Params
    exit $Proc.ExitCode
}

$LogDir = "$($env:SystemDrive)\AppInstallLogs"

if (-not (Test-Path -Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

switch ($Action) {
    "Install"   { Install-Application }
    "Uninstall" { Uninstall-Application }
}
