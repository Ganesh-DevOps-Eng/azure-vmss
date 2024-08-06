output "vm_a_id" {
  description = "The ID of the VM"
  value       = azurerm_linux_virtual_machine.vm_a.id
}
output "vm_b__id" {
  description = "The ID of the VM"
  value       = azurerm_linux_virtual_machine.vm_b.id
}

output "postgresql_server_a_id" {
  description = "The ID of the PostgreSQL server in private subnet A"
  value       = azurerm_postgresql_server.psql_a.id
}

output "postgresql_server_b_id" {
  description = "The ID of the PostgreSQL server in private subnet B"
  value       = azurerm_postgresql_server.psql_b.id
}