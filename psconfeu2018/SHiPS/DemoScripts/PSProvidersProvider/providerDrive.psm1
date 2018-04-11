using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider()]
class ProviderRoot : SHiPSDirectory
{  
    # Default constructor
    ProviderRoot([string]$name):base($name)
    {
    }

    [object[]] GetChildItem()
    {
        $obj = @()
        . "$PSScriptRoot\providerDrive.helper.ps1"
        $psProviders = Get-PSProvider
        foreach ($name in $psProviders.GitHubHandle)
        {
            $obj += [GitHubHandle]::new($name)
        }
        return $obj
    }
}

[SHiPSProvider()]
class GitHubHandle : SHiPSDirectory
{
    [string] $handle
    [string] $Type = 'GitHubHandle'

    GitHubHandle([string]$name):base($name)
    {
        $this.handle = $name
    }

    [object[]] GetChildItem()
    {
        $obj = @()
        . "$PSScriptRoot\providerDrive.helper.ps1"
        $projects = (Get-PSProvider -By $this.handle).Projects.Name
        foreach ($project in $projects)
        {
            $obj += [Project]::new($project, $this.handle)
        }
        $obj += $projects
        return $obj
    }
}

[SHiPSProvider()]
class Project : SHiPSDirectory
{
    [string] $handle
    [string] $Type = 'Project'

    Project([string]$name, [string]$handle):base($name)
    {
        $this.handle = $handle
        $this.Name = $name
    }

    [object[]] GetChildItem()
    {
        return (Get-PSProvider -By $this.handle -Project $this.name)
    }
}
