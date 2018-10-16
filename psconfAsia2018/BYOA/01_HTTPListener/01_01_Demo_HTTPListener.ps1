Set-Location -Path C:\Documents\GitHub\Presentations\psconfAsia2018\BYOA\01_HTTPListener

#Web Server Demo
psEdit .\01_00_Demo_HTTPListener.ps1

#Start webserver
.\01_00_Demo_HTTPListener.ps1 -Verbose

#Get a list of all processes
$proc = Invoke-RestMethod -Method Get -UseBasicParsing -Uri http://localhost:8080/List 

#Start a new process
$proc = Invoke-RestMethod -Method Post -UseBasicParsing -Uri http://localhost:8080/Start -Body (@{"Name"="Notepad.exe"} | ConvertTo-Json)

#stop the process
$proc = Invoke-RestMethod -Method Delete -UseBasicParsing -Uri http://localhost:8080/Stop -Body (@{"Id"=$($proc.Id)} | ConvertTo-Json) -ContentType 'application/json'

#Stop the webserver
Invoke-RestMethod -Method Delete -UseBasicParsing -Uri http://localhost:8080/StopWebServer