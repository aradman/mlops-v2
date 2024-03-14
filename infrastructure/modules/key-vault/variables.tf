variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags which should be assigned to the deployed resource"
}

variable "prefix" {
  type        = string
  description = "Prefix for the module name"
}

variable "postfix" {
  type        = string
  description = "Postfix for the module name"
}

variable "env" {
  type        = string
  description = "Environment prefix"
}

variable "enable_vnet_isolation" {
  description = "Enable or disable vnet isolation"
  type        = bool
  default     = true
}

# variable "private_dns_zone_kv_id" {
#   type        = string
#   description = "Keyvault private dns zone id"
# }

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Private endpoint subnet id"
}
