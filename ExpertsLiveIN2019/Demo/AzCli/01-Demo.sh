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
az vm create -n w2016vm01 -g s2d --image Win2016Datacenter

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
az extension add azure-devops
