resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = var.resource_group_name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.load_balancer.id
  protocol                       = "Tcp"
  frontend_port_start            = 5000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}


resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${var.resource_group_name}-scaleset"
  location            = var.location
  resource_group_name = var.resource_group_name

  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"
  lifecycle  {
    create_before_destroy=true
 }

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 50
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  health_probe_id = azurerm_lb_probe.main.id

  sku {
    name     = var.vm_size
    tier     = "Standard"
    capacity = 2
    
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "${var.vm_name}-vm"
    admin_username       = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("C:/Users/cgt_jpr_pc_Admin/.ssh/id_rsa.pub")
    }
  }

  network_profile {
    name    = "${var.vm_name}-networkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = var.private_subnet_a_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "provision" {
  name                         = "provision-scal_set"
  virtual_machine_scale_set_id = azurerm_virtual_machine_scale_set.vmss.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"

  settings = jsonencode({
    "script" = "init_script.sh"
  })

  protected_settings = jsonencode({
    "fileUris"         = ["https://raw.githubusercontent.com/Ganesh-DevOps-Eng/php-postgres/main/init_script.sh"],
    "commandToExecute" = "bash init_script.sh"
  })
}

