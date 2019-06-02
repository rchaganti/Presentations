# Install PSKoans
Install-Module -Name PSKoans -SkipPublisherCheck -Scope CurrentUser

# Commands in PSKoans module
Get-Command -Module PSKoans

# Get the loacation where PSKoans are stored
Get-PSKoanLocation

# Get PowerShell tips
# Use Register-Advice to receive a tip every time you open the console
Get-Advice

# Measure initial karma
Measure-Karma

# Start medidating
Measure-Karma -Meditate
