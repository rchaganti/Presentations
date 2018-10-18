Set-Location -Path C:\GitHub\Presentations\psconfAsia2018\DSC-Workshop\demo

#Pester 101 - First Test Script ...
Invoke-Pester -Script .\01_Get-HelloWorld.Tests.ps1 -Verbose

#Pester 101 - A bit more involved ...
Invoke-Pester -Script .\02_Get-HelloWorld.Tests.ps1 -Verbose

#Pester 101 - Mocks
Invoke-Pester -Script .\03_Restart-InactiveComputer.Tests.ps1 -Verbose

#Pester 101 - Mock Assertions
Invoke-Pester -Script .\04_Restart-InactiveComputer.Tests.ps1 -Verbose

#DSC Resource - Unit Tests
Set-Location .\demo
Invoke-Pester -Script .\ProDSC\Tests\05_HostsFile-Unit.Tests.ps1 -Verbose

#DSC Resource - Integration Tests
Invoke-Pester -Script .\ProDSC\Tests\06_HostsFile-Integration.Tests.ps1 -Verbose

#DSC Resource - Operations Validation
Invoke-Pester -Script .\ProDSC\Tests\07_HostsFile-Operations.Tests.ps1 -Verbose