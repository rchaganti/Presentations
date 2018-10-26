#Load the deploymentTaskEngine module
$modulePath = 'C:\Documents\GitHub\DeploymentAutomationAsAService\modules\deploymentTaskEngine\deploymentTaskEngine.psm1'
Import-Module $modulePath -Force

New-PolarisPostRoute -Path "/deploymentTask" -Scriptblock {
    $Response.SetContentType('text/html')
    $body = [System.Web.HttpUtility]::UrlDecode($Request.BodyString)
    $data = @{}
    $body.split('&') | foreach-object {
        $part = $_.split('=')
        $data.add($part[0], $part[1])
    }

    $dScript = Get-InfrastructureDeploymentScript -infrastructureType $data.infrastructureType -UsageModel $data.usageModel -DeploymentModel $data.deploymentModel -HostNetwork $data.hostNetwork -RdmaOption $data.rdmaOption
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

            table -ChildItem {
                th -Content "Task"
                th -Content "Script"
                th -Content "Restart Required?"
                foreach ($script in $dScript) {
                    tr -Content {
                        td -Content {
                            $script.Name
                        }
                        td -Content {
                            $script.scriptPath 
                        }
                        td -Content {
                            $script.requiresRestart
                        }
                    }
                }
            }
        } -Style "background: #99d6ff;" 
    }
    $Response.Send($Html)
}
