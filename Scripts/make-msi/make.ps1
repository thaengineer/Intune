Import-Module -Name ps2exe

$Params = @{
    inputFile      = '.\FILE_NAME.ps1'
    outputFile     = '.\FILE_NAME.exe'
    x64            = $true
    noConsole      = $true
    title          = 'Liquit Collection Member Mgmt'
    company        = 'None'
    product        = 'Liquit Collection Member Mgmt'
    copyright      = 'MIT License'
    version        = '1.0'
    noConfigFile   = $true
    noVisualStyles = $true
}

Invoke-ps2exe @Params

