output "pe_nsg_id" {
  value = azurerm_network_security_group.pe_nsg.id
}

output "training_nsg_id" {
  value = azurerm_network_security_group.training_nsg.id
}

output "scoring_nsg_id" {
  value = azurerm_network_security_group.scoring_nsg.id
}

output "management_nsg_id" {
  value = azurerm_network_security_group.management_nsg.id
}