 Import-Module .\Modules\ImportDotEnv

Set-DotEnv -Path ".env"

$TenantID     = $env:TenantID
$ClientID     = $env:ClientID
$ClientSecret = $env:ClientSecret
$SecureSecret = ConvertTo-SecureString $ClientSecret -AsPlainText -Force
$Credential   = [pscredential]::new($ClientID, $SecureSecret)

Connect-MgGraph -TenantId $TenantID -ClientSecretCredential $Credential -NoWelcome
Get-MgContext

