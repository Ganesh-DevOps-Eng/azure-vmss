#resource "azurerm_public_ip" "public_ip" {
#  name                = "${var.resource_group_name}-public-ip"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  allocation_method   = "Static"
#  sku                 = "Standard"
#}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "${var.resource_group_name}-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
}

 #resource "azurerm_nat_gateway_public_ip_association" "main" {
 #  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
 #  public_ip_address_id = azurerm_public_ip.public_ip.id
 #}

resource "azurerm_subnet_nat_gateway_association" "public_subnet_nat_gateway" {
  subnet_id       = azurerm_subnet.public_subnet.id
  nat_gateway_id  = azurerm_nat_gateway.nat_gateway.id
}
