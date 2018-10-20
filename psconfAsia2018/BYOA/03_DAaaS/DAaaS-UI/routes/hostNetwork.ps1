#Load the deploymentTaskEngine module
$modulePath = 'C:\GitHub\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1'
Import-Module $modulePath -Force

New-PolarisPostRoute -Path "/hostNetwork" -Scriptblock {
    $Response.SetContentType('text/html')
    $body = [System.Web.HttpUtility]::UrlDecode($Request.BodyString)
    $data = @{}
    $body.split('&') | foreach-object {
        $part = $_.split('=')
        $data.add($part[0], $part[1])
    }
    $Response.Send(($data|ConvertTo-Json))

    $hostNetwork = Get-InfrastructureHostNetworkOption -infrastructureType $data.infrastructureType -UsageModel $data.usageModel -DeploymentModel $data.deploymentModel
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
                "Select the host network configuration type"
            }
            form {
                "usageModel"
            } -action "/rdmaOption" -method 'post' -target '_self' -style "font-family:Candara" -Content {
                foreach ($hNetwork in $hostNetwork.Name)
                {
                    input -type radio "hostNetwork" -style "font-family:Candara" -value $hNetwork
                    $hNetwork
                    br {}
                }
                br {}
                input -type hidden "infrastructureType" -value $data.infrastructureType
                input -type hidden "usageModel" -value $data.usageModel
                input -type hidden "deploymentModel" -value $data.deploymentModel
                input -type submit "Next" -style "background-color: #4CAF50;border: none;color: white;padding: 16px 32px;text-decoration: none;margin: 4px 2px;cursor: pointer;"
            }
        } -Style "background: #99d6ff;"
    }
    $Response.Send($Html)
}
