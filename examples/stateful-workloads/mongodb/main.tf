## Section to create the storage account for storing mongodb backups
######################################################################################################################
module "avm_res_storage_storageaccount" {
  source                        = "Azure/avm-res-storage-storageaccount/azurerm"
  version                       = "0.4.0"
  resource_group_name           = var.resource_group_name
  name                          = var.storage_account_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "ZRS"
  shared_access_key_enabled     = true
  public_network_access_enabled = true
  network_rules                 = null
  containers = {
    blob_container0 = {
      name = "backups"
    }
  }
}

resource "random_password" "passwords" {
  for_each = { for key, value in var.kv_secrets : key => value if value == "random_password" }

  length  = 32
  special = false
}

## Section to assign the Key Vault Administrator role to the current user
######################################################################################################################

resource "azurerm_role_assignment" "keyvault_role_assignment" {
  depends_on           = [var.key_vault_id]
  principal_id         = var.principal_id
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
}

## Section to create the Azure Key Vault secrets
######################################################################################################################

resource "azurerm_key_vault_secret" "this" {

  for_each = { for key, value in var.kv_secrets : key => value if value != "random_password" }

  key_vault_id = var.key_vault_id
  name         = each.key
  value        = each.value
}
