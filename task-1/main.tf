provider "azurerm" {
  subscription_id = "------"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "myVM"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1ls"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_password = "YourSecurePassword123"
  disable_password_authentication = false


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_monitor_metric_alert" "cpu_credit_alert" {
  name                = "CPU_Credit_Alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_linux_virtual_machine.vm.id]
  description         = "Alerts when CPU credit is consumed beyond threshold"
  severity            = 2
  frequency           = "PT15M" # Evaluation frequency
  window_size         = "PT15M" # Should be equal or greater than frequency

  dynamic_criteria {
    metric_namespace       = "Microsoft.Compute/virtualMachines"
    metric_name            = "CPU Credits Consumed"
    aggregation            = "Count" # Aggregation type Count
    operator               = "GreaterOrLessThan" # Change to "LessThan" if needed
    alert_sensitivity            = "Medium" # Dynamic threshold sensitivity
    evaluation_total_count = 4 # Number of evaluations before triggering alert
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }
}



resource "azurerm_monitor_action_group" "email_alert" {
  name                = "EmailActionGroup"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "CPUAlert"

  email_receiver {
    name          = "AdminEmail"
    email_address = "-----"
  }
}
