############################################################
# Terraform & Azure Provider Configuration
# This file configures:
# - The Terraform CLI version required
# - The AzureRM provider (Azure Resource Manager)
# - Default authentication via Azure CLI
############################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.88.0"
    }
  }
}

# Azure provider configuration (using Azure CLI authentication)
provider "azurerm" {
  features {}
}
