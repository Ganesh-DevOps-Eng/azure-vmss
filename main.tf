provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "pilot" {
  name     = var.resource_group_name
  location = var.location
}
module "vpc" {
  source               = "./module/vpc"
  vnet_name            = var.vnet_name
  address_space        = var.address_space
  location             = var.location
  resource_group_name  = var.resource_group_name
  public_subnet_name   = var.public_subnet_name
  public_subnet_prefix = var.public_subnet_prefix
  private_subnet_a_name = var.private_subnet_a_name
  private_subnet_a_prefix = var.private_subnet_a_prefix
  private_subnet_b_name = var.private_subnet_b_name
  private_subnet_b_prefix = var.private_subnet_b_prefix
  depends_on = [azurerm_resource_group.pilot]

}

module "vm_machine" {
  source               = "./module/vm_machine"
  location             = var.location
  resource_group_name  = var.resource_group_name
  private_subnet_a_id            = module.vpc.private_subnet_a_id
  private_subnet_b_id            = module.vpc.private_subnet_b_id
  virtual_network_id = module.vpc.vnet_id
  vm_name              = "ubuntu-vm"
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  admin_password       = var.admin_password  
    depends_on = [
    module.vpc
  ]

}


module "bastion" {
  source               = "./module/bastion"
  location             = var.location
  resource_group_name  = var.resource_group_name
  subnet_id            = module.vpc.bastion_subnet_id
  dns_name             = var.dns_name
      depends_on = [
    module.vm_machine
  ]
}
