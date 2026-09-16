@{
    RootModule        = 'ZstArchive.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '7be29be5-5d37-4f3d-a7ed-c671ef5f16aa'
    Author            = 'thaengineer'
    CompanyName       = 'TheLab'
    Copyright         = 'MIT'
    Description       = 'Compress and expand .tar.zst archives using Windows tar.exe (bsdtar/libzstd).'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Compress-Zst', 'Expand-Zst')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
