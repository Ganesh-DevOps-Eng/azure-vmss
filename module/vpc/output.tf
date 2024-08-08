output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "private_subnet_a_id" {
  value = azurerm_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  value = azurerm_subnet.private_subnet_b.id
}
output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}