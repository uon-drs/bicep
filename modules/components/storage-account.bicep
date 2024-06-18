param location string = resourceGroup().location
param baseAccountName string
param uniqueStringSource string = resourceGroup().id
param keyVaultName string = ''
param tags object = {}

resource storage 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: '${baseAccountName}${uniqueString(uniqueStringSource)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
  }
  tags: union(
    {
      Source: 'Bicep'
    },
    tags
  )
}

var accountKey = storage.listKeys().keys[0].value
var connectionString = 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${accountKey}'

// If a key vault name is specified, store a connection string for this storage account in it
resource kv 'Microsoft.KeyVault/vaults@2020-04-01-preview' existing = if (!empty(keyVaultName)) {
  name: keyVaultName
}
resource connectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = if (!empty(keyVaultName)) {
  name: 'storage-${storage.name}-connection-string'
  parent: kv
  properties: {
    value: connectionString
  }
}
resource accountKeySecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = if (!empty(keyVaultName)) {
  name: 'storage-${storage.name}-account-key'
  parent: kv
  properties: {
    value: accountKey
  }
}

output name string = storage.name
output accountName string = storage.name // to be clearer when setting environment variables etc with this value
output connectionStringKvRef string = empty(keyVaultName) ? '' : connectionStringSecret.name
output connectionString string = connectionString
output accountKeyKvRef string = empty(keyVaultName) ? '' : accountKeySecret.name
output accountKey string = accountKey
