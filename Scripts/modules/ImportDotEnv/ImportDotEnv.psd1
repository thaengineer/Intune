 @{
    RootModule        = 'ImportDotEnv.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'b7c3e8a1-4d2f-4a9b-9c1e-8f2a6d0e1b44'
    Author            = 'thaengineer'
    CompanyName       = 'Local'
    Copyright         = '(c) 2026. All rights reserved.'
    Description       = 'Parse .env files into hashtables and optional process environment variables.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Import-DotEnv', 'Set-DotEnv')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}

