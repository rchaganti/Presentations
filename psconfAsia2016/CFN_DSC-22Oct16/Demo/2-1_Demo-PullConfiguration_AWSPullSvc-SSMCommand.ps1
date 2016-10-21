$commandBlock = @'
$config = 'https://s3-us-west-2.amazonaws.com/dscconfig/localhost.meta.mof'

if (-not (Test-Path -Path C:\Temp))
{
    $null = New-Item -Path C:\Temp -ItemType Directory -Force -Verbose
}

Invoke-WebRequest -Uri $config -OutFile C:\temp\localhost.meta.mof -Verbose

if (Test-Path -Path C:\temp\localhost.meta.mof)
{
    Set-DscLocalConfigurationManager -Path C:\Temp -Force -Verbose
    Update-DscConfiguration -Verbose
}
'@

Set-DefaultAwsRegion -Region us-west-2
Send-SSMCommand -instanceId 'i-0b774281e2a6bdbff' `
                -DocumentName AWS-RunPowerShellScript `
                -Comment 'DSC Pull client onboarding using SSM Command' `
                -Parameter @{'commands'=@($commandBlock)} -Verbose

Get-SSMCommand -instanceId 'i-0b774281e2a6bdbff'
Stop-SSMCommand -InstanceId 'i-0b774281e2a6bdbff' -CommandId '9614c445-7260-4f07-9e00-b59f34f96bef'
