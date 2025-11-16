############################################################
# Key Vault module
############################################################

variable "name" {
  type        = string
  description = "Name of the Azure Key Vault."
}

variable "location" {
  type        = string
  description = "Azure region where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group in which the Key Vault will be created."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault."
  default     = {}
}

# Get current tenant (used for Key Vault tenant_id)
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  # Security & governance
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  # For now we leave public access on.
  # Later we'll secure this with private endpoints and firewall rules.
  public_network_access_enabled = true

  tags = var.tags
}

output "id" {
  description = "ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "name" {
  description = "Name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "Vault URI used by applications."
  value       = azurerm_key_vault.this.vault_uri
}
