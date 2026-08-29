$Exe     = Get-ChildItem -Path "$($PSScriptRoot)\..\bin" -Filter "IntuneWinAppUtil.exe"
$ExeArgs = "-c .\Package -s .\Package\setup.ps1 -o .\"

if ($Exe) {
    Start-Process -FilePath $Exe.FullName -ArgumentList $ExeArgs -NoNewWindow -Wait
    Rename-Item -Path "setup.intunewin" -NewName "$((Get-Location).Path | Split-Path -Leaf).intunewin"
}

