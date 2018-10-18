$script:DSCModuleName      = 'ProDsc'
$script:DSCResourceName    = 'HostsFile'
    
#region HEADER
# Integration Test Template Version: 1.1.1
[String] $script:moduleRoot = Split-Path -Parent $PSScriptRoot
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
        (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $script:moduleRoot -ChildPath '\DSCResource.Tests\'))
}
    
Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCResourceName `
    -TestType Integration
    
#endregion
    
# Using try/finally to always cleanup.
try
{
    #region Integration Tests
    $configFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:DSCResourceName).config.ps1"
    . $configFile
    
    Describe "$($script:DSCResourceName)_Operations" {
        It 'Should be able to resolve the hostname' {
            { Resolve-DnsName -Name googleDns } | Should not throw
        }
    
        It 'Should be able to reach the newly added host entry' {
            Test-Connection -ComputerName googleDns -Quiet -Count 2 | Should Be $true
        }
    }
    #endregion
    
}
finally
{
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
}
