variable "mongodb_kv_secrets" {
  description = "Map of secret names to their values"
  type        = map(string)
}
variable "key_vault_id" {
  type        = string
  description = "The resource ID of the key vault"

}
variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

variable "location" {
  type        = string
  description = "The location of the storage account"
}

variable "principal_id" {
  type        = string
  description = "The principal ID of the user"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"

}
variable "identity_name" {
  type        = string
  description = "The name of the identity"
}

variable "mongodb_namespace" {
  type        = string
  description = "The name of the mongodb namespace to create"
}

variable "service_account_name" {
  type        = string
  description = "The name of the service account to create"
}

variable "oidc_issuer_url" {
  type        = string
  description = "The name of the service account to create"
}
