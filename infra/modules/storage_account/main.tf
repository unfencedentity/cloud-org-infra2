############################################################
# Storage Account module
# - Creates a Storage Account (StorageV2)
# - Optionally enables ADLS Gen2 (hierarchical namespace)
############################################################

variable "name" {
  type        = string
  description = "Globally unique name of the Storage Account."
}

variable "location" {
  type        = string
  description = "Azure region where the Storage Account will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group in which the Storage Account will be created."
}

variable "enable_hns" {
  type        = bool
  description = "Enable hierarchical namespace (ADLS Gen2)."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Storage Account."
  default     = {}
}

resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Security best practices
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true

  # Data Lake Gen2
  is_hns_enabled = var.enable_hns

  tags = var.tags
}

output "storage_account_id" {
  description = "ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the Storage Account."
  value       = azurerm_storage_account.this.name
}
