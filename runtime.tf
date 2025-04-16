# # This is required for resource modules
# resource "azurerm_resource_group" "this" {
#   location = "uksouth"
#   name     = "rg-aztfmigrate-test"
# }
# 
moved {
  from = azurerm_resource_group.this
  to   = azapi_resource.resourceGroup_this
}

resource "azapi_resource" "resourceGroup_this" {
  type      = "Microsoft.Resources/resourceGroups@2024-07-01"
  parent_id = "/subscriptions/dbf3b6cb-c1d0-4d04-94b9-51509b8d33fd"
  name      = "rg-aztfmigrate-test"
  location  = "uksouth"
  body = {
    properties = {}
  }
  schema_validation_enabled = true
  ignore_casing             = false
  ignore_missing_property   = true
}

# resource "azurerm_log_analytics_workspace" "this" {
#   location            = azurerm_resource_group.this.location
#   name                = "my-log-analytics-workspace"
#   resource_group_name = azurerm_resource_group.this.name
# }
# 
moved {
  from = azurerm_log_analytics_workspace.this
  to   = azapi_resource.workspace_this
}

resource "azapi_resource" "workspace_this" {
  type      = "Microsoft.OperationalInsights/workspaces@2023-09-01"
  parent_id = azapi_resource.resourceGroup_this.id
  name      = "my-log-analytics-workspace"
  location  = azapi_resource.resourceGroup_this.location
  body = {
    etag = "\"380223da-0000-1100-0000-68001d080000\""
    properties = {
      features = {
        disableLocalAuth                            = false
        enableLogAccessUsingOnlyResourcePermissions = true
        legacy                                      = 0
        searchVersion                               = 1
      }
      publicNetworkAccessForIngestion = "Enabled"
      publicNetworkAccessForQuery     = "Enabled"
      retentionInDays                 = 30
      sku = {
        name = "PerGB2018"
      }
      workspaceCapping = {
        dailyQuotaGb = -1
      }
    }
  }
  ignore_casing             = false
  ignore_missing_property   = true
  schema_validation_enabled = true
}

data "azurerm_client_config" "current" {}

  