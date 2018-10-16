function Test-TargetResource
{
	[OutputType([Boolean])]
	param (
	    [Parameter(Mandatory = $true)]
	    [String]
	    $HostName,
	
	    [Parameter(Mandatory = $true)]
	    [String]
	    $IPAddress,
	        
	    [Parameter()]
	    [ValidateSet('Present','Absent')]
	    [String]
	    $Ensure = 'Present'
	)  

	Write-Verbose -Message "Checking if the hosts file entry for $HostName and $IPAddress exists or not."
	$content = Get-Content "${env:windir}\system32\drivers\etc\hosts" -ErrorAction SilentlyContinue
	$entryExist = ($content -match "^\s*$IPAddress\s+$HostName\s*$")
	
	if ($Ensure -eq 'Present')
	{
	    if ($entryExist)
		{
	        Write-Verbose -Message "Hosts file entry for $HostName and $IPAddress exists for the given parameters; nothing to configure."
	        return $true
	    }
	    else
	    {
	        Write-Verbose -Message "Hosts file entry  for $HostName and $IPAddress does not exist while it should; it must be added."
	        return $false
	    }
	}
	else
	{
	    if ($entryExist)
	    {
	        Write-Verbose -Message "Hosts file entry for $HostName and $IPAddress exists while it should not; it must be removed."
	        return $false
	    }
	    else
	    {
	        Write-Verbose -Message "Hosts file entry for $HostName and $IPAddress does not exist; nothing to configure."
	        return $true
	    }
	}
}

function Set-TargetResource
{
	param
	(
	    [Parameter(Mandatory = $true)]
	    [String]
	    $HostName,
	
	    [Parameter(Mandatory = $true)]
	    [String]
	    $IPAddress,
	
	    [Parameter()]
	    [ValidateSet('Present','Absent')]
	    [String]
	    $Ensure = 'Present'
	)     
	
	$hostEntry = "`n${ipAddress}`t${hostName}"
	
	if ($Ensure -eq 'Present')
	{
	    Write-Verbose -Message "Creating hosts file entry for $HostName and $IPAddress."
	    Add-Content -Path "$env:windir\system32\drivers\etc\hosts" -Value $hostEntry -Force -Encoding ASCII
	}
	else
	{
	    Write-Verbose -Message "Removing hosts file entry for $HostName and $IPAddress."
	    $content = ((Get-Content "$env:windir\system32\drivers\etc\hosts") -notmatch "^\s*$")
		$noMatchContent = ($content -notmatch "^\s*$IPAddress\s+$HostName\s*$")
		$noMatchContent | Set-Content "$env:windir\system32\drivers\etc\hosts"
	}
}

function Get-TargetResource
{
	[OutputType([Hashtable])]
	param
	(
	    [parameter(Mandatory = $true)]
	    [string]
	    $HostName,
	
	    [parameter(Mandatory = $true)]
	    [string]
	    $IPAddress,

	    [parameter()]
        [ValidateSet('Present','Absent')]
	    [string]
	    $Ensure = 'Present'
	)
	    
	$configuration = @{
	    HostName = $hostName
	    IPAddress = $IPAddress
	}
	
	Write-Verbose -Message "Checking if hosts file entry exists for $HostName and $IPAddress or not."
	if ((Get-Content "$env:windir\system32\drivers\etc\hosts" -ErrorAction SilentlyContinue) -match "^\s*$IPAddress\s+$HostName\s*$")
	{
	    Write-Verbose -Message "Hosts file entry for $HostName and $IPAddress exists."
	    $configuration.Add('Ensure','Present')
	}
	else
	{
	    Write-Verbose "Hosts file entry for $HostName and $IPAddress does not exist."
	    $configuration.Add('Ensure','Absent')
	}
	    
	return $configuration
}

Export-ModuleMember -Function *-TargetResource