#Set Default AWS region
Set-DefaultAwsRegion -Region us-west-2

#Validate a CFN template
$templateBody = Get-Content -Path C:\Documents\Github\Presentations\psconfAsia2016\CFN_DSC-22Oct16\Demo\EC2_CFN-DSCBootstrap.template -Raw
Test-CFNTemplate -TemplateBody $templateBody

#Deploy a CFN template
$parameters = @( 
    @{
        ParameterKey="BootstrapperScript"
        ParameterValue="https://github.com/rchaganti/Presentations/raw/master/psconfAsia2016/CFN_DSC-22Oct16/Demo/WebServerDSCBootstrap.zip"
    },
    @{
        ParameterKey="KeyPairName"
        ParameterValue="DSCInstance"
    },
    @{
        ParameterKey="WebserverImageId"
        ParameterValue="ami-9f5efbff"
    },
    @{
        ParameterKey="WebserverInstanceType"
        ParameterValue="t2.micro"
    }
)
New-CfnStack -StackName DSCWebServerBootstrap -TemplateBody $templateBody -Parameter $parameters -Verbose