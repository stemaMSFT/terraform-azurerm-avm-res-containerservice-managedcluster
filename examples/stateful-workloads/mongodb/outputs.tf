output "identity_name_id" {
  value = azurerm_user_assigned_identity.this.id
}

output "identity_name" {
  value = azurerm_user_assigned_identity.this.name
}

output "identity_name_principal_id" {
  value = azurerm_user_assigned_identity.this.principal_id
}

output "identity_name_tenant_id" {
  value = azurerm_user_assigned_identity.this.tenant_id
}

output "identity_name_client_id" {
  value = azurerm_user_assigned_identity.this.client_id
}

output "storage_account_name" {
  value = module.avm_res_storage_storageaccount.resource.name
}

output "storage_account_key" {
  sensitive = true
  value     = module.avm_res_storage_storageaccount.resource.primary_access_key
}


