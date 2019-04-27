# JMESPath Query example
# get all locations for a specific resource type
# --query is the global switch on every azure cli command
az provider list --query "[?namespace=='Microsoft.Compute'].resourceTypes[].{resourceType:resourceType, locations:locations} | [?resourceType=='virtualMachines'] | [0].locations"

# to use JMESPath queries, you need to understand JSON
# [] is an array
# flatten the array
az vm list --query []

# pass thru the entire array
az vm list --query [*]

# get only one of the array elements
az vm list --query [-1]

# get a set of elements
az vm list --query [3:5]

# select a property
az vm list --query [].name

# selecting and assigning to a variable
$username=$(az account show --query 'user.name' --output tsv)
$username

# select multiple properties
az vm list --query '[].[name, storageProfile.imageReference.sku]'

# rename properties
az vm list --query "[].{Name: name, OSSKU: storageProfile.imageReference.sku}"

# filter output for a specific property
az vm list --query "[?storageProfile.osDisk.osType == 'Linux']"

# select properties after a filter
az vm list --query "[?storageProfile.osDisk.osType == 'Linux'].[name, location]"

# multiple filters
az vm list --query "[?tags.env == 'qa' || tags.env == 'dev'].[name, tags.env]"

# contains function
az vm list --show-details --output json --query "[?contains(storageProfile.imageReference.sku, '2019')]"

# list all VMs in deallocated state
az vm list -d --query "[?powerState == 'VM deallocated'].[name, location]"

# nested commands with queries
az vm start --ids $(az vm list -d --query "[?powerState == 'VM deallocated'].id" -o tsv)

# validate queries interactively
az vm list | jpterm
