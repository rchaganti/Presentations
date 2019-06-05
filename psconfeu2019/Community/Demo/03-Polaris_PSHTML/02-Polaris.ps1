Import-Module Polaris -Verbose
Add-Type -AssemblyName System.Web

Push-Location
Set-Location -Path '.\demo\03-Polaris_PSHTML\MyResponse'

New-PolarisGetRoute -Path '/' -Scriptblock {
    $Response.SetContentType('text/html')
    $Html = Get-Content -Path .\index.html
    $Response.Send($Html)
}

New-PolarisPostRoute -Path '/MyResponse' -Scriptblock {
    $Response.SetContentType('application/json')
    $Body = [System.Web.HttpUtility]::UrlDecode($Request.BodyString)
    $Data = @{}
    $Body.split('&') | ForEach-Object {
        $part = $_.split('=')
        $Data.add($part[0], $part[1])
    }
    $Response.Send(($Data | ConvertTo-Json))
}

Start-Polaris -Port 9000
Pop-Location