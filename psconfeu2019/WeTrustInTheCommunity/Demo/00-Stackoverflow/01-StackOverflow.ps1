$csv = Import-Csv -Path .\Demo\00-Stackoverflow\QueryResults.csv -Verbose
$csv | Out-GridView

$chart = $csv | Select-Object -Property TagName, QuestionCount
$chd = 't:' + (($chart | Select-Object -ExpandProperty QuestionCount) -join ',')

$chl=($chart | Select-Object @{n='Label';e={ $_.TagName + ' - ' + $_.QuestionCount }} | Select-Object -ExpandProperty Label) -join '|'
$url = "https://chart.googleapis.com/chart?cht=p&chs=600x200&chd=$chd&chl=$chl"

Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile "$env:temp\powershell.png"

$view = New-VSCodeHtmlContentView -Title "PowerShellStackOverflow" -ShowInColumn One
Set-VSCodeHtmlContentView -View $view -Content "<h1>PowerShell Questions on Stack Overflow</h1>"
$b64Image = [convert]::ToBase64String((get-content "${env:temp}\powershell.png" -encoding byte))
Write-VSCodeHtmlContentView $view -Content "<img src='data:image/png;base64,$b64Image'><br />"
Show-VSCodeHtmlContentView -HtmlContentView $view 