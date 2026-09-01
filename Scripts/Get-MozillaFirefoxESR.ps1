$PkgDir = "$($PSScriptRoot)\..\packages\Mozilla Firefox ESR\Package"

if (-not (Test-Path -Path $PkgDir)) { return }

Get-ChildItem -Path $PkgDir -Filter "*.exe" | Remove-Item -Force

# winget search -q "" -s "winget"
winget download -q "Mozilla Firefox ESR (en-US)" -s "winget" -d $PkgDir --skip-license
Get-ChildItem -Path $PkgDir -Filter "*.yaml" | Remove-Item -Force

$Exe     = Get-ChildItem -Path $PkgDir -Filter "*.exe"
$Version = ($Exe.Name | Select-String -Pattern "\d+(\.\d+){1,3}").Matches.Value

Rename-Item -Path $Exe.FullName -NewName "Mozilla Firefox $($Version)esr.exe" -Force

