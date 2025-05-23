﻿#Load the deploymentTaskEngine module
$modulePath = 'C:\Documents\GitHub\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1'
Import-Module $modulePath -Force

New-PolarisPostRoute -Path "/usageModel" -Scriptblock {
    $Response.SetContentType('text/html')
    $body = [System.Web.HttpUtility]::UrlDecode($Request.BodyString)
    $data = @{}
    $body.split('&') | foreach-object {
        $part = $_.split('=')
        $data.add($part[0], $part[1])
    }

    $usageModel = Get-InfrastructureUsageModel -infrastructureType $data.infrastructureType
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
                "Select the usage model"
            }
            form {
                "usageModel"
            } -action "/deploymentModel" -method 'post' -target '_self' -style "font-family:Candara" -Content {
                foreach ($uModel in $usageModel.Name)
                {
                    input -type radio "usageModel" -style "font-family:Candara" -value $uModel
                    $uModel
                    br {}
                }
                br {}
                input -type hidden "infrastructureType" -value $data.infrastructureType
                input -type submit "Next" -style "background-color: #4CAF50;border: none;color: white;padding: 16px 32px;text-decoration: none;margin: 4px 2px;cursor: pointer;"
            }
        } -Style "background: #99d6ff;" 
    }
    $Response.Send($Html)
}
