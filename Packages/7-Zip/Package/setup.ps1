# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
Param (
    [ValidateSet("Install", "Uninstall", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Exe    = Get-ChildItem -Filter "*.exe"
    $Params = [ordered]@{
        FilePath     = $Exe.FullName
        ArgumentList = "/S"
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
    }

    $Proc = Start-Process @Params
    exit $Proc.ExitCode
}

function Uninstall-Application {
    $Exe = "$($env:ProgramFiles)\7-Zip\Uninstall.exe"
    $Params = [ordered]@{
        FilePath     = $_
        ArgumentList = "/S"
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
        ErrorAction  = "SilentlyContinue"
    }

    Get-Process | Where-Object { $_.Path -match "7-Zip" } | Stop-Process -Force
    $Proc = Start-Process @Params
    exit $Proc.ExitCode
}

switch ($Action) {
    "Install"   { Install-Application }
    "Uninstall" { Uninstall-Application }
}
