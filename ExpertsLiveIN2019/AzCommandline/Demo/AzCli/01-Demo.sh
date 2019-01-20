#!/usr/bin/env bash

## Login
### Interactive
az login

### Service Principal
az login --service-principal -u "91a8ad81-2f20-4800-8b1d-e6299f20b533" --tenant "7eb05ed1-e512-43a8-b91e-bcf3f53904f2"

## Finding az commands
az find -q vm
az -help

## Get vm image list
az vm image list

## Get VM image skus
az vm image list-skus --help
az vm image list-skus -p MicrosoftWindowsServer -f windowsserver

## Create a vm
az vm create -n w2016vm02 -g s2d --image Win2016Datacenter --location eastus --size Standard_A2

## get vm
az vm list 

## Get vm PowerState
az vm list -g s2d -d --query "[].[name, powerState]" -o json

az vm list -g s2d -d --query '[].{VMName:name, State:powerState}' -o table

## Stop VM
az vm stop --ids $(az vm list -g s2d --query "[].id" -o tsv)

## az output formats
az account list-locations -o json

## query az output for only one property
az account list-locations -o json --query '[].displayName'

## Rename desired properties in the output
az account list-locations -o json --query '[].{Name:displayName}' 

## Desired properties in table format
az account list-locations -o json --query '[].{FullName:displayName, Name:name}' -o table

## Filter output for a specific desired vaue
az account list-locations -o json --query "[?contains(displayName,'India')].{FullName:displayName,Name:name}" -o table

## Set defaults
az configure --defaults location=southindia

## Create a resource group; notice that it gets created in southindia
az group create --name testRGELive2019IND

## query for groups again
az group list --query "[?location=='southindia']"

## remove resource group
az group delete --name testRGELive2019IND --yes

## Get all extensions
az extension list-available --output table

## install extension
az extension add --help
