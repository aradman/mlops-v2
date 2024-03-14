resource "azurerm_machine_learning_workspace" "mlw" {
  name                          = "mlw-${var.prefix}-${var.postfix}${var.env}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  application_insights_id       = var.application_insights_id
  key_vault_id                  = var.key_vault_id
  storage_account_id            = var.storage_account_id
  container_registry_id         = var.container_registry_id
  public_network_access_enabled = var.enable_vnet_isolation ? false : true
  
  sku_name = "Basic"

  identity {
    type = "SystemAssigned"
  }

  managed_network {
    isolation_mode = "AllowInternetOutbound"
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_private_endpoint" "mlw_api_private_endpoint_with_dns" {
  count               =  var.enable_vnet_isolation ? 1 : 0
  name                = "${azurerm_machine_learning_workspace.mlw.name}-plink"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "${azurerm_machine_learning_workspace.mlw.name}-plink-conn"
    private_connection_resource_id = azurerm_machine_learning_workspace.mlw.id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
  }

  private_dns_zone_group {
    name                 = "privatednszonegroup"
    private_dns_zone_ids = [var.private_dns_zone_mlw_api_id, var.private_dns_zone_notebook_id, var.private_dns_zone_azuremlcert_id]
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# # Compute cluster

# resource "azurerm_machine_learning_compute_cluster" "training_cluster" {
#   count                         = var.enable_aml_computecluster ? 1 : 0
#   name                          = var.training_cluster.name
#   location                      = var.location
#   vm_priority                   = var.training_cluster.vm_priority
#   vm_size                       = var.training_cluster.vm_size
#   machine_learning_workspace_id = azurerm_machine_learning_workspace.mlw.id
#   subnet_resource_id            = var.enable_vnet_isolation ? var.training_subnet_id : null

#   scale_settings {
#     min_node_count                       = var.training_cluster.min_nodes
#     max_node_count                       = var.training_cluster.max_nodes
#     scale_down_nodes_after_idle_duration = var.training_cluster.scale_down_nodes_after_idle_duration
#   }
# }

# # Datastore

# resource "azurerm_resource_group_template_deployment" "arm_aml_create_datastore" {
#   name                = "arm_aml_create_datastore"
#   resource_group_name = var.resource_group_name
#   deployment_mode     = "Incremental"
#   parameters_content = jsonencode({
#     "WorkspaceName" = {
#       value = azurerm_machine_learning_workspace.mlw.name
#     },
#     "StorageAccountName" = {
#       value = var.storage_account_name
#     }
#   })

#   depends_on = [time_sleep.wait_30_seconds]

#   template_content = <<TEMPLATE
# {
#   "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
#   "contentVersion": "1.0.0.0",
#   "parameters": {
#         "WorkspaceName": {
#             "type": "String"
#         },
#         "StorageAccountName": {
#             "type": "String"
#         }
#     },
#   "resources": [
#         {
#             "type": "Microsoft.MachineLearningServices/workspaces/datastores",
#             "apiVersion": "2021-03-01-preview",
#             "name": "[concat(parameters('WorkspaceName'), '/default')]",
#             "dependsOn": [],
#             "properties": {
#                 "contents": {
#                     "accountName": "[parameters('StorageAccountName')]",
#                     "containerName": "default",
#                     "contentsType": "AzureBlob",
#                     "credentials": {
#                       "credentialsType": "None"
#                     },
#                     "endpoint": "core.windows.net",
#                     "protocol": "https"
#                   },
#                   "description": "Default datastore for mlops-tabular",
#                   "isDefault": false,
#                   "properties": {
#                     "ServiceDataAccessAuthIdentity": "None"
#                   },
#                   "tags": {}
#                 }
#         }
#   ]
# }
# TEMPLATE
# }

# resource "time_sleep" "wait_30_seconds" {

#   depends_on = [
#     azurerm_machine_learning_workspace.mlw
#   ]

#   create_duration = "30s"
# }
