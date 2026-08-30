$Modules = @(
    "MSI",
    "PSMSI",
    "ps2exe",
    "IntuneWin32App",
    "Microsoft.Graph"
)

$Modules | Foreach-Object {
    $Params = @{
        Name  = $_
        Scope = "CurrentUser"
        Force = $true
    }

    Install-Module @Params
}
