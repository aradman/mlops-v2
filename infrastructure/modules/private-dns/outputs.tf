output "private_dns_zone_aml_api_id" {
  value = azurerm_private_dns_zone.private_dns_zone_aml_api.id
}

output "private_dns_zone_notebook_id" {
  value = azurerm_private_dns_zone.private_dns_zone_notebook.id
}

output "private_dns_zone_kv_id" {
  value = azurerm_private_dns_zone.private_dns_zone_kv.id
}

output "private_dns_zone_blob_id" {
  value = azurerm_private_dns_zone.private_dns_zone_blob.id
}

output "private_dns_zone_file_id" {
  value = azurerm_private_dns_zone.private_dns_zone_file.id
}

output "private_dns_zone_acr_id" {
  value = azurerm_private_dns_zone.private_dns_zone_acr.id
}