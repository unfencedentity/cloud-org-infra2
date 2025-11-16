############################################################
# Root Terraform configuration for cloud-org-infra2
# - Uses the provider defined in providers.tf
# - Calls the resource_group module
############################################################

locals {
  common_tags = var.default_tags
}

module "rg_core" {
  source   = "./modules/resource_group"
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = local.common_tags
}

############################################################
# Core virtual network
############################################################

module "vnet_core" {
  source = "./modules/vnet"

  name                = "${var.project_name}-${var.environment}-vnet"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  address_space = var.vnet_address_space
  subnets       = var.subnets
  tags          = local.common_tags
}

############################################################
# Network Security Group for management subnet
############################################################

module "nsg_mgmt" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-mgmt-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-mgmt"

  tags = local.common_tags
}

############################################################
# Network Security Group for workload subnet
############################################################

module "nsg_workload" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-workload-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-workload"

  tags = local.common_tags
}

############################################################
# Network Security Group for data subnet
############################################################

module "nsg_data" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-data-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-data"

  tags = local.common_tags
}

############################################################
# Network Security Group for private subnet
############################################################

module "nsg_private" {
  source = "./modules/nsg"

  name                = "${var.project_name}-${var.environment}-private-nsg"
  location            = var.location
  resource_group_name = module.rg_core.resource_group_name

  virtual_network_name = module.vnet_core.vnet_name
  subnet_name          = "snet-private"

  tags = local.common_tags
}

############################################################
# Core Storage Account (ADLS Gen2-ready)
############################################################

module "storage_core" {
  source = "./modules/storage_account"

  name                = var.storage_account_name
  location            = var.location
  resource_group_name = module.rg_core.name
  enable_hns          = var.storage_account_enable_hns

  tags = local.common_tags
}
