# getting help
az --help

# CLI configuration
az configure --help
Get-Content -Path "$HOME\.azure\config"

# login
az login

# service principal
az login --service-principal -u "91a8ad81-2f20-4800-8b1d-e6299f20b533" --tenant "7eb05ed1-e512-43a8-b91e-bcf3f53904f2"

# finding az commands
az find --query vm

# finding sub command help
az vm --help

# create a vm
az vm create -n s201604 -g gab --image Win2016Datacenter --location eastus --size Standard_A2

# list all VMs
az vm list

# Azure CLI extensions
# list all extensions
az extension list-available

# list installed extensions
az extension list

# interactive CLI
az interactive

# upgrading extensions
az extension update -n interactive

# interactive CLI
az interactive
