$configData = 
@{
    AllNodes = 
    @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
        }
    )
}

Configuration VmDscCompleteDemo
{
    param (
        [pscredential] $VmCredential
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName HyperVDsc
    Import-DscResource -ModuleName xHyper-V

    xVHD VMVHD
    {
        Name = 'TestVM-VHD.vhdx'
        Path = 'D:\VHD'
        ParentPath = 'D:\VHD\Template.vhdx'
        Generation = 'Vhdx'
        Ensure = 'Present'
    }

    SimpleVM TESTVM
    {
        VMName = 'TestVM'
        CpuCount = 2
        StartupMemory = 2048MB
        VhdPath = 'D:\VHD\TestVM-VHD.vhdx'
        RemoveDefaultNetworkAdapter = $true
        State = 'Running'
        Ensure = 'Present'
        DependsOn = '[xVHD]VMVHD'
    }

    VMNetworkAdapter TESTVMNet
    {
        Id = 'TestVM-Net'
        Name = 'TestVM-Net'
        SwitchName = 'LabMgmt'
        VMName = 'TestVM'
        Ensure = 'Present'
        DependsOn = '[SimpleVM]TESTVM'
    }

    VMNetworkAdapterVlan TestVMNetVLAN
    {
        Id = 'TestVM-Net'
        Name = 'TestVM-Net'
        VMName = 'TestVM'
        AdapterMode =  'Access'
        VlanId = 101
        DependsOn = '[VMNetworkAdapter]TESTVMNet'
    }

    VMIPAddress TestVMNetIP
    {
        Id = 'TestVM-Net'
        NetAdapterName = 'TestVM-Net'
        VMName = 'TestVM'
        IPAddress = '172.16.101.201'
        Subnet = '255.255.255.0'
        DefaultGateway = '172.16.101.1'
        DnsServer = '172.16.101.2'
        DependsOn = '[VMNetworkAdapterVlan]TestVMNetVLAN','[VMNetworkAdapter]TESTVMNet'
    }

    VMDscConfigurationPublish DomainjoinConfig 
    {
        VMName = 'TestVM'
        VMCredential = $VmCredential
        ConfigurationMof = 'C:\VMDomainJoin\localhost.mof'
        ModuleZip = 'C:\Scripts\xComputerManagement.zip'
        DependsOn = '[VMIPAddress]TestVMNetIP','[SimpleVM]TESTVM'
    }

    VMDscConfigurationEnact DomainJoinEnact
    {
        VMName = 'TestVM'
        VMCredential = $VmCredential
        DependsOn = '[VMDscConfigurationPublish]DomainjoinConfig'
    }
}

VmDscCompleteDemo -ConfigurationData $configData -VmCredential (Get-Credential)