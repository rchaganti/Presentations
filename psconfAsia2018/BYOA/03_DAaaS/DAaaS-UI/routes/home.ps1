#Load the deploymentTaskEngine module
$modulePath = 'C:\Documents\GitHub\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1'
Import-Module $modulePath -Force

New-PolarisGetRoute -Path "/home" -Scriptblock {
    $infraType = Get-InfrastructureType
    $Response.SetContentType('text/html')
    $Html = html {
        head {
            title "Deployment Automation as a Service"
        }
        Body {
            h1 {
                'Deployment Automation as a Service' 
            } -Style "font-family: 'Candara';text-align:center"
            hr {
                "Horizontal Line"
            } -Style "border-width: 1px"
            h3 {
                "Select the infrastructure type"
            }
            form {
                "InfrastructureType"
            } -action "/usageModel" -method 'post' -target '_self' -style "font-family:Candara" -Content {
                foreach ($type in $infraType.Name)
                {
                    input -name 'infrastructureType' -type radio -value $type -Style "font-family:Candara"
                    $type
                    br {}
                }
                br {}
                input -type submit "Next" -style "background-color: #4CAF50;border: none;color: white;padding: 16px 32px;text-decoration: none;margin: 4px 2px;cursor: pointer;"
            }
        } -Style "background: #99d6ff;"
    }
    $Response.Send($Html)
}

