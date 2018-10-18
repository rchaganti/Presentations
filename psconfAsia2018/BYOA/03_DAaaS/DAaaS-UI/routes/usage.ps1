#Load the deploymentTaskEngine module
$modulePath = 'C:\GitHub\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1'
Import-Module $modulePath -Force

New-PolarisGetRoute -Path "/usageModel" -Scriptblock {
    $infraType = Get-InfrastructureType
    $Response.SetContentType('text/html')
    $parameters = @{
        InfrastructureType = $request.Query['infrastructureType']
    }
    $usageModel = Get-InfrastructureUsageModel @parameters
    $Html = html {
        head {
            title "Deployment Automation as a Service"
            link -rel "stylesheet" -href "home.css" -type "text/css"
        }
        Body {
            hr {
                "Horizontal Line"
            } -Style "border-width: 2px"
            h1 {
                'Deployment Automation as a Service' 
            } -Style "font-family: 'Candara';text-align:center"
            hr {
                "Horizontal Line"
            } -Style "border-width: 2px"
            form {
                "RequestForm"
            } -action "/deploymentModel" -method 'get' -target '_blank' -style "font-family:Candara" -Content {
                "Usage Model"
                input -type text "usageModel" -style "font-family:Candara" -value $usageModel.name
                "Submit"
                input -type submit "Next" -style "font-family:Candara"
            }
        } 
    }
    $Response.Send($Html)
}
