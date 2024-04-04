// This is a basic VNET module example that supports VNET Integration
// If projects need more complex subnet setups
// they can use this source as a starting point

param vnetName string

param location string = resourceGroup().location

param tags object = {}


resource vnet 'Microsoft.Network/virtualNetworks@2020-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.2.0/24'
      ]
    }
    // Microsoft.Network/virtualNetworks/subnets
    subnets: [
      {
        name: 'Default' // for VM, most clients
        properties: {
          addressPrefix: '10.0.2.0/25'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'Integration' // for App Service VNET Integrations
        properties: {
          addressPrefix: '10.0.2.128/25'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          delegations: [
            {
              name: 'delegation'
              properties:{
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
  tags: union({
    Source: 'Bicep'
  }, tags)
}

output name string = vnet.name
output integrationSubnetId string = vnet.properties.subnets[1].id
