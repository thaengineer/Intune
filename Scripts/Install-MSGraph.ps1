 $Url         = "https://www.powershellgallery.com/packages/Microsoft.Graph"
$Response    = Invoke-WebRequest -Uri $Url -UseBasicParsing -MaximumRedirection 10
$RedirectUrl = $Response.BaseResponse.ResponseUri.AbsoluteUri
$Version     = ($RedirectUrl | Select-String -Pattern "\d+(\.\d+){1,3}").Matches.Value

if ($Version) {
    Install-Module -Name "Microsoft.Graph" -MinimumVersion $Version -Scope CurrentUser -Force
} else {
    throw "Could not parse latest Microsoft.Graph version from $uri"
}

