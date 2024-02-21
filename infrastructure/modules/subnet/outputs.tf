output "pe_subnet_id" {
  value = azurerm_subnet.pe_subnet.id
}

output "training_subnet_id" {
  value = azurerm_subnet.training_subnet.id
}

output "scoring_subnet_id" {
  value = azurerm_subnet.scoring_subnet.id
}

output "management_subnet_id" {
  value = azurerm_subnet.management_subnet.id
}