variable "key_vault_id" {
  type        = string
  description = "The resource ID of the key vault"

}
variable "valkey_password" {
  type      = string
  sensitive = true
  #generate password using openssl rand -base64 32 
  description = "The password for the Valkey"
}

variable "object_id" {
  type        = string
  description = "The object ID of the service principal"
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID of the service principal"
}




