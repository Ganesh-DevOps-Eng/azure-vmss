resource "azurerm_network_interface_backend_address_pool_association" "nic_vmss" {
  count = var.vm_count

  network_interface_id    = azurerm_network_interface.vm_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.example.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "main" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "http-probe"
  protocol        = "Http"
  request_path    = "/health"
  port            = 8080
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${var.resource_group_name}-scaleset"
  location            = var.location
  resource_group_name = var.resource_group_name

  # automatic rolling upgrade
  automatic_os_upgrade = true
  upgrade_policy_mode  = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  # required when using rolling upgrade policy
  health_probe_id = azurerm_lb_probe.main.id

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "18.04.202301100"
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
      path     = "~/.ssh/authorized_keys"
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
    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = var.private_subnet_b_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

  tags = {
    environment = "staging"
  }
}




resource "azurerm_autoscale_setting" "vmss_autoscale" {
  name                = "autoscale-vmss"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_virtual_machine_scale_set.vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      minimum = 1
      maximum = 10
      default = 2
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 75
        time_grain         = "PT1M"
        time_window        = "PT5M"
        time_aggregation   = "Average"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.vmss.id
        operator           = "LessThan"
        statistic          = "Average"
        threshold          = 25
        time_grain         = "PT1M"
        time_window        = "PT5M"
        time_aggregation   = "Average"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
