#!/usr/bin/env bash

## Login
az Login

## Finding az commands
az find -q vm
az -help

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