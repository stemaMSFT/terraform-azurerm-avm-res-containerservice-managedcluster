terraform {
  required_version = ">= 1.9.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = coalesce(var.location, module.regions.regions[random_integer.region_index.result].name)
  name     = coalesce(var.resource_group_name, module.naming.resource_group.name_unique)
}

data "azurerm_client_config" "current" {}

module "avm_res_keyvault_vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  version             = "0.9.1"
  location            = azurerm_resource_group.this.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.key_vault.name_unique
  #enable_rbac_authorization = false
  legacy_access_policies_enabled = true
}
module "avm_res_containerregistry_registry" {
  source              = "Azure/avm-res-containerregistry-registry/azurerm"
  version             = "0.4.0"
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.container_registry.name_unique
  location            = azurerm_resource_group.this.location
  sku                 = "Premium"
  admin_enabled       = true
}

module "avm_res_storage_storageaccount" {
  for_each = { for key, pool in var.node_pools : key => pool if pool.name == "mongodb" }

  source                   = "Azure/avm-res-storage-storageaccount/azurerm"
  version                  = "0.4.0"
  resource_group_name      = azurerm_resource_group.this.name
  name                     = module.naming.storage_account.name_unique
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

}

resource "azurerm_storage_container" "this" {
  for_each = { for key, pool in var.node_pools : key => pool if pool.name == "mongodb" }

  name               = "backups"
  storage_account_id = module.avm_res_storage_storageaccount[each.key].resource_id
}


# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "default" {
  source                    = "../.."
  name                      = coalesce(var.cluster_name, module.naming.kubernetes_cluster.name_unique)
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  sku_tier                  = "Standard"
  local_account_disabled    = false
  node_os_channel_upgrade   = "NodeImage"
  automatic_upgrade_channel = "stable"

  default_node_pool = {
    name                    = "default"
    node_count              = 3
    vm_size                 = "Standard_D2ds_v4"
    os_type                 = "Linux"
    auto_upgrade_channel    = "stable"
    node_os_upgrade_channel = "NodeImage"
    zones                   = [1, 2, 3]

    addon_profile = {
      azure_key_vault_secrets_provider = {
        enabled = true
      }
    }
    upgrade_settings = {
      max_surge = "10%"
    }
  }

  node_pools                = var.node_pools
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  network_profile = {
    network_plugin = "azure"
  }

}
resource "azurerm_role_assignment" "acr_role_assignment" {
  principal_id         = module.default.kubelet_identity_id
  scope                = module.avm_res_containerregistry_registry.resource_id
  role_definition_name = "AcrPull"
}
