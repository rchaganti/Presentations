#Install Modules SHiPS and CimPSDrive
Install-Module -Name SHiPS, CimPSDrive -Force

#Import Module CimPSDrive
Import-Module -Name SHiPS, CimPSDrive -Force

#Create a PS Drive
New-PSDrive -Name cim -PSProvider SHiPS -Root 'CimPSDrive#CmRoot'

#Move to CIM PS Drive
Set-Location -Path cim:

#Get-ChildItem shows localhost by default
Get-ChildItem

#Get-Item provides more information on the CIM Class
Get-Item -Path .\cimv2\Win32_BIOS | Format-List *

#Get-ChildItem inside a class gives us the instances
Get-ChildItem -Path .\Cimv2\Win32_BIOS

#Connect-CIM enables us to connect to a remote target
Connect-Cim -ComputerName 172.16.102.2 -Credential (Get-Credential)