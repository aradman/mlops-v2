# Resource group

module "resource_group" {
  source = "./modules/resource-group"

  location = var.location

  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment

  tags = local.tags
}

# Virtual Network
module "virtual_network" {
  source = "./modules/vnet"

  rg_name  = module.resource_group.name
  location = module.resource_group.location
  
  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment 
  vnet_cidr = "10.0.0.0/16"
}

# Subnets
module "subnet" {
  source = "./modules/subnet"

  rg_name  = module.resource_group.name
  vnet_name = module.virtual_network.name
  pe_subnet_cidr = "10.0.1.0/24"
  training_subnet_cidr = "10.0.2.0/24"
  scoring_subnet_cidr = "10.0.3.0/24"
  management_subnet_cidr = "10.0.4.0/24"
}

# Private endpoint network security group

module "nsg" {
  source = "./modules/nsg"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  pe_subnet_id                        = module.subnet.pe_subnet_id
  training_subnet_id                  = module.subnet.training_subnet_id
  scoring_subnet_id                   = module.subnet.scoring_subnet_id
  management_subnet_id                = module.subnet.management_subnet_id

}

# Private DNS
module "private_dns" {
  source = "./modules/private-dns"

  rg_name  = module.resource_group.name
  vnet_id = module.virtual_network.id
    
}

# Storage account

module "storage_account_aml" {
  source = "./modules/storage-account"

  rg_name  = module.resource_group.name
  location = module.resource_group.location


  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment

  hns_enabled                         = false
  pe_subnet_id                        = module.subnet.pe_subnet_id
  private_dns_zone_blob_id            = module.private_dns.private_dns_zone_blob_id
  private_dns_zone_file_id            = module.private_dns.private_dns_zone_file_id
  firewall_bypass                     = ["AzureServices"]
  firewall_virtual_network_subnet_ids = []

  tags = local.tags
}

# Key vault

module "key_vault" {
  source = "./modules/key-vault"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment
  pe_subnet_id                        = module.subnet.pe_subnet_id
  private_dns_zone_kv_id            = module.private_dns.private_dns_zone_kv_id

  tags = local.tags
}

# Container registry

module "container_registry" {
  source = "./modules/container-registry"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment
  pe_subnet_id                       = module.subnet.pe_subnet_id
  private_dns_zone_acr_id            = module.private_dns.private_dns_zone_acr_id

  tags = local.tags
}

# Azure Machine Learning workspace

module "aml_workspace" {
  source = "./modules/aml-workspace"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment

  storage_account_id      = module.storage_account_aml.id
  key_vault_id            = module.key_vault.id
  application_insights_id = module.application_insights.id
  container_registry_id   = module.container_registry.id

  enable_aml_computecluster = var.enable_aml_computecluster
  storage_account_name      = module.storage_account_aml.name

  pe_subnet_id                       = module.subnet.pe_subnet_id
  private_dns_zone_mlw_api_id            = module.private_dns.private_dns_zone_mlw_api_id
  private_dns_zone_notebook_id            = module.private_dns.private_dns_zone_notebook_id

  tags = local.tags
}

# Application insights

module "application_insights" {
  source = "./modules/application-insights"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  prefix  = var.prefix
  postfix = var.postfix
  env = var.environment

  tags = local.tags
}

# Jumphost
module "jumphost" {
  source = "./modules/jumphost"

  rg_name  = module.resource_group.name
  location = module.resource_group.location

  management_subnet_id              = module.subnet.management_subnet_id
  management_nsg_id                 = module.nsg.management_nsg_id

  jumphost_password                 = var.jumphost_password


}

# module "data_explorer" {
#   source = "./modules/data-explorer"

#   rg_name  = module.resource_group.name
#   location = module.resource_group.location

#   prefix  = var.prefix
#   postfix = var.postfix
#   env = var.environment
#   key_vault_id      = module.key_vault.id
#   enable_monitoring = var.enable_monitoring

#   client_secret = var.client_secret

#   tags = local.tags
# }
