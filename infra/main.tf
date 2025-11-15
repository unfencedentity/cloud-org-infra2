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
