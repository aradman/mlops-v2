variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the resource group"
}

variable "pe_subnet_id" {
  type        = string
  description = "Private endpoint subnet id"
}