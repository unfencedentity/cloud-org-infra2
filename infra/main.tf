############################################################
# Root Terraform configuration for cloud-org-infra2
############################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

module "rg_core" {
  source    = "./modules/resource_group"
  name      = "${var.project_name}-${var.environment}-rg"
  location  = var.location
  tags      = var.default_tags
}
