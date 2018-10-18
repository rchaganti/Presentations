$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"
 
Describe "Get-HelloWorld" {
    Context "string tests" {
        It "outputs 'Hello world!'" {
            Get-HelloWorld | Should Be 'Hello world!'
        }
    }

    Context "string tests" {
        $testnow = $true
        It "outputs 'Hello world!'" {
            Get-HelloWorld | Should Be 'Hello world!'
        }
    }
}