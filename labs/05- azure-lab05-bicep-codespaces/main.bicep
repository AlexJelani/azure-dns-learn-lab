// main.bicep  ← Save exactly this file
targetScope = 'subscription'

@description('Location')
param location string = 'eastus'

@description('Resource group')
param rgName string = 'az104-rg5'

@secure()
@description('VM admin password')
param adminPassword string

var adminUsername = 'localadmin'

// Create RG
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}

// === Core Services VNet + Subnet + NIC + VM ===
resource coreVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'CoreServicesVnet'
  location: location
  resourceGroup: rgName
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [
      {
        name: 'CoreSubnet'
        properties: { addressPrefix: '10.0.0.0/24' }
      }
    ]
  }
}

resource coreNIC 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'CoreServicesVM-nic'
  location: location
  resourceGroup: rgName
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: '${coreVnet.id}/subnets/CoreSubnet' }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource coreVM 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'CoreServicesVM'
  location: location
  resourceGroup: rgName
  properties: {
    hardwareProfile: { vmSize: 'Standard_DS2_v3' }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: { storageAccountType: 'Premium_LRS' }
      }
    }
    osProfile: {
      computerName: 'CoreServicesVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [{ id: coreNIC.id }]
    }
  }
}

// === Manufacturing VNet + Subnet + NIC + VM ===
resource manufacturingVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'ManufacturingVnet'
  location: location
  resourceGroup: rgName
  properties: {
    addressSpace: { addressPrefixes: ['172.16.0.0/16'] }
    subnets: [
      {
        name: 'ManufacturingSubnet'
        properties: { addressPrefix: '172.16.0.0/24' }
      }
    ]
  }
}

resource manufacturingNIC 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'ManufacturingVM-nic'
  location: location
  resourceGroup: rgName
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: '${manufacturingVnet.id}/subnets/ManufacturingSubnet' }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource manufacturingVM 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'ManufacturingVM'
  location: location
  resourceGroup: rgName
  properties: {
    hardwareProfile: { vmSize: 'Standard_DS2_v3' }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: { storageAccountType: 'Premium_LRS' }
      }
    }
    osProfile: {
      computerName: 'ManufacturingVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [{ id: manufacturingNIC.id }]
    }
  }
}

// === VNet Peering (Bidirectional) ===
resource peering1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'CoreServicesVnet/ManufacturingVnet-to-CoreServicesVnet'
  resourceGroup: rgName
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    remoteVirtualNetwork: { id: manufacturingVnet.id }
  }
}

resource peering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: 'ManufacturingVnet/CoreServicesVnet-to-ManufacturingVnet'
  resourceGroup: rgName
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    remoteVirtualNetwork: { id: coreVnet.id }
  }
}

// === Perimeter Subnet ===
resource perimeterSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: coreVnet
  name: 'perimeter'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

// === Route Table + Route + Association ===
resource routeTable 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-CoreServices'
  location: location
  resourceGroup: rgName
  properties: {
    disableBgpRoutePropagation: true
  }
}

resource customRoute 'Microsoft.Network/routeTables/routes@2023-09-01' = {
  parent: routeTable
  name: 'PerimetertoCore'
  properties: {
    addressPrefix: '10.0.0.0/16'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.1.7'
  }
}

resource routeTableAssociation 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: coreVnet
  name: 'CoreSubnet/routeTableAssociation'
  properties: {
    routeTable: { id: routeTable.id }
  }
  dependsOn: [customRoute]
}

// === Outputs ===
output corePrivateIP string = coreNIC.properties.ipConfigurations[0].properties.privateIPAddress
output manufacturingPrivateIP string = manufacturingNIC.properties.ipConfigurations[0].properties.privateIPAddress
output testCommand string = 'Test-NetConnection ${coreNIC.properties.ipConfigurations[0].properties.privateIPAddress} -Port 3389'
