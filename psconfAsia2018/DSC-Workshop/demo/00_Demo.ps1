Set-Location -Path C:\Documents\GitHub\Presentations\psconfAsia2018\DSC-Workshop\demo

#Pester 101 - First Test Script ...
psEdit .\01_Get-HelloWorld.Tests.ps1
Invoke-Pester -Script .\01_Get-HelloWorld.Tests.ps1 -Verbose

#Pester 101 - A bit more involved ...
psEdit .\02_Get-HelloWorld.Tests.ps1
Invoke-Pester -Script .\02_Get-HelloWorld.Tests.ps1 -Verbose

#Pester 101 - Mocks
psEdit .\03_Restart-InactiveComputer.Tests.ps1
Invoke-Pester -Script .\03_Restart-InactiveComputer.Tests.ps1 -Verbose

#Pester 101 - Mock Assertions
psEdit .\04_Restart-InactiveComputer.Tests.ps1
Invoke-Pester -Script .\04_Restart-InactiveComputer.Tests.ps1 -Verbose

#DSC Resource - Unit Tests
psEdit .\ProDSC\Tests\05_HostsFile-Unit.Tests.ps1
Invoke-Pester -Script .\ProDSC\Tests\05_HostsFile-Unit.Tests.ps1 -Verbose

#DSC Resource - Integration Tests
psEdit .\ProDSC\Tests\05_HostsFile-Integration.Tests.ps1
Invoke-Pester -Script .\ProDSC\Tests\06_HostsFile-Integration.Tests.ps1 -Verbose

#DSC Resource - Operations Validation
psEdit .\ProDSC\Tests\06_HostsFile-Operations.Tests.ps1
Invoke-Pester -Script .\ProDSC\Tests\06_HostsFile-Integration.Tests.ps1 -Verbose