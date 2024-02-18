variable "location" {
  type        = string
  description = "Location of the resource group and modules"
}

variable "prefix" {
  type        = string
  description = "Prefix for module names"
}

variable "environment" {
  type        = string
  description = "Environment information"
}

variable "postfix" {
  type        = string
  description = "Postfix for module names"
}

variable "enable_aml_computecluster" {
  description = "Variable to enable or disable AML compute cluster"
}

variable "enable_monitoring" {
  description = "Variable to enable or disable Monitoring"
}

variable "client_secret" {
  description = "Service Principal Secret"
}

variable "vnet_address_space" {
  type        = string
  description = "VNET Address Space, such as '10.0.0.0/22'"
}

variable "name" {
  type        = string
  description = "A 4 character name identifier, such as 'test'"
  validation {
    condition     = length(var.name) < 5
    error_message = "The id value must be max 4 chars."
  }
}