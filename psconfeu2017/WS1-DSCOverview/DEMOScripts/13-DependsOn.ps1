﻿#The DependsOn automatic parameter in the resource configuration can be used to create dependencies and ensure the prerequisite configuration is complete
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

#DependsOn is not required if the resource instances are in a proper sequence. However, DependsOn is neededif you want a dependent resource configuration proceed only if the prerequisite configuration is successful.
#With DependsOn specified, the sequence of resource instance configuration definitions in the document does not matetr.
Configuration DependsDemo
{
    param (
        [pscredential] $Credential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node $AllNodes.NodeName
    {
        group groupDemo
        {
            GroupName = 'TestGroup'
            Members = $Credential.UserName
            DependsOn = '[User]UserDemo'
        }
                
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
    }
}

#Compile Configuration
DependsDemo -OutputPath C:\DemoScripts\DependsDemo -ConfigurationData $ConfigData -Credential (Get-Credential)

#Enact Configuration
Start-DscConfiguration -Path C:\DemoScripts\DependsDemo -ComputerName S16-01 -Verbose -Wait