############################################################
# Diagnostic Settings module
############################################################

variable "name" {
  description = "Name of the diagnostic setting."
  type        = string
}

variable "target_resource_id" {
  description = "Resource ID of the target Azure resource."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace."
  type        = string
}

variable "enabled_logs" {
  description = "List of log categories."
  type        = list(string)
  default     = []
}

variable "enabled_metrics" {
  description = "List of metric categories."
  type        = list(string)
  default     = []
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.enabled_logs
    content {
      category = log.value
      enabled  = true
    }
  }

  dynamic "metric" {
    for_each = var.enabled_metrics
    content {
      category = metric.value
      enabled  = true
    }
  }
}

output "id" {
  description = "ID of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}
