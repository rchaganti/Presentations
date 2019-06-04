Import-Module Polaris -Verbose
Import-Module PSHTML -Verbose

New-PolarisStaticRoute -RoutePath "/styles" -FolderPath "./styles"

#REGION GET/POST ROUTES
.\routes\home.ps1
.\routes\usage.ps1
.\routes\deploymentModel.ps1
.\routes\hostNetwork.ps1
.\routes\rdmaOption.ps1
.\routes\deploymentTask.ps1
#ENDREGION

Start-Polaris -Port 8090