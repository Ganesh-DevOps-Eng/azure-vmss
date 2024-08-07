output "vnet_id" {
  value = module.vpc.vnet_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_a_id" {
  value = module.vpc.private_subnet_a_id
}

output "private_subnet_b_id" {
  value = module.vpc.private_subnet_b_id
}

output "postgresql_server_id" {
  value = module.vm_machine.postgresql_server_id
}


output "name" {
  value = azurerm_resource_group.pilot.name
}

output "location" {
  value = azurerm_resource_group.pilot.location
}

output "load_balancer_url" {
  value = module.vm_machine.load_balancer_url
}