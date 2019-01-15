# Install the Az Module
# This is a rollup module which downloads and installs other PowerShell modules for Azure services
Install-Module -Name Az -Force

# Get all Azure modules
Get-Module -ListAvailable -Name Az*

# Connect Azure Account
Get-Help Connect-AzAccount -Online
