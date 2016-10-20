function Get-ConfigurationDataAsObject
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
        [hashtable] $ConfigurationData    
    )
    return $ConfigurationData
}

$ConfigurationData = Get-ConfigurationDataAsObject -ConfigurationDat C:\Demo\NodeData.psd1

Describe "Simple Operations tests for Hyper-V Deployment and network Configuration" {
    Context 'Hyper-V module related tests' {
        It "Hyper-V Module is available" {
            Get-Module -Name Hyper-V -ListAvailable | should not BeNullOrEmpty
        }

        It "Hyper-V Module can be loaded" {
            Import-Module -Name Hyper-V -Global -PassThru -Force | should not BeNullOrEmpty
        }
    }

    AfterAll {
        remove-Module Hyper-V
    }
}