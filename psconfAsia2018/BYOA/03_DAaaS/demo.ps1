ipmo C:\Github\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1 -Force

#region backend commands
Get-InfrastructureType
Get-InfrastructureType -Name 'Microsoft Storage Spaces Direct'

Get-InfrastructureUsageModel -InfrastructureType 'Microsoft Storage Spaces Direct'
Get-InfrastructureUsageModel -InfrastructureType 'Microsoft Storage Spaces Direct' -Name 'Hyper-Converged Infrastructure'

Get-InfrastructureDeploymentModel -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure'
Get-InfrastructureDeploymentModel -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -Name 'Scalable'

Get-InfrastructureHostNetworkOption -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -DeploymentModel 'Scalable'
Get-InfrastructureHostNetworkOption -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -DeploymentModel 'Scalable' -Name Fully-Converged

Get-InfrastructureHostNetworkRdmaOption -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -DeploymentModel 'Scalable' -HostNetwork 'Fully-Converged'
Get-InfrastructureHostNetworkRdmaOption -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -DeploymentModel 'Scalable' -HostNetwork 'Fully-Converged' -Name 'RoCE'

Get-InfrastructureDeploymentTask -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -DeploymentModel 'Scalable' -HostNetwork 'Fully-Converged' -RdmaOption 'RoCE' | Select Name

Get-InfrastructureDeploymentScript -InfrastructureType 'Microsoft Storage Spaces Direct' -UsageModel 'Hyper-Converged Infrastructure' -DeploymentModel 'Scalable' -HostNetwork 'Fully-Converged' -RdmaOption 'RoCE' | Select Name
#endregion

#region REST API

Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/infrastructureType'
Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/usageModel?infrastructureType=Microsoft Storage Spaces Direct'
Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/deploymentModel?infrastructureType=Microsoft Storage Spaces Direct&usageModel=Hyper-Converged Infrastructure'
Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/hostNetworkOption?infrastructureType=Microsoft Storage Spaces Direct&usageModel=Hyper-Converged Infrastructure&deploymentModel=Scalable'
Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/hostNetworkRdmaOption?infrastructureType=Microsoft Storage Spaces Direct&usageModel=Hyper-Converged Infrastructure&deploymentModel=Scalable&hostNetwork=Fully-Converged'
Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/deploymentTask?infrastructureType=Microsoft Storage Spaces Direct&usageModel=Hyper-Converged Infrastructure&deploymentModel=Scalable&hostNetwork=Fully-Converged&rdmaOption=RoCE'
Invoke-RestMethod -UseBasicParsing -Uri 'http://localhost:8080/deploymentScript?infrastructureType=Microsoft Storage Spaces Direct&usageModel=Hyper-Converged Infrastructure&deploymentModel=Scalable&hostNetwork=Fully-Converged&rdmaOption=RoCE'
#endregion

#region UI
Set-Location -Path C:\GitHub\Presentations\psconfAsia2018\BYOA\03_DAaaS\DAaaS-UI
.\server.ps1

Stop-Polaris
#endregion
