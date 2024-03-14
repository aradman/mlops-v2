variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "management_subnet_id" {
  type        = string
  description = "Management subnet id"
}

# variable "key_vault_id" {
#   type        = string
#   description = "Key vault id"
# }