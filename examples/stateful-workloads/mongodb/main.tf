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

## Section to assign the Key Vault Administrator role to the current user
######################################################################################################################

resource "azurerm_role_assignment" "keyvault_role_assignment" {
  depends_on           = [var.key_vault_id]
  principal_id         = var.principal_id
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
}

## Section to create the Azure Key Vault secrets for MongoDB
######################################################################################################################

resource "azurerm_key_vault_secret" "this" {
  depends_on = [azurerm_role_assignment.keyvault_role_assignment]

  for_each = var.mongodb_kv_secrets != null ? merge(
    {
      "AZURE-STORAGE-ACCOUNT-KEY"  = module.avm_res_storage_storageaccount.resource.primary_access_key
      "AZURE-STORAGE-ACCOUNT-NAME" = module.avm_res_storage_storageaccount.resource.name
    },
    { for key, value in var.mongodb_kv_secrets : key => value }
    ) : {
    "AZURE-STORAGE-ACCOUNT-KEY"  = module.avm_res_storage_storageaccount.resource.primary_access_key
    "AZURE-STORAGE-ACCOUNT-NAME" = module.avm_res_storage_storageaccount.resource.name
  }

  key_vault_id = var.key_vault_id
  name         = each.key
  value        = each.value
}

## Section to create the user-assigned identity 
######################################################################################################################
resource "azurerm_user_assigned_identity" "this" {
  location            = var.location
  name                = var.identity_name
  resource_group_name = var.resource_group_name
}

# ## Uncomment the following block to create below resources later in the next steps of the document
# ######################################################################################################################

# ## Section to create the federated identity credential for external secret operator to access the secret
# ######################################################################################################################
# resource "azurerm_federated_identity_credential" "this" {
#   name                = "external-secret-operator"
#   resource_group_name = var.resource_group_name
#   audience            = ["api://AzureADTokenExchange"]
#   issuer              = var.oidc_issuer_url
#   parent_id           = azurerm_user_assigned_identity.this.id
#   subject             = "system:serviceaccount:${var.mongodb_namespace}:${var.service_account_name}"
# }

# ## Section to assign permission to the user-assigned identity to access the secret in the key vault
# ######################################################################################################################
# resource "azurerm_key_vault_access_policy" "this" {
#   key_vault_id = var.key_vault_id
#   tenant_id    = azurerm_user_assigned_identity.this.tenant_id
#   object_id    = azurerm_user_assigned_identity.this.principal_id

#   secret_permissions = [
#     "Get"
#   ]
# }
# ######################################################################################################################
