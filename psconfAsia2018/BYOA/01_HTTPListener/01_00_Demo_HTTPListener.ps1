#Web Server for listing processes, creating new processes, and stopping processes
[CmdletBinding()]
param
(
    [Parameter()]
    [String]
    $IPAddress,


    [Parameter()]
    [Int]
    $Port
)

#Function to retrieve POST parameters
function Get-RequestBody
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ContentType,
    
        [Parameter(Mandatory = $true)]
        [System.Text.Encoding]
        $ContentEncoding,
    
        [Parameter(Mandatory = $true)]
        [System.IO.Stream]
        $Body
    )
    
    $streamReader = [System.IO.StreamReader]::new($Body)
    $bodyContents = $StreamReader.ReadToEnd()
    
    $bodyContents = $BodyContents | ConvertFrom-Json
    
    return $bodyContents
}

#Define routes
$routes = @{
    'GET /' = {
                return '<html><body>Welcome to the most sophisticated process manager API!</body></html>'
    }

    'GET /List' = { 
        $process = Get-Process | Select Name, Id, CPU
        $content = $process | ConvertTo-Json

        [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)

        # Write response out and close
        $response.StatusCode = 200
        $response.ContentType = 'application/json'
        $response.ContentLength64 = $buffer.length
        $output = $response.OutputStream
        $output.Write($buffer, 0, $buffer.length)
        $output.Close()
    }
    
    'POST /Start' = {
        #Get POST parameters
        $parameters = Get-RequestBody -ContentType $Context.Request.ContentType -ContentEncoding $Context.Request.ContentEncoding -Body $Context.Request.InputStream

        if ($parameters.Name)
        {
            $process = Start-Process -FilePath $parameters.Name -PassThru -ErrorAction SilentlyContinue
            if ($process)
            {
                $content = $process | ConvertTo-Json
                $response.StatusCode = 200
                $response.ContentType = 'application/json'
            }
            else
            {
                $content = '<html><body>could not start the process!</body></html>'
            }
        }
        else
        {
            $content = '<html><body>The request body must contain the parameter Name!</body></html>'
        }

        [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.length

        # Write response out and close
        $output = $response.OutputStream
        $output.Write($buffer, 0, $buffer.length)
        $output.Close()
    }
    
    'DELETE /Stop' = {             
        #Get POST parameters
        $parameters = Get-RequestBody -ContentType $Context.Request.ContentType -ContentEncoding $Context.Request.ContentEncoding -Body $Context.Request.InputStream

        if ($parameters.Id)
        {
            $process = Stop-Process -Id $parameters.Id -PassThru -ErrorAction SilentlyContinue
            if ($process)
            {
                $content = $process | ConvertTo-Json
                $response.StatusCode = 200
                $response.ContentType = 'application/json'
            }
            else
            {
                $content = '<html><body>could not stop the process!</body></html>'
            }
        }
        else
        {
            $content = '<html><body>The request body must contain the parameter Id!</body></html>'
        }

        [byte[]]$buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.length

        # Write response out and close
        $output = $response.OutputStream
        $output.Write($buffer, 0, $buffer.length)
        $output.Close()
    }

    'DELETE /StopWebserver' = {             
        $response.StatusCode = 200
        $buffer = [System.Text.Encoding]::UTF8.GetBytes('<html><body>Shutdown Complete!</body></html>')
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        break
    }
}

#Start the listener
$url = "http://localhost:8080/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

Write-Verbose -Message "Listening at $url..."
while ($listener.IsListening)
{
    $context = $listener.GetContext()
    $requestUrl = $context.Request.Url
    $response = $context.Response
        
    $localPath = $requestUrl.LocalPath
    $route = $routes.Get_Item("$($context.Request.HttpMethod) $($requestUrl.LocalPath)")
        
    if ($route -eq $null)
    {
        $response.StatusCode = 404
    }
    else
    {
        $content = & $route
    }
}

$listener.Stop()