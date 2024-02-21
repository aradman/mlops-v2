variable "rg_name" {
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

variable "management_nsg_id" {
  type        = string
  description = "Management nsg id"
}

variable "jumphost_password" {
  type        = string
  description = "Jumphost password"
}