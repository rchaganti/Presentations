Register-EditorCommand `
    -Name "PSDSC.ShowResourceConfigurationDependency" `
    -DisplayName "Generate PowerShell DSC Configuration Dependency Graph" `
    -ScriptBlock {
        param([Microsoft.PowerShell.EditorServices.Extensions.EditorContext]$context)
        Get-DscConfigurationDependencyGraph -ScriptAST $context.CurrentFile.Ast -Verbose
    }
