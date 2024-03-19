resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}-${var.postfix}${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

locals {
  subnets = {
    private_endpoints = var.private_endpoints_subnet
    # training          = var.training_subnet
    # scoring           = var.scoring_subnet
    management        = var.deploy_management_subnet ? var.management_subnet : null
    bastion           = var.enable_vnet_isolation && var.deploy_bastion? var.bastion_subnet : null
    runner            = var.enable_vnet_isolation ? var.runner_subnet : null
  }

}

resource "azurerm_subnet" "subnet" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = each.value.delegation
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

// Create network security groups from the subnets map variable
resource "azurerm_network_security_group" "nsg" {
  for_each = local.subnets

  name                = each.value.network_security_group.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dynamic "security_rule" {
    for_each = each.value.network_security_group.rules

    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_address_prefix        = security_rule.value.source_address_prefix
      source_address_prefixes      = security_rule.value.source_address_prefixes
      source_port_range            = security_rule.value.source_port_range
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_address_prefix   = security_rule.value.destination_address_prefix
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      destination_port_range       = security_rule.value.destination_port_range
      destination_port_ranges      = security_rule.value.destination_port_ranges
      description                  = security_rule.value.description
    }
  }
  tags = var.tags
}

// Associate the subnets created with the network security groups
resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each                  = local.subnets
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}


# // Add routetable to route all traffics via via firewall
# resource "azurerm_route_table" "rt" {
#   name                          = "rt-${var.prefix}-${var.postfix}${var.env}-firewall"
#   resource_group_name           = var.resource_group_name
#   location                      = var.location
#   disable_bgp_route_propagation = false

#   route {
#     name                   = "DefaultRoute"
#     address_prefix         = "0.0.0.0/0"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = var.firewall_private_ip_address
#   }

#   tags = var.tags
#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

# resource "azurerm_subnet_route_table_association" "rt_private_endpoints_subnet_association" {
#   subnet_id      = var.private_endpoints_subnet
#   route_table_id = azurerm_route_table.rt.id
# }