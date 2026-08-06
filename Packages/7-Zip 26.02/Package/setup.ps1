# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Repair
Param (
    [ValidateSet("Install", "Uninstall", "Repair", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Exe     = Get-ChildItem -Filter "*.exe"
    $ExeArgs = "/S"

    Start-Process -FilePath $Exe.FullName -ArgumentList $ExeArgs -NoNewWindow -Wait
}

function Uninstall-Application {
    $Exes = @(
        "$($env:ProgramFiles)\7-Zip\Uninstall.exe",
        "$(${env:ProgramFiles(x86)})\7-Zip\Uninstall.exe"
    )

    $Exes | ForEach-Object {
        if (Test-Path -Path $_) {
            $ExeArgs = "/S"

            Get-Process | Where-Object { $_.Path -match "7-Zip" } | Stop-Process -Force
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
