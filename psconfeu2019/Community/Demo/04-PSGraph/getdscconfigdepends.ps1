Function Get-DscConfigurationDependencyGraph
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ScriptAST
    )

    if (-not (Get-Module -ListAvailable -Name PSGraph))
    {
        throw 'This requires PSGraph module.'
    }
    else
    {
        Import-Module -Name PSGraph -Force
    }

    $config = $ScriptAST.FindAll({ $args[0] -is [System.Management.Automation.Language.ConfigurationDefinitionAst]}, $true)
    $dynKeywords = $config[0].FindAll({ $args[0] -is [System.Management.Automation.Language.DynamicKeywordStatementAst]}, $true)  

    $resourceHash = @()
    foreach ($keyword in $dynKeywords)
    {
        $hashTables = $keyword.FindAll({ $args[0] -is [System.Management.Automation.Language.HashtableAst]}, $true)    
        foreach ($hash in $hashTables)
        {        
            $currentResource = $keyword.CommandElements[0].Value
            $currentResourceInstanceName  = $keyword.CommandElements[1].Value
            $propertyHash = [Ordered] @{}
            $propertyCount = $hash.KeyValuePairs.Count - 1
            for ($i=0; $i -le $propertyCount; $i++)
            {
                $propertyName = $hash.KeyValuePairs[$i].Item1.Value
                $propertyValue = $hash.KeyValuePairs[$i].Item2.Extent.Text

                if ($propertyName -ne 'DependsOn')
                {
                    $propertyHash.Add($propertyName,$propertyValue)
                }
            }
            $dependsOn = $hash.KeyValuePairs.Where({$_.Item1.Value -eq 'DependsOn'})
            $dependsOnArray = @()
            if ($dependsOn)
            {
                $dependsOnText = $dependsOn.Item2.Extent.Text.Replace("'",'')
                $dependsOnText = $dependsOnText.Replace('"','')
                $dependentResources = $dependsOnText -split ','
                foreach ($resource in $dependentResources)
                {
                    $start = $resource.indexof('[')+1
                    $end = $resource.indexof(']')
                    $dependsOnArray += "$($resource.SubString($start, $end-1))-$($resource.SubString($end+1))"
                }
            }
        
            $resourceInstance = [Ordered] @{
                Id = "${currentResource}-${currentResourceInstanceName}"
                InstanceName = $currentResourceInstanceName
                ResourceType = $currentResource
                Properties = $propertyHash
            }
        
            if ($dependsOnArray.count -ge 1)
            {
                $resourceInstance.Add('DependsOn',$dependsOnArray)
            }

            $resourceHash += $resourceInstance
        }
    }

    $configGraph = graph "Configuration" {
        foreach ($resource in $resourceHash)
        {
            $id = $resource.Id
            edge $resource.Id -To $resourceHash.Where({$_.DependsOn -contains $id}).Id
        }
    }
    $null = $configGraph | Export-PSGraph -DestinationPath "${env:temp}\psdepends.png"

    #Show the HTML preview
    $view = New-VSCodeHtmlContentView -Title "PSDscConfigDepends" -ShowInColumn One
    Set-VSCodeHtmlContentView -View $view -Content "<h1>PSDSC Configuration Dependency Graph</h1>"
    $b64Image = [convert]::ToBase64String((get-content "${env:temp}\psdepends.png" -encoding byte))
    Write-VSCodeHtmlContentView $view -Content "<img width=500 height=500 src='data:image/gif;base64,$b64Image'><br />"
    Show-VSCodeHtmlContentView -HtmlContentView $view   
}
