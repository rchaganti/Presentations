# install graph extension
az extension add --name resource-graph

# first query
az graph query -q "where type =~ 'microsoft.compute/virtualmachines' and name contains '2019'"
