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

variable "storage_account_id" {
  type        = string
  description = "The ID of the Storage Account linked to AML workspace"
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the Key Vault linked to AML workspace"
}

variable "application_insights_id" {
  type        = string
  description = "The ID of the Application Insights linked to AML workspace"
}

variable "container_registry_id" {
  type        = string
  description = "The ID of the Container Registry linked to AML workspace"
}

variable "enable_aml_computecluster" {
  description = "Variable to enable or disable AML compute cluster"
  default     = false
}

variable "enable_vnet_isolation" {
  description = "Enable or disable vnet isolation"
  type        = bool
  default     = true
}

variable "storage_account_name" {
  type        = string
  description = "The Name of the Storage Account linked to AML workspace"
}

variable "private_dns_zone_mlw_api_id" {
  type        = string
  description = "Azure mlw api private dns zone id"
}

variable "private_dns_zone_notebook_id" {
  type        = string
  description = "Azure mlw notebooks private dns zone id"
}

variable "private_dns_zone_azuremlcert_id" {
  type        = string
  description = "Azure mlw cert private dns zone id"
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Private endpoint subnet id"
}

# variable "training_subnet_id" {
#   type        = string
#   description = "Training subnet id"
# }

# variable "scoring_subnet_id" {
#   type        = string
#   description = "Scoring subnet id"
# }

variable "training_cluster" {
  type = object({
    name                                 = string
    vm_priority                          = string
    vm_size                              = string
    min_nodes                            = number
    max_nodes                            = number
    scale_down_nodes_after_idle_duration = string
  })
  default = {
    name                                 = "training-cluster"
    vm_priority                          = "LowPriority"
    vm_size                              = "Standard_DS3_v2"
    min_nodes                            = 0
    max_nodes                            = 4
    scale_down_nodes_after_idle_duration = "PT2M"
  }
}

variable "scoring_cluster" {
  type = object({
    name                                 = string
    vm_priority                          = string
    vm_size                              = string
    min_nodes                            = number
    max_nodes                            = number
    scale_down_nodes_after_idle_duration = string
  })
  default = {
    name                                 = "scoring-cluster"
    vm_priority                          = "LowPriority"
    vm_size                              = "Standard_DS3_v2"
    min_nodes                            = 0
    max_nodes                            = 4
    scale_down_nodes_after_idle_duration = "PT2M"
  }
}
