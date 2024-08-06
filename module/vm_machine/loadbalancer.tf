resource "azurerm_public_ip" "public_ip" {
  name                = "${var.resource_group_name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_lb" "load_balancer" {
  name                = "${var.resource_group_name}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "BackendPool"
  loadbalancer_id     = azurerm_lb.load_balancer.id
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "LoadBalancerRule"
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}
