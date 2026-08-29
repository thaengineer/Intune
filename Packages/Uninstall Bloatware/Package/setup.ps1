# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Uninstall
# powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "setup.ps1" -Action Repair
Param (
    [ValidateSet("Install", "Uninstall", "Repair")]
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Action = "Install"
)

function Install-Application {
}

function Uninstall-Application {
    $Apps = @(
        "Microsoft.549981C3F5F10",
        "Microsoft.BingSearch",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.MixedReality.Portal",
        "Microsoft.Office.OneNote",
        "Microsoft.OutlookForWindows",
        "Microsoft.People",
        "Microsoft.SkypeApp",
        "Microsoft.Windows.DevHome",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsCamera",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )

    $Apps | ForEach-Object {
        $Package = Get-AppxPackage -Name $_ -ErrorAction SilentlyContinue

        if ($Package) {
            Remove-AppxPackage -Package $Package.PackageFullName -ErrorAction SilentlyContinue
        }
    }
}

function Repair-Application {
}

switch ($Action) {
    "Install"   { Install-Application }
    "Uninstall" { Uninstall-Application }
    "Repair"    { Repair-Application }
}
