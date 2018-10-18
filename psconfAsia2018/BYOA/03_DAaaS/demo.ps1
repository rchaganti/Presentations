ipmo C:\Github\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1 -Force

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



