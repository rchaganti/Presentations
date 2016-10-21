[CmdletBinding()]
param (
    [String] $ComputerName='54.214.220.252',
    [pscredential] $Credential,
    [String] $ConfigurationPath,
    [Switch] $GetConfiguration,
    [Switch] $RemoveConfiguration
)

try
{
    Write-Verbose 'Creating a new CIM Session ...'
    $cimSession = New-CimSession -ComputerName $ComputerName -Credential $Credential -Verbose
}
catch

{
    throw 'Failed to create a CIM session.'
}

if ($GetConfiguration)
{
    #Verify if there is an existing configuration
    Write-Verbose 'Getting existing configuration from the AWS EC2 instance ...'
    Get-DscConfiguration -CimSession $cimSession
}
elseif ($RemoveConfiguration)
{
    Write-Verbose 'Removing existing current configuration from the AWS EC2 instance ...'
    Remove-DscConfigurationDocument -Stage Current -CimSession $cimSession -Force
}
elseif ($ConfigurationPath)
{
    try
    {
        #Rename the MOF to include $ComputerName
        Write-Verbose 'Pushing configuration to the AWS EC2 instance ...'
        Copy-Item -Path "${ConfigurationPath}\localhost.mof" -Destination "${ConfigurationPath}\${ComputerName}.mof" -Force

        Start-DscConfiguration -CimSession $cimSession -Path $ConfigurationPath -Wait -Verbose -Force
    }
    catch
    {
        throw 'Failed to push the configuration.'
    }
}