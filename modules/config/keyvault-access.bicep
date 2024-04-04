// NOTE: This module currently only works with Vault Access Policies
// so you MUST configure your Key Vault to use that
// under Settings -> Access configuration

// TODO: update to support granting resources access via RBAC

// Vault Access Policies are likely to be deprecated sometime,
// as they are no longer recommended

param keyVaultName string
param tenantId string
param objectId string

resource kv 'Microsoft.KeyVault/vaults@2020-04-01-preview' existing = {
  name: keyVaultName
}

resource kvAccess 'Microsoft.KeyVault/vaults/accessPolicies@2023-02-01' = {
  name: 'add'
  parent: kv
  properties: {
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: objectId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}
