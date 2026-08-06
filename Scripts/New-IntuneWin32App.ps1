# work in progress, probably gonna make a bunch of changes
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TenantID,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$ClientID,

    [Parameter(Mandatory = $false, Position = 2)]
    $IntunewinFile = Get-ChildItem -Filter "*.intunewin",

    [Parameter(Mandatory = $false, Position = 3)]
    [string]$DetectionFilePath = "$((Get-Location).Path)\detection.ps1",

    [Parameter(Mandatory = $false, Position = 4)]
    [string]IconFilePath = "$((Get-Location).Path)\icon.jpg"
)

Import-Module IntuneWin32App


$Params = @{
    TenantID = $TenantID
    ClientID = $ClientID
}

Connect-MSIntuneGraph @Params


$Detection   = New-IntuneWin32AppDetectionRuleScript -ScriptFile $DetectionFilePath -EnforceSignatureCheck $false -RunAs32Bit $true
$Requirement = New-IntuneWin32AppRequirementRule -Architecture x64x86 -MinimumSupportedWindowsRelease W10_1607
$Icon        = New-IntuneWin32AppIcon -FilePath $IconFilePath

$Params = @{
    FilePath                         = $IntunewinFile.FullName
    DisplayName                      = "Test"
    Description                      = "Test"
    Publisher                        = "Test"
    AppVersion                       = "1.0"
    CompanyPortalFeaturedApp         = $false
    Icon                             = $Icon
    InstallCommandLine               = "powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File `"setup.ps1`""
    UninstallCommandLine             = "powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File `"setup.ps1`" -Action Uninstall"
    InstallExperience                = "system"
    RestartBehavior                  = "suppress"
    MaximumInstallationTimeInMinutes = 5
    AllowAvailableUninstall          = $true
    DetectionRule                    = $Detection
    RequirementRule                  = $Requirement
}

Add-IntuneWin32App @Params

