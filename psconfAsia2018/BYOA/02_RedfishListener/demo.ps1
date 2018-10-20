Import-Module C:\github\PSRedfishListener\PSRedfishListener\PSRedfishListener.psd1 -Force
Get-Command -Module PSRedfishListener

Start-PSRedfishEventListener -Verbose
Send-PSRedfishTestEvent -MockEvent -EventDestination https://localhost -Verbose

Stop-PSRedfishEventListener -IPAddress localhost