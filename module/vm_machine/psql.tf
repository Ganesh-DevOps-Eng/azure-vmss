# PostgreSQL Server A
resource "azurerm_postgresql_server" "psql_a" {
  name                = "${var.resource_group_name}-psqlserver-a"
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# Private Endpoint for PostgreSQL Server A
resource "azurerm_private_endpoint" "psql_private_endpoint_a" {
  name                = "${var.resource_group_name}-psql-private-endpoint-a"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_a_id

  private_service_connection {
    name                           = "${var.resource_group_name}-psql-private-connection-a"
    private_connection_resource_id = azurerm_postgresql_server.psql_a.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

# PostgreSQL Server B
resource "azurerm_postgresql_server" "psql_b" {
  name                = "${var.resource_group_name}-psqlserver-b"
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# Private Endpoint for PostgreSQL Server B
resource "azurerm_private_endpoint" "psql_private_endpoint_b" {
  name                = "${var.resource_group_name}-psql-private-endpoint-b"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_b_id

  private_service_connection {
    name                           = "${var.resource_group_name}-psql-private-connection-b"
    private_connection_resource_id = azurerm_postgresql_server.psql_b.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "postgresql" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}


# DNS A Record for PostgreSQL Server A
resource "azurerm_private_dns_a_record" "postgresql_a" {
  name                = "pilot-psqlserver-a"
  zone_name           = azurerm_private_dns_zone.postgresql.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.psql_private_endpoint_a.private_service_connection[0].private_ip_address]
}

# DNS A Record for PostgreSQL Server B
resource "azurerm_private_dns_a_record" "postgresql_b" {
  name                = "pilot-psqlserver-b"
  zone_name           = azurerm_private_dns_zone.postgresql.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.psql_private_endpoint_b.private_service_connection[0].private_ip_address]
}


# Link the private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "Vnet_DNS" {
  name                  = "test"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = var.virtual_network_id
}