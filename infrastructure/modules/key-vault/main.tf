data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                          = "kv-${var.prefix}-${var.postfix}${var.env}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  public_network_access_enabled = var.enable_vnet_isolation ? false : true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

# resource "azurerm_private_endpoint" "kv_private_endpoint_with_dns" {
#   count               = var.enable_vnet_isolation ? 1 : 0
#   name                = "${azurerm_key_vault.kv.name}-plink"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.private_endpoints_subnet_id

#   private_service_connection {
#     name                           = "${azurerm_key_vault.kv.name}-plink-conn"
#     private_connection_resource_id = azurerm_key_vault.kv.id
#     is_manual_connection           = false
#     subresource_names              = ["vault"]
#   }

#   private_dns_zone_group {
#     name                 = "privatednszonegroup"
#     private_dns_zone_ids = [var.private_dns_zone_kv_id]
#   }

#   tags = var.tags
#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }
