# Get all accounts
az account list

# Set a subscription
az account set --subscription 'Visual Studio Enterprise'
cat ~/.azure/azureProfile.json

# See the selected subscription
groupName=$(az group create --location southcentralus --name bitpro -o json | jq -r '.name')

# Create a VM
publicIpAddress=$(az vm create -n lin01 -g bitpro --image UbuntuLTS --generate-ssh-keys -o json | jq -r '.publicIpAddress')
ls -l ~/.ssh

# Connect to the VM
ssh $LOGNAME@$publicIpAddress -h

# Delete resource group
az group delete -n bitpro