Import-Module IntuneWin32App
Import-Module "$($PSScriptRoot)\Modules\ImportDotEnv"

Set-DotEnv -Path "$($PSScriptRoot)\.env"

$Scopes = @(
    "DeviceManagementApps.ReadWrite.All"
)

$Params = @{
    TenantID     = $env:TenantID
    ClientID     = $env:ClientID
    ClientSecret = $env:ClientSecret
    Scopes       = $Scopes
}

Connect-MSIntuneGraph @Params

$Apps = Get-IntuneWin32App
$Custom = Apps | Where-Object { $_."@odata.type" -match "win32LobApp" } `
| Select-Object -Property id,
    displayName,
    displayVersion,
    publisher,
    isAssigned,
    installCommandLine,
    uninstallCommandLine,
    allowedArchitectures,
    applicableArchitectures,
    minimumSupportedWindowsRelease,
    allowAvailableUninstall,
    activeInstallScript,
    activeUninstallScript,
    @{ n = "MinimumSupportedOperatingSystem"; e = { ($_.minimumSupportedOperatingSystem.PSObject.Properties | Where-Object { $_.Value -eq $true }) -replace "bool\s|=True", "" } },
    @{ n = "RunAs32Bit"; e = { $_.detectionRules.runAs32Bit } },
    @{ n = "DetectionScript"; e = { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(($_.detectionRules.scriptContent))) } },
    requirementRules,
    @{ n = "runAsAccount"; e = { $_.installExperience.runAsAccount } },
    @{ n = "maxRunTimeInMinutes"; e = { $_.installExperience.maxRunTimeInMinutes } },
    returnCodes

$Custom

