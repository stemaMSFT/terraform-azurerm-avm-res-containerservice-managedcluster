output "key_vault_secrets_provider_object_id" {
  description = "The object ID of the key vault secrets provider."
  value       = try(azapi_resource.managedCluster_this.key_vault_secrets_provider[0].secret_identity[0].object_id, null)
}

output "kubelet_identity_id" {
  description = "The identity ID of the kubelet identity."
  value       = azapi_resource.managedCluster_this.kubelet_identity[0].object_id
}

output "name" {
  description = "Name of the Kubernetes cluster."
  value       = azapi_resource.managedCluster_this.name
}

output "node_resource_group_id" {
  description = "The resource group ID of the node resource group."
  value       = azapi_resource.managedCluster_this.node_resource_group_id
}

output "nodepool_resource_ids" {
  description = "A map of nodepool keys to resource ids."
  value = { for npk, np in module.nodepools : npk => {
    resource_id = np.resource_id
    name        = np.name
    }
  }
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL of the Kubernetes cluster."
  value       = azapi_resource.managedCluster_this.oidc_issuer_url
}

output "private_endpoints" {
  description = <<DESCRIPTION
  A map of the private endpoints created.
  DESCRIPTION
  value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
}

output "resource_id" {
  description = "Resource ID of the Kubernetes cluster."
  value       = azapi_resource.managedCluster_this.id
}
