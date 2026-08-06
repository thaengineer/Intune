$Name    = "Orca"
$Version = "10.1.28000.2526"
$X64Key  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$X86Key  = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$Product = Get-ItemProperty -Path $X64Key, $X86Key | Where-Object { $_.DisplayName -eq $Name }

if ($Product) {
    if ([version]$Product.DisplayVersion -ge [version]$Version) {
        Write-Host "Installed"
        exit 0
    } else {
        exit 0
    }
} else {
    exit 0
}