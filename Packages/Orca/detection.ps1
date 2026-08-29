$Name     = "Orca"
$Version  = "10.1.28000.2526"
$X64Key   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
$X86Key   = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$Products = @(Get-ItemProperty -Path $X64Key, $X86Key | Where-Object { $_.DisplayName -eq $Name })

if ($Products) {
   $Latest  = ($Products | ForEach-Object { [version]($_.DisplayVersion -replace "[a-z]", "") } | Sort-Object)[-1]
   $Product = $Products | Where-Object { $_.DisplayName -eq $Name -and [version]($_.DisplayVersion -replace "[a-z]", "") -eq $Latest }

   if ([version]($Product.DisplayVersion -replace "[a-z]", "") -ge [version]$Version) {
       Write-Host "Installed"
       exit 0
   } else {
       exit 0
   }
} else {
   exit 0
}
