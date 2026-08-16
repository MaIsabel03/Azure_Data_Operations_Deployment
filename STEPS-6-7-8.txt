##############################################
# STEP 6 — PUBLIC IP (Marcela)
##############################################

resource "azurerm_public_ip" "public_ip" {
  name                = "CIS624-Team6-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    owners = local.owners
  }
}

##############################################
# STEP 7 — NSG WITH RULES (Marcela)
##############################################

resource "azurerm_network_security_group" "nsg" {
  name                = "CIS624-Team6-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow SSH (port 22)
  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow Python web server (port 8080)
  security_rule {
    name                       = "allow_web_8080"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    owners = local.owners
  }
}

##############################################
# STEP 8 — ATTACH NSG TO NIC (Marcela)
##############################################

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
