terraform {
  required_version = ">= 1.9.2"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  subscription_id = "3c828e3e-a2fc-44f2-b3d2-abcce0792d79"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "azuread" {
  # Configuration options
}
