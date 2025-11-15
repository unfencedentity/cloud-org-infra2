provider "azurerm" {
  features {}

  # Disable automatic Resource Provider registration.
  # We will register only what we need manually via Azure CLI.
  skip_provider_registration = true
}
