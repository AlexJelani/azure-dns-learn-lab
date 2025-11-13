param location string = resourceGroup().location
param vnetName string = 'vnet'
param publicSubnetName string = 'publicsubnet'
param privateSubnetName string = 'privatesubnet'
param dmzSubnetName string = 'dmzsubnet'
param vnetAddressPrefix string = '10.0.0.0/16'
param publicSubnetAddressPrefix string = '10.0.0.0/24'
param privateSubnetAddressPrefix string = '10.0.1.0/24'
param dmzSubnetAddressPrefix string = '10.0.2.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: publicSubnetName
        properties: {
          addressPrefix: publicSubnetAddressPrefix
        }
      }
      {
        name: privateSubnetName
        properties: {
          addressPrefix: privateSubnetAddressPrefix
        }
      }
      {
        name: dmzSubnetName
        properties: {
          addressPrefix: dmzSubnetAddressPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output dmzSubnetId string = vnet.properties.subnets[2].id // Assuming dmzSubnet is the third one in the array
