Configuration WebServerDemo
{
    WindowsFeature WebServer
    {
        Name = 'Web-Server'
        IncludeAllSubFeature = $true
        Ensure = 'Present'
    }
}

WebServerDemo -OutputPath ${env:TEMP}
Start-DscConfiguration -Path "${env:TEMP}\WebServerDemo" -Force -Wait -Verbose