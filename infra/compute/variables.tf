variable "subscription_id" {
  description = "Azure subscription ID used by the AzureRM provider. You can also set ARM_SUBSCRIPTION_ID instead."
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment suffix used in Azure resource names. Must match the network stack."
  type        = string
  default     = "dev"
}

variable "network_state_path" {
  description = "Path to the network stack's local state file, read for the resource group and subnet IDs."
  type        = string
  default     = "../network/terraform.tfstate"
}

variable "vm_size" {
  description = "Azure VM size for both lab VMs. B-series burstable sizes keep the lab cheap."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Linux admin user created on both VMs."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key authorized on both VMs. Generate one with ssh-keygen if you do not have it."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "jumpbox_private_ip" {
  description = "Static private IP for the jumpbox VM. Must sit inside mgmt_subnet_prefixes."
  type        = string
  default     = "10.10.1.10"
}

variable "app_private_ip" {
  description = "Static private IP for the app VM. Must sit inside app_subnet_prefixes."
  type        = string
  default     = "10.20.1.10"
}

variable "app_public_ip_enabled" {
  description = "Attach a public IP to the app VM so the frontend can be browsed directly. Set false to revert to jumpbox-only access."
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
