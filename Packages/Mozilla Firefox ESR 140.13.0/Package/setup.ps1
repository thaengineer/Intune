# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Repair
Param (
    [ValidateSet("Install", "Uninstall", "Repair", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Exe       = Get-ChildItem -Filter "*.exe"
    $Ini       = Get-ChildItem -Filter "*.ini"
    $ExeArgs   = "/S /INI=`"$($Ini.FullName)`""
    $Policies  = Get-ChildItem -Filter "*.json"
    $PolicyDir = "$($env:SystemDrive)\Program Files\Mozilla Firefox\distribution"

    Start-Process -FilePath $Exe.FullName -ArgumentList $ExeArgs -NoNewWindow -Wait

    if (-not (Test-Path -Path $PolicyDir)) {
        New-Item -ItemType Directory -Path $PolicyDir -Force | Out-Null
    }

    Copy-Item -Path $Policies.FullName -Destination "$($PolicyDir)\$($Policies.Name)" -Force
}

function Uninstall-Application {
    $Exes = @(
        "$($env:ProgramFiles)\Mozilla Firefox\uninstall\helper.exe",
        "$(${env:ProgramFiles(x86)})\Mozilla Firefox\uninstall\helper.exe",
        "$(${env:ProgramFiles(x86)})\Mozilla Maintenance Service\uninstall.exe"
    )

    $Exes | ForEach-Object {
        if (Test-Path -Path $_) {
            $ExeArgs = "-ms"

            Get-Process | Where-Object { $_.Path -match "Mozilla" } | Stop-Process -Force
            Start-Process -FilePath $_ -ArgumentList $ExeArgs -NoNewWindow -Wait
        }
    }
}

function Repair-Application {
    Uninstall-Application
    Install-Application
}

switch ($Action) {
    "Install"   { Install-Application }
    "Uninstall" { Uninstall-Application }
    "Repair"    { Repair-Application }
}
