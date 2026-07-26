variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider. You can also set ARM_SUBSCRIPTION_ID instead."
  type        = string
  default     = null
}

variable "project_name" {
  description = "Short project name used in Azure resource names."
  type        = string
  default     = "terraform-lab"
}

variable "environment" {
  description = "Environment suffix used in Azure resource names."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "allowed_ssh_source_ip" {
  description = "Your trusted public IPv4 address or CIDR block allowed to SSH to the future jumpbox VM."
  type        = string
  default     = "0.0.0.0/0"
}

variable "mgmt_vnet_address_space" {
  description = "Address space for the management virtual network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "app_vnet_address_space" {
  description = "Address space for the application virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "mgmt_subnet_prefixes" {
  description = "Address prefixes for the management subnet."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "app_subnet_prefixes" {
  description = "Address prefixes for the application subnet."
  type        = list(string)
  default     = ["10.20.1.0/24"]
}

variable "expose_app_publicly" {
  description = "Allow inbound TCP 8080 to the app subnet from the internet. Required for browsing the frontend without the jumpbox."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
  default = {
    project     = "terraform-lab"
    environment = "dev"
    managed_by  = "terraform"
  }
}
