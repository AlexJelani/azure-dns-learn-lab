@description('Location for all resources')
param location string = resourceGroup().location

@description('Admin username for the VM')
param adminUsername string = 'adminuser'

@description('SSH public key for VM access')
param sshPublicKey string

@description('Random suffix for unique naming')
param suffix string = uniqueString(resourceGroup().id)

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'az104-vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'internal'
        properties: {
          addressPrefix: '10.1.2.0/24'
        }
      }
    ]
  }
}

// Public IP
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'az104-vm1-ip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'az104-vm1-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1001
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: 'az104-vm1-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'az104-vm1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'az104-vm1'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// Recovery Services Vault
resource vault 'Microsoft.RecoveryServices/vaults@2023-01-01' = {
  name: 'az104-vault-${suffix}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    securitySettings: {
      softDeleteSettings: {
        softDeleteState: 'Enabled'
      }
    }
  }
}

// Backup Policy
resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = {
  parent: vault
  name: 'az104-backup-policy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2023-01-01T23:00:00Z'
      ]
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2023-01-01T23:00:00Z'
        ]
        retentionDuration: {
          count: 10
          durationType: 'Days'
        }
      }
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
          'Wednesday'
          'Friday'
          'Saturday'
        ]
        retentionTimes: [
          '2023-01-01T23:00:00Z'
        ]
        retentionDuration: {
          count: 42
          durationType: 'Weeks'
        }
      }
      monthlySchedule: {
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
            'Wednesday'
          ]
          weeksOfTheMonth: [
            'First'
            'Last'
          ]
        }
        retentionTimes: [
          '2023-01-01T23:00:00Z'
        ]
        retentionDuration: {
          count: 7
          durationType: 'Months'
        }
      }
      yearlySchedule: {
        retentionScheduleFormatType: 'Weekly'
        monthsOfYear: [
          'January'
        ]
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'Last'
          ]
        }
        retentionTimes: [
          '2023-01-01T23:00:00Z'
        ]
        retentionDuration: {
          count: 77
          durationType: 'Years'
        }
      }
    }
  }
}

// VM Backup Protection
resource vmBackup 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2023-01-01' = {
  name: '${vault.name}/Azure/iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vm.name}/vm;iaasvmcontainerv2;${resourceGroup().name};${vm.name}'
  properties: {
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    policyId: backupPolicy.id
    sourceResourceId: vm.id
  }
}

// Outputs
output resourceGroupName string = resourceGroup().name
output vmName string = vm.name
output vmPublicIP string = publicIP.properties.ipAddress
output recoveryVaultName string = vault.name
output backupPolicyName string = backupPolicy.name
output sshConnection string = 'ssh ${adminUsername}@${publicIP.properties.ipAddress}'