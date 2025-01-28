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

variable "resource_group_name" {
  type        = string
  default     = null
  description = "The name of the resource group"
}
