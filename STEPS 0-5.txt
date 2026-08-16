###############################################
# UNIT 7 – STEP #0: CREATE LINUX VIRTUAL MACHINE
# (Includes Step #5 automatically through NIC attachment)
###############################################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "CIS624-Team6-VM"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B2ats_v2"   # Free tier recommended by professor

  # Step #1 and #2 from Reza:
  admin_username = local.admin_username
  admin_password = random_password.admin.result

  disable_password_authentication = false  # Required to allow password login

  # STEP #5 IS COMPLETED HERE:
  # The VM is attached to the network interface created in Unit 6.
  # This automatically provides the NET interface ID required in Step #5.
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # Linux OS for the VM (Step #4 will confirm this matches Thapa’s config)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  tags = {
    owners = local.owners
  }
}
