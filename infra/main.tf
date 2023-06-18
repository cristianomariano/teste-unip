# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.6.0"
    }
  }
  required_version = ">= 0.14.9"
}
provider "azurerm" {
  features {}
}

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "learn-bf29d7cd-aa73-4c8d-9412-130939b0aec1"
  location = "westus"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-unip-croliveira"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-unip-croliveira"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  #https_only            = true
  site_config { 
  #  minimum_tls_version = "1.2"
    always_on         = false // Required for F1 plan (even though docs say that it defaults to false)
    use_32_bit_worker = true // Required for F1 plan
  }
}