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
  default     = true
}

variable "enable_monitoring" {
  description = "Variable to enable or disable Monitoring"
  default     = true
}

# variable "client_secret" {
#   description = "Service Principal Secret"
# }

variable "enable_vnet_isolation" {
  description = "Enable or disable vnet isolation"
  type        = bool
  default     = true
}

variable "deploy_bastion" {
  description = "Whether or not to deploy bastion"
  type        = bool
  default     = true
}

variable "deploy_management_subnet" {
  description = "Whether or not to deploy management subnet"
  type        = bool
  default     = true
}

variable "deploy_jumphost" {
  description = "Whether or not to deploy jumphost"
  type        = bool
  default     = true
}

variable "vnet_cidr" {
  type        = string
  description = "Virtual network CIDR"
}

variable "repository" {
  description = "The URL of the GitHub repository."
}

variable "access_token" {
  description = "The access token for the GitHub repository."
}

variable "runner_name" {
  description = "The name of the GitHub runner."
}

variable "private_endpoints_subnet" {
  type = object({
    name           = string
    address_prefix = string
    network_security_group = object({
      name   = string
      rules  = optional(list(object({
        name                         = string
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_address_prefix        = optional(string, "")
        source_address_prefixes      = optional(list(string), [])
        source_port_range            = optional(string, "")
        source_port_ranges           = optional(list(string), [])
        destination_address_prefix   = optional(string, "")
        destination_address_prefixes = optional(list(string), [])
        destination_port_range       = optional(string, "")
        destination_port_ranges      = optional(list(string), [])
        description                  = string
      })))
    })
    delegation = list(object({
      name              = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  })

}

variable "management_subnet" {
  type = object({
    name           = string
    address_prefix = string
    network_security_group = object({
      name   = string
      rules  = optional(list(object({
        name                         = string
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_address_prefix        = optional(string, "")
        source_address_prefixes      = optional(list(string), [])
        source_port_range            = optional(string, "")
        source_port_ranges           = optional(list(string), [])
        destination_address_prefix   = optional(string, "")
        destination_address_prefixes = optional(list(string), [])
        destination_port_range       = optional(string, "")
        destination_port_ranges      = optional(list(string), [])
        description                  = string
      })))
    })
    delegation = list(object({
      name              = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  })
  default = null
}

variable "bastion_subnet" {
  type = object({
    name           = string
    address_prefix = string
    network_security_group = object({
      name   = string
      rules  = optional(list(object({
        name                         = string
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_address_prefix        = optional(string, "")
        source_address_prefixes      = optional(list(string), [])
        source_port_range            = optional(string, "")
        source_port_ranges           = optional(list(string), [])
        destination_address_prefix   = optional(string, "")
        destination_address_prefixes = optional(list(string), [])
        destination_port_range       = optional(string, "")
        destination_port_ranges      = optional(list(string), [])
        description                  = string
      })))
    })
    delegation = list(object({
      name              = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  })
  default = null  
}

variable "runner_subnet" {
  type = object({
    name           = string
    address_prefix = string
    network_security_group = object({
      name   = string
      rules  = optional(list(object({
        name                         = string
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_address_prefix        = optional(string, "")
        source_address_prefixes      = optional(list(string), [])
        source_port_range            = optional(string, "")
        source_port_ranges           = optional(list(string), [])
        destination_address_prefix   = optional(string, "")
        destination_address_prefixes = optional(list(string), [])
        destination_port_range       = optional(string, "")
        destination_port_ranges      = optional(list(string), [])
        description                  = string
      })))
    })
    delegation = list(object({
      name              = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  })
  default = null  
}

variable "aml_compute_clusters" {
  type = map(object({
    name                                 = string
    vm_priority                          = string
    vm_size                              = string
    min_nodes                            = number
    max_nodes                            = number
    scale_down_nodes_after_idle_duration = string
  }))
  default = {
    "training" = {
      name                                 = "training-cluster"
      vm_priority                          = "LowPriority"
      vm_size                              = "Standard_DS3_v2"
      min_nodes                            = 0
      max_nodes                            = 4
      scale_down_nodes_after_idle_duration = "PT2M"
    },
    scoring = {
      name                                 = "scoring-cluster"
      vm_priority                          = "LowPriority"
      vm_size                              = "Standard_DS3_v2"
      min_nodes                            = 0
      max_nodes                            = 4
      scale_down_nodes_after_idle_duration = "PT2M"
    }
  }
}


