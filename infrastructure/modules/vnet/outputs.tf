output "id" {
  value = azurerm_virtual_network.vnet.id
}
output "name" {
  value = azurerm_virtual_network.vnet.name
}
output "private_endpoints_subnet_id" {
  value = azurerm_subnet.subnet["private_endpoints"].id
}

# output "training_subnet_id" {
#   value = azurerm_subnet.subnet["training"].id
# }

# output "scoring_subnet_id" {
#   value = azurerm_subnet.subnet["scoring"].id
# }

output "management_subnet_id" {
  value = azurerm_subnet.subnet["management"].id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.subnet["bastion"].id
}

output "runner_subnet_id" {
  value = azurerm_subnet.subnet["runner"].id
}
