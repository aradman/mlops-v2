resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}-${var.postfix}${var.env}"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = [var.vnet_cidr]
  tags = var.tags
    
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
