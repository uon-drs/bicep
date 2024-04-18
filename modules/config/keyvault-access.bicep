// Grant Read only access to Key Vault Secrets only via RBAC

// NOTE: Whoever runs this must have rights to grant RBAC Roles
// This is easiest achieved by being an 'Owner' on the RG,
// or at least the Key Vault resource.
// 'Role Based Access Control Administrator' should also work

// https://www.azadvertizer.net/azrolesadvertizer_all.html is useful
// for finding role id's.

param keyVaultName string
param principalId string

var roleId = '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource keyVaultAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, keyVaultName, roleId, principalId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
