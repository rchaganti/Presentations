#we verified in the LCMBasics demo that all the configuration runas Local System account
#But, Some resource configuration requires running as a specific user.
#For example, you want to add a domain user account to a local group on a node. Take a look at this configuration

Configuration GroupDemo
{
    param
    (
        [String] $MemberToAdd
    )
    Import-DscResource -moduleName PSDesiredStateConfiguration
    
    Node S12R2-01
    {
        #This creates a group if it does not exist and adds the members
        Group GroupDemo
        {
            GroupName = 'TestAdmin'   
            Members = $MemberToAdd
        }
    }
}

GroupDemo -OutputPath C:\DemoScripts\GroupDemo -MemberToAdd 's2dlab\administrator'

#This enact will fail since LCM runs as SYSTEM and cannot access AD server to query for the domain account
Start-DscConfiguration -Path C:\DemoScripts\GroupDemo -Verbose -Wait -Force

#Using PsDscRunAsCredential, the LCM can be made aware of custom credential for resource execution instead of SYSTEM account
$ConfigData = 
@{
    AllNodes = 
    @(
        @{
            NodeName = "S12R2-01"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

Configuration SYSTEMDemo 
{
    Node $allNodes.NodeName
    {
        Script Demo
        {
            GetScript = {
                return @{}
            }

            SetScript = {
                Write-Verbose -Message "This configuration is running as: $(whoami)"
            }

            TestScript = {
                return $false
            }

            PsDscRunAsCredential = (Get-Credential)
        }
    }
}

SYSTEMDemo -outputPath C:\DemoScripts\SystemDemo -ConfigurationData $ConfigData
Start-DscConfiguration -Path C:\DemoScripts\SystemDemo -ComputerName S12R2-01 -Verbose -Wait

#Let us use PsDscRunAsCredential to make the above config work. This requires either allowing plain-text creds or implementing secure creds
$ConfigData = 
@{
    AllNodes = 
    @(
        #Use NodeName = '*' along with PSDscAllowPlainTextPassword if there are multiple nodes in the configuration data
        #@{
        #    NodeName = "*"
        #    PSDscAllowPlainTextPassword = $true
        #},
        @{
            NodeName = "S12R2-01"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

Configuration GroupDemo
{
    param
    (
        [String] $MemberToAdd,
        [pscredential] $RunasCred
    )
    Import-DscResource -moduleName PSDesiredStateConfiguration
    
    Node S12R2-01
    {
        #This creates a group if it does not exist and adds the members
        Group GroupDemo
        {
            GroupName = 'TestAdmin'   
            Members = $MemberToAdd
            PsDscRunAsCredential = (Get-Credential)
        }
    }
}

#We pass the domain credentials to access the AD server as PsDscRunAsCredential
GroupDemo -OutputPath C:\DemoScripts\GroupDemo -MemberToAdd 'cloud\administrator' -ConfigurationData $ConfigData

#This enact will fail since LCM runs as SYSTEM and cannot access AD server to query for the domain account
Start-DscConfiguration -Path C:\DemoScripts\GroupDemo -Verbose -Wait -Force