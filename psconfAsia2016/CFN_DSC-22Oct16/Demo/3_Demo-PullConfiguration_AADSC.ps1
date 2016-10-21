[CmdletBinding()]
param (
    [string] $EC2InstanceID='i-0234180ac91c96a55',    
    [string] $RootKeyFile='C:\Documents\Personal\Presentations\PSConf-Asia-2016\Support\rootkey.csv',    
    [string] $ConfigurationName = 'PSConfWebServer.localhost',    
    [string] $AutomationAccountName='psconfaa',
    [pscredential] $AzureCredential,    
    [string] $AwsRegion = 'us-west-2',
    [switch] $Force
)

try
{
    Write-Verbose 'Checking if AWSToolkit module ...'
    if (Get-Module -Name AwsDscToolkit -ListAvailable)
    {
        Write-Verbose 'AwsDscToolkit is installed ...'
    }
    else
    {
        Write-Verbose 'Installing AwsDscToolkit ...'
        Install-Module -Name AwsDscToolkit -Force
    }
}
catch
{
    throw 'Failed to create a CIM session.'
}

try 
{
    Write-Verbose 'Logging into Azure subscription ...'
    Add-AzureRmAccount -Credential $AzureCredential
}
catch 
{
    throw 'Error logging into Azure ...'
}

try
{
    if (Test-Path -Path $RootKeyFile)
    {
        $awsKey = Import-Csv -Path $RootKeyFile
        Write-Verbose 'Setting AWS credential ...'
        Set-AWSCredentials -AccessKey $awsKey.AWSAccessKeyId -SecretKey $awsKey.AWSSecretKey -StoreAs 'default'
        
        Write-Verbose 'Setting AWS default region ...'
        Set-DefaultAWSRegion $AwsRegion
    }
    else
    {
        throw "$RootKeyFile does not exist"
    }
}

catch
{
    throw 'Error setting AWS credentials'
}

try
{
    Write-Verbose 'Testing if EC2 instance is ready to register ...'
    $status = Test-EC2InstanceRegistration -InstanceId $EC2InstanceID -AwsRegion $AwsRegion -AzureAutomationAccount $AutomationAccountName -verbose
    if ($status -eq 'ReadyToRegister')
    {
        Write-Verbose 'EC2 instance is ready to register. Staring the bootstrap ...'
        Register-EC2Instance -AzureAutomationAccount $AutomationAccountName -InstanceId $EC2InstanceID -NodeConfigurationName $ConfigurationName -Force:$Force -verbose
    }
    elseif ($status -eq 'Registered')
    {
        Write-Verbose 'EC2 instance is already registered'
        Register-EC2Instance -AzureAutomationAccount $AutomationAccountName -InstanceId $EC2InstanceID -NodeConfigurationName $ConfigurationName -Force:$Force -verbose
    }
}

catch
{
    Throw $_
}