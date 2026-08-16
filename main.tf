terraform { 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Azure for Students subscription
  subscription_id = "1859a532-3db6-4ef0-8688-eb063096912e"

  # Required for student accounts
  resource_provider_registrations = "none"
}

##############################################
# LOCALS – OWNERS + USERNAME (Reza – Step 1)
##############################################

locals {
  owners = "Group 6 - Marcela Redondo Hernandez; B M Faruq Reza; Selorm Kwaku Soga; Ashish Thapa"

  # STEP 1 — Admin Username (Reza)
  # First letters of first + last name for each student:
  # B M Faruq Reza            -> br
  # Marcela Redondo Hernandez -> mr
  # Selorm Kwaku Soga         -> ss
  # Ashish Thapa              -> at
  admin_username = "brmrssat"
}

##############################################
# STEP 2 — RANDOM PASSWORD (Reza)
##############################################

resource "random_password" "admin" {
  length      = 16
  special     = true
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  min_special = 2
}

##############################################
# RESOURCE GROUP (Unit 6)
##############################################

resource "azurerm_resource_group" "rg" {
  name     = "CIS624-Team6-rg"
  location = "eastus2"

  tags = {
    owners = local.owners
  }
}

##############################################
# VNET + SUBNET (Unit 6)
##############################################

resource "azurerm_virtual_network" "vnet" {
  name                = "CIS624-Team6-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    owners = local.owners
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "CIS624-Team6-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

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
# NETWORK INTERFACE (Unit 6 + Step 6)
##############################################

resource "azurerm_network_interface" "nic" {
  name                = "CIS624-Team6-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    # STEP 6 — Attach public IP so VM is reachable from the internet
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  tags = {
    owners = local.owners
  }
}

##############################################
# STEP 7 — NSG WITH RULES (SSH 22, WEB 8080)
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

#########################################################
# STEP 0 — Create the Linux VM (Marcela)
# STEP 1 — Admin username (Reza) – uses local.admin_username
# STEP 2 — Random password (Reza) – uses random_password.admin.result
# STEP 4 — OS choice (Thapa)
# STEP 5 — Use existing NIC from Unit 6 (Marcela)
#########################################################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "CIS624-Team6-VM"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # ❗ Updated because Standard_B2ats_v2 is NOT available in eastus2
  size                = "Standard_B1s"  # Changed from Standard_B2ats_v2

  # STEP 1 & STEP 2 — Username + random password
  admin_username                  = local.admin_username
  admin_password                  = random_password.admin.result
  disable_password_authentication = false

  # STEP 5 — VM uses the NIC from Unit 6
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  # STEP 4 — OS selection (Ubuntu 22.04 LTS – Thapa)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
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

##############################################
# STEP 3 — Configure Python3 web server (Thapa)
##############################################

resource "null_resource" "configure_webserver" {
  # Make sure the VM is created before we run commands
  depends_on = [azurerm_linux_virtual_machine.vm]

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_linux_virtual_machine.vm.public_ip_address
      user     = local.admin_username
      password = random_password.admin.result
    }

    inline = [
      # Install Python3 (in case it's not installed)
      "sudo apt-get update -y",
      "sudo apt-get install -y python3",

      # Start a simple web server on port 8080 in the background
      "nohup python3 -m http.server 8080 &"
    ]
  }
}

##############################################
# STEP 9 & 10 — Upload TXT file (Selorm update)
##############################################

resource "null_resource" "upload_group6_csv" {
  depends_on = [null_resource.configure_webserver]

  # Upload the TXT file instead of CSV so the browser displays it
  provisioner "file" {
    source      = "${path.module}/group6.txt"
    destination = "/home/${local.admin_username}/group6.txt"
  }

  connection {
    type     = "ssh"
    host     = azurerm_linux_virtual_machine.vm.public_ip_address
    user     = local.admin_username
    password = random_password.admin.result
  }
}

##############################################
# STEP 11 — Output instance IP and password
##############################################

# Public IP address of the Linux VM (shown in plan/apply)
output "vm_public_ip" {
  description = "Public IP address of the Linux VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

# Random admin password for the Linux VM (hidden in plan/apply)
output "vm_admin_password" {
  description = "Random admin password for the Linux VM (sensitive)"
  value       = random_password.admin.result
  sensitive   = true
}
