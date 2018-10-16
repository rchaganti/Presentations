$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"
 
Describe "Restart-InactiveComputer" {
    Mock Restart-Computer { "Restarting!" }
    It "Restarts the computer" {
        Mock Get-Process {}
        Restart-InactiveComputer | Out-Null
        Assert-MockCalled Restart-Computer -Exactly 1
    }
 
    It "Does not restart the computer if user is logged on" {
        Mock Get-Process { $true }
        Restart-InactiveComputer | Out-Null
        Assert-MockCalled Restart-Computer -Exactly 0
    }
}
