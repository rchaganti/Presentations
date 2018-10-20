#Start webserver
.\01_HTTPListener\01_00_Demo_HTTPListener.ps1 -Verbose

#Get a list of all processes
$proc = Invoke-RestMethod -Method Get -UseBasicParsing -Uri http://localhost:7070/List 

#Start a new process
$proc = Invoke-RestMethod -Method Post -UseBasicParsing -Uri http://localhost:7070/Start -Body (@{"Name"="Notepad.exe"} | ConvertTo-Json)

#stop the process
$proc = Invoke-RestMethod -Method Delete -UseBasicParsing -Uri http://localhost:7070/Stop -Body (@{"Id"=$($proc.Id)} | ConvertTo-Json) -ContentType 'application/json'

#Stop the webserver
Invoke-RestMethod -Method Delete -UseBasicParsing -Uri http://localhost:7070/StopWebServer