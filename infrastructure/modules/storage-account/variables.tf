variable "rg_name" {
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
  description = "A mapping of tags which should be assigned to the Resource Group"
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

variable "hns_enabled" {
  type        = bool
  description = "Hierarchical namespaces enabled/disabled"
  default     = true
}

variable "private_dns_zone_blob_id" {
  type        = string
  description = "Blob private dns zone id"
}

variable "pe_subnet_id" {
  type        = string
  description = "Private endpoint subnet id"
}


variable "firewall_virtual_network_subnet_ids" {
  default = []
}

variable "firewall_bypass" {
  default = ["None"]
}