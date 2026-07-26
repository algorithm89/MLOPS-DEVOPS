terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Remote state in Azure Storage so local runs and the CI pipeline share
  # the same state file. State lives in its own resource group (super-bublik)
  # separate from the lab resources, so destroying the lab never touches it.
  backend "azurerm" {
    resource_group_name  = "super-bublik"
    storage_account_name = "skynetstorage2"
    container_name       = "tfstate"
    key                  = "network.terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}
