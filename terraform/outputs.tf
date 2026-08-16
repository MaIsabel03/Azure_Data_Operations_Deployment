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
