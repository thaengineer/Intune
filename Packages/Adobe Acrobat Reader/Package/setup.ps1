# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
Param (
    [ValidateSet("Install", "Uninstall", IgnoreCase = $true)]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
    $Msi     = Get-ChildItem -Filter "*.msi"
    $Mst     = Get-ChildItem -Filter "*.mst"
    $Msp     = Get-ChildItem -Filter "*.msp"
    $LogFile = "$($env:SystemDrive)\AppInstallLogs\Install-AdobeAcrobatReader.log"
    $Params  = [ordered]@{
        FilePath     = "msiexec.exe"
        ArgumentList = "/i `"$($Msi.Name)`" TRANSFORMS=`"$($Mst.Name)`" PATCH=`"$($Msp.FullName)`" IGNOREVCRT64=1 /qn /norestart /l*v `"$($LogFile)`""
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
    }

    $Proc = Start-Process @Params
    # AdobeARMservice (Adobe Acrobat Update Service)
    exit $Proc.ExitCode
}

function Uninstall-Application {
    $ProductCode = "{AC76BA86-7AD7-1033-7B44-AC0F074E4100}"
    $LogFile     = "$($env:SystemDrive)\AppInstallLogs\Uninstall-AdobeAcrobatReader.log"
    $Params      = [ordered]@{
        FilePath     = "msiexec.exe"
        ArgumentList = "/x $($ProductCode) /qn /norestart /l*v `"$($LogFile)`""
        NoNewWindow  = $true
        Wait         = $true
        PassThru     = $true
        ErrorAction  = "SilentlyContinue"
    }

    Get-Process | Where-Object { $_.Path -match "Adobe Reader" } | Stop-Process -Force
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

