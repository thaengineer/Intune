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

Push-Location -Path "$($PSScriptRoot)\..\packages"

Get-ChildItem | Where-Object { $_.PSIsContainer } | ForEach-Object {
    Push-Location -Path $_

    $Intunewin = Get-ChildItem -Filter "*.intunewin"
    $Manifest  = Get-ChildItem -Filter "manifest.json"
    $App       = Get-Content $Manifest.FullName -Raw | ConvertFrom-Json
    $Win32App  = Get-IntuneWin32App | Where-Object { $_.DisplayName -eq $App.Application.Name }

    # skip package creation if there's no .intunewin
    if (-not $Intunewin) { continue }

    # skip package creation if package exists
    if ($Win32App) { continue }

    $Detection   = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$((Get-Location).Path)\$($App.Detection.Script)" -EnforceSignatureCheck $App.Detection.EnforceSignatureCheck -RunAs32Bit $App.Detection.RunAs32Bit
    $Requirement = New-IntuneWin32AppRequirementRule -Architecture $App.Requirements.Architecture -MinimumSupportedWindowsRelease $App.Requirements.MinSupportedWinRelease # W10_1607
    $IconFile    = Get-ChildItem -Path (Get-Location).Path | Where-Object { $_.Extension -match "\.(ico|jpg|jpeg|png)" }

    $Params = [ordered]@{
        FilePath                         = $Intunewin.FullName
        DisplayName                      = $App.Application.Name
        Description                      = $App.Application.Description
        Publisher                        = $App.Application.Publisher
        AppVersion                       = $App.Application.Version
        CompanyPortalFeaturedApp         = $App.Application.FeaturedApp
        Owner                            = $App.Application.Owner
        Developer                        = $App.Application.Developer
        InstallCommandLine               = ($App.Install.Command, $App.Install.Arguments -join " ")
        UninstallCommandLine             = ($App.Uninstall.Command, $App.Uninstall.Arguments -join " ")
        InstallExperience                = $App.Install.Context
        RestartBehavior                  = $App.Install.RestartBehavior
        MaximumInstallationTimeInMinutes = $App.Install.TimeoutMinutes
        AllowAvailableUninstall          = $App.Application.AllowAvailableUninstall
        DetectionRule                    = $Detection
        RequirementRule                  = $Requirement
    }

    if ($IconFile) {
        $Icon = New-IntuneWin32AppIcon -FilePath $IconFile.FullName -ErrorAction SilentlyContinue
        $Params["Icon"] = $Icon
    }

    Add-IntuneWin32App @Params
    Pop-Location
}

Pop-Location

