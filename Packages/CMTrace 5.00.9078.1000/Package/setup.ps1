 # powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Repair
Param (
    [ValidateSet("Install", "Uninstall", "Repair", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Exe        = Get-ChildItem -Filter "*.exe"
    $InstallDir = "$($env:SystemDrive)\Program Files (x86)\CMTrace"
    $KeyPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\CMTrace"

    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Copy-Item -Path $Exe.FullName -Destination "$($InstallDir)\$($Exe.Name)" -Force

    New-Item -Path $KeyPath
    New-ItemProperty -Path $KeyPath -PropertyType String -Name "DisplayName" -Value "CMTrace" -Force
    New-ItemProperty -Path $KeyPath -PropertyType String -Name "DisplayVersion" -Value "5.00.9078.1000" -Force
    New-ItemProperty -Path $KeyPath -PropertyType String -Name "DisplayIcon" -Value "$($InstallDir)\$($Exe.Name)" -Force
    New-ItemProperty -Path $KeyPath -PropertyType String -Name "Publisher" -Value "Microsoft Corporation" -Force
    New-ItemProperty -Path $KeyPath -PropertyType Dword -Name "NoModify" -Value "1" -Force
    New-ItemProperty -Path $KeyPath -PropertyType Dword -Name "NoRepair" -Value "1" -Force
}

function Uninstall-Application {
    $InstallDir = "$($env:SystemDrive)\Program Files (x86)\CMTrace"
    $KeyPath    = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\CMTrace"

    if (Test-Path -Path $InstallDir) {
        Remove-Item -Path $InstallDir -Recurse -Force
    }

    if (Test-Path -Path $KeyPath) {
        Remove-Item -Path $KeyPath -Recurse -Force
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

