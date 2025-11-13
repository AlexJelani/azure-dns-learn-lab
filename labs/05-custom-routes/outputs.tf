output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.main.name
}

output "route_table_name" {
  value = azurerm_route_table.public.name
}

output "subnets" {
  value = {
    public  = azurerm_subnet.public.address_prefixes[0]
    private = azurerm_subnet.private.address_prefixes[0]
    dmz     = azurerm_subnet.dmz.address_prefixes[0]
  }
}