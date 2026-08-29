# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
Param (
    [ValidateSet("Install", "Uninstall", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Exe       = Get-ChildItem -Filter "*.exe"
    $Ini       = Get-ChildItem -Filter "*.ini"
    $Policies  = Get-ChildItem -Filter "*.json"
    $PolicyDir = "$($env:SystemDrive)\Program Files\Mozilla Firefox\distribution"
    $Params    = [ordered]@{
        FilePath     = $Exe.FullName
        ArgumentList = "/S /INI=`"$($Ini.FullName)`""
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
    }

    $Proc = Start-Process @Params

    if (-not (Test-Path -Path $PolicyDir)) {
        New-Item -ItemType Directory -Path $PolicyDir -Force | Out-Null
    }

    Copy-Item -Path $Policies.FullName -Destination "$($PolicyDir)\$($Policies.Name)" -Force

    exit $Proc.ExitCode
}

function Uninstall-Application {
    $Exe    = "$($env:ProgramFiles)\Mozilla Firefox\uninstall\helper.exe"
    $Params = [ordered]@{
        FilePath     = $Exe
        ArgumentList = "-ms"
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
        ErrorAction  = "SilentlyContinue"
    }

    Get-Process | Where-Object { $_.Path -match "Mozilla" } | Stop-Process -Force
    $Proc = Start-Process @Params
    exit $Proc.ExitCode
}

switch ($Action) {
    "Install"   { Install-Application }
    "Uninstall" { Uninstall-Application }
}
