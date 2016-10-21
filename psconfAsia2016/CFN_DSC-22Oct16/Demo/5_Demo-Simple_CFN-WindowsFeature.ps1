#Get CFN cmdlets
Get-Command -Noun *cfn*

#Set Default AWS region
Set-DefaultAwsRegion -Region us-west-2

#Get existing CFN stack
Get-CfnStack

#Validate a CFN template
$templateBody = Get-Content -Path C:\Documents\Github\Presentations\psconfAsia2016\CFN_DSC-22Oct16\Demo\Simple-EC2_CFN-WindowsFeature.template -raw
Test-CFNTemplate -TemplateBody $templateBody

#Deploy a CFN template
$parameters = @( 
    @{
        ParameterKey="KeyName"
        ParameterValue="DSCInstance"
    },
    @{
        ParameterKey="InstanceType"
        ParameterValue="t1.micro"
    },
    @{
        ParameterKey="Roles"
        ParameterValue="Web-Server"
    },
    @{
        ParameterKey="SourceCidrForRDP"
        ParameterValue="0.0.0.0/0"
    },
    @{
        ParameterKey="SourceCidrForHTTP"
        ParameterValue="0.0.0.0/0"
    }
)
New-CfnStack -StackName SecondCfnStack -TemplateBody $templateBody -Parameter $parameters -Verbose