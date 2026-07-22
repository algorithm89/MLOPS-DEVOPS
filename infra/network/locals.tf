locals {
  name_suffix         = "${var.project_name}-${var.environment}"
  resource_group_name = "rg-${local.name_suffix}"

  mgmt_vnet_name = "vnet-mgmt-${var.environment}"
  app_vnet_name  = "vnet-app-${var.environment}"

  mgmt_subnet_name = "subnet-mgmt"
  app_subnet_name  = "subnet-app"

  mgmt_nsg_name = "nsg-mgmt-${var.environment}"
  app_nsg_name  = "nsg-app-${var.environment}"
}
