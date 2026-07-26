# The network stack must be applied first. This reads its outputs rather than
# duplicating resource group and subnet naming logic here.
data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = var.network_state_path
  }
}
