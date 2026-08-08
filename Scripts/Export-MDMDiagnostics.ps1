Start-Process -FilePath "MdmDiagnosticsTool.exe" -ArgumentList "-out `"$($env:USERPROFILE)\Desktop\mdm`"" -NoNewWindow -Wait

Start-Process -FilePath "MdmDiagnosticsTool.exe" -ArgumentList "-area Autopilot -cab `"$($env:USERPROFILE)\Desktop\mdm\Autopilot.cab`"" -NoNewWindow -Wait

Start-Process -FilePath "MdmDiagnosticsTool.exe" -ArgumentList "-area DeviceEnrollment -cab `"$($env:USERPROFILE)\Desktop\mdm\DeviceEnrollment.cab`"" -NoNewWindow -Wait

Start-Process -FilePath "MdmDiagnosticsTool.exe" -ArgumentList "-area DeviceProvisioning -cab `"$($env:USERPROFILE)\Desktop\mdm\DeviceProvisioning.cab`"" -NoNewWindow -Wait

Start-Process -FilePath "MdmDiagnosticsTool.exe" -ArgumentList "-area OsConfiguration -cab `"$($env:USERPROFILE)\Desktop\mdm\OsConfiguration.cab`"" -NoNewWindow -Wait

Start-Process -FilePath "MdmDiagnosticsTool.exe" -ArgumentList "-area Tpm -cab `"$($env:USERPROFILE)\Desktop\mdm\Tpm.cab`"" -NoNewWindow -Wait

