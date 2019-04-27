# install graph extension
az extension add --name resource-graph

# first query
az graph query -q "where type =~ 'microsoft.compute/virtualmachines' and name contains '2019'"

# measure
Measure-Command -Expression { az vm list --query "[?contains(name, '2019')]"}
Measure-Command -Expression {az graph query -q "where type =~ 'microsoft.compute/virtualmachines' and name contains '2019'"}

# select properties
az graph query -q "where type=~ 'microsoft.compute/virtualmachines' | project subscriptionId, name, location, resourceGroup"

# count of resources by type
az graph query -q "summarize count() by type| project resource=type , total=count_ | order by total desc" --output table

# rename properties
az graph query -q "where type =~ 'Microsoft.Compute/virtualMachines' | project  SKU = tostring(properties.hardwareProfile.vmSize)| summarize count() by SKU" --output table

# group by OS Type
az graph query -q "where type =~ 'Microsoft.Compute/virtualMachines' | summarize count() by tostring(properties.storageProfile.osDisk.osType)" --output table
