// Azure DNS Lab - Bicep Configuration
targetScope = 'subscription'

param location string = 'japaneast'
param dnsZoneName string = 'wideworldimports111125.com'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'learn-dns-rg'
  location: location
}

module dns 'dns.bicep' = {
  name: 'dns-deployment'
  scope: rg
  params: {
    dnsZoneName: dnsZoneName
  }
}

output nameServer string = dns.outputs.nameServer
output verificationCommand string = dns.outputs.verificationCommand