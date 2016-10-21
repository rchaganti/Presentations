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

$userdata = "<powershell>$commandBlock</powershell>"
$EncodeUserData = [System.Text.Encoding]::UTF8.GetBytes($userdata)
$encuserData = [System.Convert]::ToBase64String($EncodeUserData)

Set-DefaultAWSRegion -Region us-west-2
New-EC2Instance -ImageId ami-9f5efbff -MinCount 1 -MaxCount 1 -InstanceType t2.micro -KeyName DSCInstance -SecurityGroup 'launch-wizard-6' -userdata $encuserData