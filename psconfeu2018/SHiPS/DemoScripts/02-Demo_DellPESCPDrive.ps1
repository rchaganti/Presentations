$credential = Get-Credential

$testHash = @{
    Path =  'D:\Github\DellPESCPDrive\Tests\DellPESCPDrive.Sample2.Tests.ps1'
    Parameters = @{
        referenceSystemDRAC  = '172.16.100.23'
        DRACCredential       = $credential
        differenceSystemDRAC = @('172.16.100.24')
    }
}

Invoke-Pester -Script $testHash -OutputFormat NUnitXml -OutputFile D:\Tools\TestResult-CompareSystem.xml