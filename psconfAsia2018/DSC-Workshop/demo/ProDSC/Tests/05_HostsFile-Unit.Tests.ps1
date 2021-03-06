﻿#region HEADER
    
# Unit Test Template Version: 1.2.0
$script:moduleRoot = Split-Path -Parent $PSScriptRoot
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
        (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $script:moduleRoot -ChildPath '\DSCResource.Tests\'))
}
    
Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force
    
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName 'ProDsc' `
    -DSCResourceName 'HostsFile' `
    -TestType Unit
    
#endregion HEADER
    
function Invoke-TestCleanup {
    Restore-TestEnvironment -TestEnvironment $TestEnvironment	    
}
    
# Begin Testing
try
{   
    InModuleScope 'HostsFile' {
        Describe 'Unit tests for the HostsFile resource' {
            BeforeEach {
                Mock -CommandName Add-Content
                Mock -CommandName Set-Content
            }

            Context 'A hosts file entry does not exist. It should.' {	
                $testParameters = @{
                    HostName  = 'TestServer102'
                    IPAddress = '172.16.102.102'
                    Verbose   = $true
                }

                Mock -CommandName Get-Content -MockWith {
                    return @(
                        '# An example of a host file',
                        '',
                        '172.16.102.1       Router',
                        '127.0.0.1  localhost',
                        ''
                    )
                }
                
                It 'Get function should return Ensure as absent.' {
                    (Get-TargetResource @testParameters).Ensure | Should Be 'Absent'	
                }
    
                It 'Test function should return false.' {
                    Test-TargetResource @testParameters | Should Be $false
                }
    
                It 'Set function should add the hosts file entry.' {
                    Set-TargetResource @testParameters
                    Assert-MockCalled -CommandName Add-Content -Times 1
                }
            }

            Context 'A hosts file entry exists as it should.' {

                $testParameters = @{
                    HostName  = 'TestServer102'
                    IPAddress = '172.16.102.102'
                    Verbose   = $true
                }

                Mock -CommandName Get-Content -MockWith {
                    return @(
                        '# An example of a host file',
                        '',
                        '127.0.0.1  localhost',
                        "$($testParameters.IPAddress)         $($testParameters.HostName)",
                        ''
                    )
                }

                It 'Get function should return Ensure as present.' {
                    (Get-TargetResource @testParameters).Ensure | Should Be 'Present'
                }

                It 'Test function should return true.' {
                    Test-TargetResource @testParameters | Should Be $true
                }
            }

            Context 'A hosts file entry exists and it should not.' {

                $testParameters = @{
                    HostName  = 'TestServer102'
                    IPAddress = '172.16.102.102'
                    Ensure    = 'Absent'
                    Verbose   = $true
                }

                Mock -CommandName Get-Content -MockWith {
                    return @(
                        '# An example of a host file',
                        '',
                        '127.0.0.1  localhost',
                        "$($testParameters.IPAddress)         $($testParameters.HostName)",
                        ''
                    )
                }

                It 'Get function should return Ensure as present.' {
                    (Get-TargetResource @testParameters).Ensure | Should Be 'Present'	
                }

                It 'Test function should return false.' {
                    Test-TargetResource @testParameters | Should Be $false
                }

                It 'Set function should call Set-Content only once.' {
                    Set-TargetResource @testParameters
                    Assert-MockCalled -CommandName Set-Content -Times 1
                }
            }

            Context 'A hosts file entry does not exist and it should not.' {
        
                $testParameters = @{
                    HostName  = 'TestServer102'
                    IPAddress = '172.16.102.102'
                    Ensure    = 'Absent'
                    Verbose   = $true
                }

                Mock -CommandName Get-Content -MockWith {
                    return @(
                        '# An example of a host file',
                        '',
                        '127.0.0.1  localhost',
                        ''
                    )
                }

                It 'Get function should return Ensure as absent.' {
                    (Get-TargetResource @testParameters).Ensure | Should Be 'Absent'
                }

                It 'Test function should return true.' {
                    Test-TargetResource @testParameters | Should Be $true
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
