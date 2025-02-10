variable "cluster_name" {
  type        = string
  default     = null
  description = "The name of the Kubernetes cluster"
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "The location of the resource group. Leaving this as null will select a random region"
}

variable "node_pools" {
  type = map(object({
    name       = string
    vm_size    = string
    node_count = number
    zones      = optional(list(string))
    os_type    = string
  }))
  default     = null
  description = "Optional. The additional node pools for the Kubernetes cluster."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The name of the resource group"
}

variable "acr_task_content" {
  description = "The YAML content for the Azure Container Registry task."
  type        = string
  default     = null
}

variable "kv_secrets" {
  description = "Map of secret names to their values"
  type        = map(string)
  default     = null
}
variable "stateful_workload_type" {
  description = "The type of stateful workload to deploy"
  type        = string
  default     = null
}
