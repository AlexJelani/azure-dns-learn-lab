param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'publicsubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          routeTable: {
            id: routeTable.id
          }
        }
      }
      {
        name: 'privatesubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'dmzsubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'publictable'
  location: location
  properties: {
    bgpRoutePropagationEnabled: true
    routes: [
      {
        name: 'productionsubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.2.4'
        }
      }
    ]
  }
}