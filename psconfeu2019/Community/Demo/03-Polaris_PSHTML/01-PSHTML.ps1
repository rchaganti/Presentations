Push-Location
Set-Location -Path .\Demo\03-Polaris_PSHTML\MyResponse
Import-Module PSHTML

$html = html {
    head {
        title "Home Page"
        link -rel "stylesheet" -href "home.css" -type "text/css"
    }
    Body {
        hr {
            "Horizontal Line"
        } -Style "border-width: 2px"
        h1 {
            'PSHTML &hearts; Polaris!' 
        } -Style "font-family: 'Candara';text-align:center"
        hr {
            "Horizontal Line"
        } -Style "border-width: 2px"
        form {
            "RequestForm"
        } -action "/MyResponse" -method 'post' -target '_blank' -style "font-family:Candara" -Content {
            "First Name"
            input -type text "FN" -style "font-family:Candara"
            "Last Name"
            input -type text "SN"
            "Submit"
            input -type submit "Submit" -style "font-family:Candara"
        }
    } 
}

Out-File -InputObject $html -FilePath .\index.html -force
Pop-Location