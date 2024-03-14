# Resource group

module "resource_group" {
  source = "./modules/resource-group"

  location = var.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  tags = local.tags
}

# Virtual Network
module "virtual_network" {  
  count  = var.enable_vnet_isolation ? 1 : 0
  source = "./modules/vnet"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  prefix    = var.prefix
  postfix   = var.postfix
  env       = var.environment
  vnet_cidr = var.vnet_cidr

  private_endpoints_subnet = var.private_endpoints_subnet
  # training_subnet          = var.training_subnet
  # scoring_subnet           = var.scoring_subnet
  management_subnet        = var.management_subnet
  bastion_subnet           = var.bastion_subnet
  runner_subnet            = var.runner_subnet
  tags                     = local.tags

  exisiting_hub_vnet_id                  = var.exisiting_hub_vnet_id
  exisiting_hub_vnet_name                = var.exisiting_hub_vnet_name
  # exisiting_hub_vnet_resource_group_name = var.exisiting_hub_vnet_resource_group_name
  # firewall_private_ip_address            = var.firewall_private_ip_address
}

# Bastion
module "bastion" {
  count  = var.enable_vnet_isolation && var.deploy_bastion? 1 : 0
  source = "./modules/bastion"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  prefix    = var.prefix
  postfix   = var.postfix
  env       = var.environment
   
  bastion_subnet_id        = local.virtual_network.bastion_subnet_id
  tags                     = local.tags
}


# Private DNS
module "private_dns" {
  count  = var.enable_vnet_isolation ? 1 : 0
  source = "./modules/private-dns"

  resource_group_name = module.resource_group.name
  vnet_id             = local.virtual_network.id
}

# Storage account

module "storage_account_aml" {
  source = "./modules/storage-account"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location


  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  hns_enabled                         = false
  private_endpoints_subnet_id         = local.virtual_network.private_endpoints_subnet_id
  private_dns_zone_blob_id            = local.private_dns.private_dns_zone_blob_id
  private_dns_zone_file_id            = local.private_dns.private_dns_zone_file_id
  firewall_bypass                     = ["AzureServices"]
  firewall_virtual_network_subnet_ids = []

  tags = local.tags
}

# Key vault

module "key_vault" {
  source = "./modules/key-vault"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  prefix                      = var.prefix
  postfix                     = var.postfix
  env                         = var.environment
  private_endpoints_subnet_id = local.virtual_network.private_endpoints_subnet_id
  # private_dns_zone_kv_id      = local.private_dns.private_dns_zone_kv_id

  tags = local.tags
}

# Container registry

module "container_registry" {
  source = "./modules/container-registry"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  prefix                      = var.prefix
  postfix                     = var.postfix
  env                         = var.environment
  private_endpoints_subnet_id = local.virtual_network.private_endpoints_subnet_id
  # private_dns_zone_acr_id     = local.private_dns.private_dns_zone_acr_id

  tags = local.tags
}

# Azure Machine Learning workspace

module "aml_workspace" {
  source = "./modules/aml-workspace"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  storage_account_id      = module.storage_account_aml.id
  key_vault_id            = module.key_vault.id
  application_insights_id = module.application_insights.id
  container_registry_id   = module.container_registry.id

  enable_aml_computecluster = var.enable_aml_computecluster
  enable_vnet_isolation     = var.enable_vnet_isolation

  storage_account_name      = module.storage_account_aml.name

  private_endpoints_subnet_id     = local.virtual_network.private_endpoints_subnet_id
  private_dns_zone_mlw_api_id     = local.private_dns.private_dns_zone_mlw_api_id
  private_dns_zone_notebook_id    = local.private_dns.private_dns_zone_notebook_id
  private_dns_zone_azuremlcert_id = local.private_dns.private_dns_zone_azuremlcert_id

  scoring_cluster    = var.aml_compute_clusters.scoring
  training_cluster   = var.aml_compute_clusters.training
  # scoring_subnet_id  = local.virtual_network.scoring_subnet_id
  # training_subnet_id = local.virtual_network.training_subnet_id

  tags = local.tags
}

# Application insights

module "application_insights" {
  source = "./modules/application-insights"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env     = var.environment

  tags = local.tags
}

# Jumphost
module "jumphost" {
  count  = var.enable_vnet_isolation && var.deploy_jumphost ? 1 : 0
  source = "./modules/jumphost"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  management_subnet_id = local.virtual_network.management_subnet_id
  # key_vault_id         = local.key_vault.id
}

# Jumphost
module "runner" {
  count  = var.enable_vnet_isolation ? 1 : 0
  source = "./modules/runner"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  runner_subnet_id     = local.virtual_network.runner_subnet_id
  repository           = var.repository
  access_token         = var.access_token
  runner_name          = var.runner_name
  # key_vault_id         = local.key_vault.id
}

# module "data_explorer" {
#   source = "./modules/data-explorer"

#   resource_group_name  = module.resource_group.name
#   location = module.resource_group.location

#   prefix  = var.prefix
#   postfix = var.postfix
#   env = var.environment
#   key_vault_id      = module.key_vault.id
#   enable_monitoring = var.enable_monitoring

#   client_secret = var.client_secret

#   tags = local.tags
# }
