# Example values for cloud-org-infra2 Terraform stack
# Copy this file to terraform.tfvars and adjust the values for your environment.

subscription_id = "00000000-0000-0000-0000-000000000000"

location    = "westeurope"
environment = "dev"

project_name = "cloud-org-infra2"

default_tags = {
  project     = "cloud-org-infra2"
  owner       = "lucian"
  environment = "dev"
}

storage_account_name       = "cloudorginfra2devsa"
storage_account_enable_hns = true

key_vault_name = "cloudorginfra2devkv"

log_analytics_workspace_name = "cloud-org-infra2-dev-law"
