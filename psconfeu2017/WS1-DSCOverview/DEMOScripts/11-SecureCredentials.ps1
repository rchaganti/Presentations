#Secure Credentials require certificates
#We will use self-signed certs for this dmeo
#Goto S16-01 and run these commands
$cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName 'S16-01.cloud.lab' -HashAlgorithm SHA256
# export the public key certificate
$cert | Export-Certificate -FilePath "C:\DemoScripts\DscPublicKey.cer" -Force

#Copy the cert to this authoring station and generate the config data
#Thumbprint is from the target node
#Get it using Get-ChildItem Cert:\LocalMachine\My
$ConfigData= @{ 
    AllNodes = @(     
        @{  
            # The name of the node we are describing 
            NodeName = "S16-01" 

            # The path to the .cer file containing the 
            # public key of the Encryption Certificate 
            # used to encrypt credentials for this node 
            CertificateFile = "C:\DemoScripts\DscPublicKey.cer" 


            # The thumbprint of the Encryption Certificate 
            # used to decrypt the credentials on target node 
            Thumbprint = "20BAC25353DE4C94C39006F85E0B25BC19D26AFF" 
        }; 
    )    
}

Configuration UserDemo
{
    param (
        [pscredential] $Credential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $AllNodes.NodeName
    {
        User UserDemo
        {
            UserName = $Credential.UserName
            Password = $Credential
            Description = "local account"
            Ensure = "Present"
            Disabled = $false
            PasswordNeverExpires = $true
            PasswordChangeRequired = $false
        }

        LocalConfigurationManager 
        { 
             CertificateId = $node.Thumbprint 
        }
    }
}

#Compiling this configuration will fail since storing plain-text passwords in MOF is not allowed.
UserDemo -OutputPath C:\DemoScripts\UserDemo -Credential (Get-Credential) -ConfigurationData $ConfigData

#enact meta config first to ensure that the LCM is aware of the certificate to decrypt
Set-DscLocalConfigurationManager -Path C:\DemoScripts\UserDemo -ComputerName S16-01

#Check the MOF before enacting it. The password should be encrypted
psEdit C:\DemoScripts\UserDemo\S16-01.MOF

#enact resource configuration
Start-DscConfiguration -Path C:\DemoScripts\UserDemo -ComputerName S16-01 -Verbose -Wait -Force
