# Install the Az Module
# This is a rollup module which downloads and installs other PowerShell modules for Azure services
Install-Module -Name Az -Force

# Get all Azure modules
Get-Module -ListAvailable -Name Az*

# Help and documentation is still evolving
Get-Help Connect-AzAccount -Online

# Login
### Interactive
Connect-AzAccount

### Service Principal
$psCredentil = Get-Credential 
Connect-AzAccount -Credential $pscredential -ServicePrincipal -TenantId '7eb05ed1-e512-43a8-b91e-bcf3f53904f2'

## Get vm image SKU list
Get-AzVMImageSku -Location westus -PublisherName MicrosoftWindowsServer -Offer WindowsServer

## Create VM
### Simple VM
New-AzVM -Name MyVm02 -Credential (Get-Credential) -ResourceGroupName s2d

### VM with more custom configuration
$VMLocalAdminUser = "rchaganti"
$VMLocalAdminSecurePassword = ConvertTo-SecureString 'P0wer$hell' -AsPlainText -Force
$LocationName = "westus"
$ResourceGroupName = "S2D"
$ComputerName = "W201604"
$VMName = "W201604"
$VMSize = "Standard_A2"

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2012-R2-Datacenter' -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose

## Stop virtual machines
Get-AzVM -ResourceGroupName s2d -Status
(Get-AzVM -ResourceGroupName s2d -Status).Where({$_.PowerState -eq 'VM running'})
(Get-AzVM -ResourceGroupName s2d -Status).Where({$_.PowerState -eq 'VM running'}) | Stop-AzVM

## Simple command output
Get-AzLocation 

## Get only desired properties
Get-AzLocation | Select-Object -Property DisplayName, Location

## Filter output for desired text
Get-AzLocation | Where-Object { $_.DisplayName -like "*india*"}

