$Exe     = "Z:\IntuneLab\bin\IntuneWinAppUtil.exe"
$ExeArgs = "-c .\Package -s .\Package\setup.ps1 -o .\"

if (Test-Path -Path $Exe) {
    Start-Process -FilePath $Exe -ArgumentList $ExeArgs -NoNewWindow -Wait
    Rename-Item -Path "setup.intunewin" -NewName "$((Get-Location).Path | Split-Path -Leaf).intunewin"
}
