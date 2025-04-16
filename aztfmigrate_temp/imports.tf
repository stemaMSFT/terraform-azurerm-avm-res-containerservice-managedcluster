
terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = ""
}

provider "azapi" {
}
resource "azapi_resource" "managedCluster_this" {}
resource "azapi_resource" "workspace_this" {}
resource "azapi_resource" "resourceGroup_this" {}
