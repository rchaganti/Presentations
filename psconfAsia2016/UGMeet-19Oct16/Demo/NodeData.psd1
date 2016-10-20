@{
    AllNodes = @(
        @{
            NodeName='localhost'
            ManagementIPAddress = '172.16.101.201'
            LiveMigrationIPAddress = '172.16.102.201'
            ClusterIPAddress = '172.16.103.201'
        },
        @{
            NodeName = '*'
            ClusterAdapterName = 'Cluster'
            LiveMigrationAdapterName = 'LiveMigration'
            SETName='SETSwitch'
            SETNetAdapters = 'SLOT 3','SLOT 3 2'
            ManagementSubnetMask = 24
            ClusterSubnetMask = 24
            LiveMigrationSubnetMask = 24
            ManagementGateway = '172.16.101.1'
            ManagementDnsServer = '172.16.101.2'
            ManagementVlanID = 101
            ClusterAdapterVlanID = 103
            LiveMigrationAdapterVlanID = 102
        }   
    )
}