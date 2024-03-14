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

variable "vnet_cidr" {
  type        = string
  description = "Virtual network CIDR"
}

variable "enable_vnet_isolation" {
  description = "Enable or disable vnet isolation"
  type        = bool
  default     = true
}

# variable "exisiting_hub_vnet_resource_group_name" {
#   description = "Existing hub virtual network resource group name"
# }

variable "exisiting_hub_vnet_name" {
  description = "Existing hub virtual network name"
}

variable "exisiting_hub_vnet_id" {
  description = "Existing hub virtual network ID"
}

# variable "firewall_private_ip_address" {
#   description = "Azure firewall private IP address"
# }

variable "deploy_management_subnet" {
  description = "Whether or not to deploy management subnet"
  type        = bool
  default     = true
}

variable "deploy_bastion" {
  description = "Whether or not to deploy bastion"
  type        = bool
  default     = true
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

# variable "training_subnet" {
#   type = object({
#     name           = string
#     address_prefix = string
#     network_security_group = object({
#       name   = string
#       rules  = optional(list(object({
#         name                         = string
#         priority                     = number
#         direction                    = string
#         access                       = string
#         protocol                     = string
#         source_address_prefix        = optional(string, "")
#         source_address_prefixes      = optional(list(string), [])
#         source_port_range            = optional(string, "")
#         source_port_ranges           = optional(list(string), [])
#         destination_address_prefix   = optional(string, "")
#         destination_address_prefixes = optional(list(string), [])
#         destination_port_range       = optional(string, "")
#         destination_port_ranges      = optional(list(string), [])
#         description                  = string
#       })))
#     })
#     delegation = list(object({
#       name              = string
#       service_delegation = object({
#         name    = string
#         actions = list(string)
#       })
#     }))
#   })
  
# }

# variable "scoring_subnet" {
#   type = object({
#     name           = string
#     address_prefix = string
#     network_security_group = object({
#       name   = string
#       rules  = optional(list(object({
#         name                         = string
#         priority                     = number
#         direction                    = string
#         access                       = string
#         protocol                     = string
#         source_address_prefix        = optional(string, "")
#         source_address_prefixes      = optional(list(string), [])
#         source_port_range            = optional(string, "")
#         source_port_ranges           = optional(list(string), [])
#         destination_address_prefix   = optional(string, "")
#         destination_address_prefixes = optional(list(string), [])
#         destination_port_range       = optional(string, "")
#         destination_port_ranges      = optional(list(string), [])
#         description                  = string
#       })))
#     })
#     delegation = list(object({
#       name              = string
#       service_delegation = object({
#         name    = string
#         actions = list(string)
#       })
#     }))
#   }) 
  
# }

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