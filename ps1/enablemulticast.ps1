New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT" -name "DNSClient"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Value 0