Configuration ConvergedSwitch {
    param (
    )
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName cHyper-V -Name cVMSwitch, cVMNetworkAdapterVlan, cVMNetworkAdapter, cVMNetworkAdapterSettings
    Import-DscResource -ModuleName xNetworking

    Node $AllNodes.NodeName {  
        WindowsFeature HyperV {
            Name = 'Hyper-V'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }

        WindowsFeature HyperVMgmt {
            Name = 'RSAT-Hyper-V-Tools'
            Ensure = 'Present'
            IncludeAllSubFeature = $true
        }
    
        cVMSwitch SET {
            Name = $Node.SETName
            NetAdapterName = $Node.SETNetAdapters
            AllowManagementOS = $true
            Type = 'External'
            MinimumBandwidthMode = 'Weight'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]HyperV'
        }

        cVMNetworkAdapterVlan SETVLAN {
            Id = 'Mgmt-NIC'
            Name = $Node.SETName
            VMName = 'ManagementOS'
            AdapterMode = 'Access'
            VlanId = $Node.ManagementVlanID
            DependsOn = "[cVMSwitch]SET"
        }

        cVMNetworkAdapterSettings SETSettings {
            Id = 'Mgmt-NIC'
            Name = $Node.SETName
            SwitchName = $Node.SETName
            VMName = 'ManagementOS'
            MinimumBandwidthWeight = 30
        }

        xIPAddress SETIPAddress {
            InterfaceAlias = "vEthernet ($($Node.SETName))"
            IPAddress = $Node.ManagementIPAddress
            SubnetMask = $Node.ManagementSubnetMask
            AddressFamily = 'IPV4'
            DependsOn = '[cVMNetworkAdapterVlan]SETVLAN'
        }

        xDefaultGatewayAddress SETGateway {
            InterfaceAlias = "vEthernet ($($Node.SETName))"
            AddressFamily = 'IPV4'
            Address = $Node.ManagementGateway
            DependsOn = '[xIPAddress]SETIPAddress'
        }

        xDNSServerAddress SETDns {
            InterfaceAlias = "vEthernet ($($Node.SETName))"
            AddressFamily = 'IPv4'
            Address =  $Node.ManagementDnsServer
            DependsOn = '[xIPAddress]SETIPAddress'
        }

        cVMNetworkAdapter SETCluster {
            Id = 'Cluster-NIC'
            Name = $Node.ClusterAdapterName
            SwitchName = $Node.SETName
            VMName = 'ManagementOS'
            Ensure = 'Present'
            DependsOn = '[cVMSwitch]SET'
        }

        cVMNetworkAdapterVlan SETClusterVlan {
            Id = 'Cluster-NIC'
            Name = $Node.ClusterAdapterName
            AdapterMode = 'Access'
            VMName = 'ManagementOS'
            VlanId = $Node.ClusterAdapterVlanID
            DependsOn = '[cVMNetworkAdapter]SETCluster'
        }

        xIPAddress SETClusterIPAddress {
            InterfaceAlias = "vEthernet ($($Node.ClusterAdapterName))"
            IPAddress = $Node.ClusterIPAddress
            SubnetMask = $Node.ClusterSubnetMask
            AddressFamily = 'IPV4'
            DependsOn = '[cVMNetworkAdapterVlan]SETClusterVlan'
        }

        cVMNetworkAdapter SETLM {
            Id = 'LM-NIC'
            Name = $Node.LiveMigrationAdapterName
            SwitchName = $Node.SETName
            VMName = 'ManagementOS'
            Ensure = 'Present'
            DependsOn = '[cVMSwitch]SET'
        }

        cVMNetworkAdapterVlan SETLMVlan {
            Id = 'LM-NIC'
            Name = $Node.LiveMigrationAdapterName
            AdapterMode = 'Access'
            VMName = 'ManagementOS'
            VlanId = $Node.LiveMigrationAdapterVlanID
            DependsOn = '[cVMNetworkAdapter]SETLM'
        }

        xIPAddress SETLMIPAddress {
            InterfaceAlias = "vEthernet ($($Node.LiveMigrationAdapterName))"
            IPAddress = $Node.LiveMigrationIPAddress
            SubnetMask = $Node.LiveMigrationSubnetMask
            AddressFamily = 'IPV4'
            DependsOn = '[cVMNetworkAdapterVlan]SETLMVlan'
        }
    }
}

ConvergedSwitch -ConfigurationData .\nodedata.psd1