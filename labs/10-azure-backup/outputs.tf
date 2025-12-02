output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "recovery_vault_name" {
  description = "Name of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.main.name
}

output "backup_policy_name" {
  description = "Name of the backup policy"
  value       = azurerm_backup_policy_vm.main.name
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh adminuser@${azurerm_public_ip.main.ip_address}"
}