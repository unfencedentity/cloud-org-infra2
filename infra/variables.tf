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
