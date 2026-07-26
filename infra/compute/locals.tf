locals {
  jumpbox_name = "vm-jumpbox-${var.environment}"
  app_name     = "vm-app-${var.environment}"

  # Values produced by the network stack, resolved through its state file.
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.location
  mgmt_subnet_id      = data.terraform_remote_state.network.outputs.mgmt_subnet_id
  app_subnet_id       = data.terraform_remote_state.network.outputs.app_subnet_id

  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
}
