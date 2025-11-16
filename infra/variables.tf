############################################################
# Input variables for the cloud-org-infra2 Terraform stack
############################################################

variable "subscription_id" {
  description = "The Azure subscription ID where resources will be deployed."
  type        = string
  default     = null
}

variable "location" {
  description = "Default Azure region for resources."
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Environment name (e.g. dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used as a prefix for resource naming."
  type        = string
  default     = "cloud-org-infra2"
}

variable "default_tags" {
  description = "Default tags applied to all supported resources."
  type        = map(string)
  default = {
    project     = "cloud-org-infra2"
    owner       = "data-platform-team"
    environment = "dev"
  }
}

############################################################
# Networking configuration
############################################################

variable "vnet_address_space" {
  description = "Address space for the core virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnets" {
  description = "Subnets to create inside the core virtual network."
  type = map(object({
    address_prefix = string
  }))

  default = {
    mgmt = {
      address_prefix = "10.10.1.0/24"
    }
    workload = {
      address_prefix = "10.10.2.0/24"
    }
    data = {
      address_prefix = "10.10.3.0/24"
    }
    private = {
      address_prefix = "10.10.4.0/24"
    }
  }
}

############################################################
# Storage account configuration
############################################################

variable "storage_account_name" {
  description = "Globally unique name for the Storage Account."
  type        = string
}

variable "storage_account_enable_hns" {
  description = "Enable hierarchical namespace (ADLS Gen2)."
  type        = bool
  default     = true
}

############################################################
# Key Vault configuration
############################################################

variable "key_vault_name" {
  description = "Globally unique name for the Azure Key Vault (letters and numbers only)."
  type        = string
}

############################################################
# Log Analytics Workspace
############################################################

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

variable "enable_storage_diagnostics" {
  description = "Enable diagnostic settings for the storage account."
  type        = bool
  default     = true
}
