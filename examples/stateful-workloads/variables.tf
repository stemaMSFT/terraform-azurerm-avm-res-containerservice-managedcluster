variable "cluster_name" {
  type        = string
  default     = null
  description = "The name of the Kubernetes cluster"
}

variable "location" {
  type        = string
  default     = null
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
  default     = {}
  description = "Optional. The additional node pools for the Kubernetes cluster."
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The name of the resource group"
}
