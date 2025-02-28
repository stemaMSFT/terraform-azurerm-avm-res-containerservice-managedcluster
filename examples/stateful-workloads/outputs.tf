
output "key_vault_id" {
  value = module.avm_res_keyvault_vault.resource_id
}

output "key_vault_uri" {
  value = module.avm_res_keyvault_vault.uri
}

output "acr_registry_id" {
  value = module.avm_res_containerregistry_registry.resource_id
}

output "acr_registry_name" {
  value = module.avm_res_containerregistry_registry.name
}

output "aks_kubelet_identity_id" {
  value = module.default.kubelet_identity_id
}

output "aks_oidc_issuer_url" {
  value = module.default.oidc_issuer_url
}

output "aks_nodepool_resource_ids" {
  value = module.default.nodepool_resource_ids
}

output "aks_cluster_name" {
  value = module.default.name
}
#############

output "identity_name_id" {
  value = module.mongodb[0].identity_name_id
}

output "identity_name" {
  value = module.mongodb[0].identity_name
}

output "identity_name_principal_id" {
  value = module.mongodb[0].identity_name_principal_id
}

output "identity_name_tenant_id" {
  value = module.mongodb[0].identity_name_tenant_id
}

output "identity_name_client_id" {
  value = module.mongodb[0].identity_name_client_id
}

output "storage_account_name" {
  value = module.mongodb[0].storage_account_name
}

output "storage_account_key" {
  sensitive = true
  value     = module.mongodb[0].storage_account_key
}
