Describe "Get-Item" {
   
   Context "no argument is provided" {
      It "fails" {
         { Get-Item -Path '' } | Should Throw
      }
   }
   
   Context "path is provided" {
      It "returns the correct item" {
         ( Get-Item -Path C:\Windows ).FullName | Should Be 'C:\Windows'
      }
      It "works when Path parameter is specified by position" {
         { Get-Item C:\ } | Should Not Throw
      }
   }
}
