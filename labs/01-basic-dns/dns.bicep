param dnsZoneName string

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: dnsZoneName
  location: 'global'
}

resource aRecord 'Microsoft.Network/dnsZones/A@2018-05-01' = {
  name: 'www'
  parent: dnsZone
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: '10.10.10.10'
      }
    ]
  }
}

output nameServer string = dnsZone.properties.nameServers[0]
output verificationCommand string = 'nslookup www.${dnsZoneName} ${dnsZone.properties.nameServers[0]}'