param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$PS1File,

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$Title = "TestTitle",

    [Parameter(Mandatory = $false, Position = 2)]
    [string]$Company = "None",

    [Parameter(Mandatory = $false, Position = 3)]
    [string]$ProductName = "TestProduct",

    [Parameter(Mandatory = $false, Position = 4)]
    [string]$Copyright = "MIT License",

    [Parameter(Mandatory = $false, Position = 5)]
    [string]$Version = "1.0.0"
)

Import-Module -Name ps2exe

$ScriptFile = Get-ChildItem -Path $PS1File

$Params = @{
    inputFile      = $ScriptFile.FullName
    outputFile     = ".\$($ScriptFile.BaseName).exe"
    x64            = $true
    noConsole      = $true
    title          = $Title
    company        = $Company
    product        = $ProductName
    copyright      = $Copyright
    version        = $Version
    noConfigFile   = $true
    noVisualStyles = $true
}

Invoke-ps2exe @Params

