Configuration HostsFile_Config
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost'
    )

    Import-DSCResource -ModuleName ProDsc -ModuleVersion 1.0.0.0

    Node $NodeName
    {
        HostsFile HostEntry
        {
            HostName  = 'googleDNS'
            IPAddress = '8.8.8.8'
            Ensure    = 'Present'
        }
    }
}
