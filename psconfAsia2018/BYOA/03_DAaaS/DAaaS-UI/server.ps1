using module "C:\Program Files\WindowsPowerShell\Modules\Polaris\0.1.0\Polaris.psd1"
Import-Module PSHTML -Verbose

#REGION GET ROUTES
.\routes\home.ps1
.\routes\usage.ps1
#ENDREGION

Start-Polaris -Port 8090