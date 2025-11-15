output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.lab.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.lab.name
}

output "storage_account_primary_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.lab.primary_blob_endpoint
}

output "blob_container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.data.name
}

output "file_share_name" {
  description = "Name of the file share"
  value       = azurerm_storage_share.share1.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.lab.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.lab.name
}