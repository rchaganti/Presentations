if (-not (Get-Module -ListAvailable -Name ImportExcel -ErrorAction SilentlyContinue))
{
    Install-Module -Name ImportExcel -Force
}

$speakersJson = 'https://raw.githubusercontent.com/psconfeu/2019/master/data/speakers.json'
$sessionsJson = 'https://raw.githubusercontent.com/psconfeu/2019/master/sessions.json'

$speakers = ConvertFrom-Json (Invoke-WebRequest -UseBasicParsing -Uri $speakersJson).content
$sessions = ConvertFrom-Json (Invoke-WebRequest -UseBasicParsing -Uri $sessionsJson).content

# All Sessions Sheet
$sessions | Select-Object Name, Starts, Ends, Track, Speaker | 
            Export-Excel -Path .\psconfeu2019.xlsx -WorksheetName 'All Tracks' `
            -Title 'PowerShell Conference EU 2019 - Sessions' `
            -TitleBold -TitleFillPattern DarkDown -TitleSize 20 `
            -TableStyle Medium6 -BoldTopRow

# Track sheets
foreach ($i in 1..3)
{
    $trackSessions = $sessions.Where({$_.Track -eq "Track $i"})
    $trackSessions | Select-Object Name, Starts, Ends, Speaker |
        Export-Excel -Path .\psconfeu2019.xlsx -WorksheetName "Track $i" `
        -Title 'PowerShell Conference EU 2019 - Track $i' `
        -TitleBold -TitleFillPattern DarkDown -TitleSize 20 `
        -TableStyle Medium6 -BoldTopRow        
}

# Add Speakers sheet
$speakers | Export-Excel -Path .\psconfeu2019.xlsx -WorksheetName 'Speakers' `
    -Title 'PowerShell Conference EU 2019 - Speakers' `
    -TitleBold -TitleFillPattern DarkDown -TitleSize 20 `
    -TableStyle Medium6 -BoldTopRow 

# Add chart for speaker country number
$chartDef = New-ExcelChart -Title 'PowerShell Conference EU 2019 - Speakers' `
                    -ChartType ColumnClustered `
                    -XRange Name -YRange Count `
                    -Width 800 -NoLegend -Column 3 

$speakers | Group-Object -Property Country | Select-Object Name, Count |  Sort-Object -Property Count -Descending |
    Export-Excel -path .\psconfeu2019.xlsx -AutoSize -AutoNameRange -ExcelChartDefinition $chartDef -WorksheetName SpeakerCountryChart -Show
