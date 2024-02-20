resource "azurerm_network_security_group" "pe_nsg" {  
  name                = "pe-nsg"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Inbound Rules

# Outbound Rules
resource "azurerm_network_security_rule" "pe_out_deny_all" {
  name      = "pe_out_deny_all"
  priority  = 110
  direction = "Outbound"
  access    = "Deny"
  protocol  = "*"

  source_port_range     = "*"
  source_address_prefix = "*"

  destination_port_range     = "*"
  destination_address_prefix = "*"

  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.pe_nsg.name

  depends_on = [
    azurerm_network_security_group.pe_nsg,
  ]
}

# Associate NSG with subnet

resource "azurerm_subnet_network_security_group_association" "pe_nsg" {
  subnet_id                 = var.pe_subnet_id
  network_security_group_id = azurerm_network_security_group.pe_nsg.id

  # The subnet will refuse to accept the NSG if it's not this exact
  # list so we need to ensure the rules are deployed before the association
  depends_on = [
    azurerm_network_security_rule.pe_out_deny_all
  ]
  timeouts {}
}
