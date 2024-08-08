output "postgresql_server_id" {
  description = "The ID of the PostgreSQL server in private subnet A"
  value       = azurerm_postgresql_server.psql.id
}

output "load_balancer_url" {
  description = "The URL of the load balancer."
  value       = "http://${azurerm_public_ip.public_ip.ip_address}"
}