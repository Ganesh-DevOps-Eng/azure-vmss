resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "public_subnet" {
  name                 = var.public_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet_prefix]
}

resource "azurerm_subnet" "private_subnet_a" {
  name                 = var.private_subnet_a_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_a_prefix]
}

resource "azurerm_subnet" "private_subnet_b" {
  name                 = var.private_subnet_b_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_subnet_b_prefix]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]  # Choose an appropriate prefix for the Bastion subnet
}


resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "${var.resource_group_name}-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_subnet_nat_gateway_association" "public_subnet_nat_gateway" {
  subnet_id       = azurerm_subnet.public_subnet.id
  nat_gateway_id  = azurerm_nat_gateway.nat_gateway.id
}
