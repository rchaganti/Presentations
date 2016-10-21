$thumbprint = (New-SelfSignedCertificate -Subject "Demo3PullServer").Thumbprint
$registrationkey = [guid]::NewGuid()

#region =================================== Section DSC Server =================================== #
configuration Sample_xDscWebServiceRegistrationWithEnhancedSecurity
{
    param 
    (
        [string[]]$NodeName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [string] $certificateThumbPrint,

        [Parameter(HelpMessage='This should be a string with enough entropy (randomness) to protect the registration of clients to the pull server.  We will use new GUID by default.')]
        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey
    )
    
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"            
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCPullServer"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint   = $certificateThumbPrint         
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"            
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature" 
            RegistrationKeyPath     = "$env:PROGRAMFILES\WindowsPowerShell\DscService"   
            AcceptSelfSignedCertificates = $true
            UseUpToDateSecuritySettings = $true
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
        }
    }
}
Sample_xDscWebServiceRegistrationWithEnhancedSecurity -RegistrationKey $registrationkey -certificateThumbPrint $thumbprint
#endregion =================================== Section Pull Server =================================== #

#region =================================== Section DSC Client =================================== #
[DSCLocalConfigurationManager()]
configuration Sample_MetaConfigurationToRegisterWithSecurePullServer
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [string] $NodeName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey = '887179f0-5c23-4ed1-af1a-617407378079', #same as the one used to setup pull server in previous configuration

        [ValidateNotNullOrEmpty()]
        [string] $ServerName = 'ec2-54-149-167-54.us-west-2.compute.amazonaws.com' #node name of the pull server, same as $NodeName used in previous configuration
    )

    Node $NodeName
    {
        Settings
        {
            RefreshMode        = 'Pull'
        }

        ConfigurationRepositoryWeb AWS-PullSrv
        {
            ServerURL          = "https://$ServerName`:8080/PSDSCPullServer.svc" # notice it is https
            RegistrationKey    = $RegistrationKey
            ConfigurationNames = @('webserver')
        }   

        ReportServerWeb AWS-PullSrv
        {
            ServerURL       = "https://$ServerName`:8080/PSDSCPullServer.svc" # notice it is https
            RegistrationKey = $RegistrationKey
        }
    }
}

Sample_MetaConfigurationToRegisterWithSecurePullServer -RegistrationKey $registrationkey
#endregion =================================== Section DSC Client =================================== #

#region =================================== Section Web Server Configuration =================================== #
configuration DemoWebServer
{
    WindowsFeature WebServer
    {
        Name = 'Web-Server'
        Ensure = 'Present'
    }      
}

#Compile the configuration
DemoWebServer -OutputPath "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\webserver.mof"
New-DscChecksum -Path "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\webserver.mof" -OutPath "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\webserver.checksum.mof" 
#endregion =================================== Section Web Server Configuration =================================== #
