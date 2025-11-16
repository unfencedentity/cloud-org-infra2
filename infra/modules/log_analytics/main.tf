############################################################
# Log Analytics workspace module
############################################################

variable "name" {
  type        = string
  description = "Name of the Log Analytics workspace."
}

variable "location" {
  type        = string
  description = "Azure region where the workspace will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group for the workspace."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the workspace."
  default     = {}
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = var.tags
}

output "id" {
  description = "ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "Workspace ID (used by agents)."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "name" {
  description = "Name of the workspace."
  value       = azurerm_log_analytics_workspace.this.name
}
