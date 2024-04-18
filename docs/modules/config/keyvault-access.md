# config/keyvault-access

This module configures access to an _existing_ Key Vault via Access Policies.

- It can grant access to any object (i.e. an app or user?) in a given Azure AD Tenant.
- It only grants access to **GET** (not LIST or any write access) **Secrets** (not Certs or Keys).
- This version is for Access Policies only, not RBAC.
    - Access Policies are legacy; a future module release will use RBAC instead.

## Parameters

Name | Type | Description | Notes
-|-|-|-
`keyVaultName` | `string` | Name of an existing Key Vault to grant access to |
`tenantId` | `string` | ID of the Azure AD Tenant containing the Object to be granted access |
`objectId` | `string` | ID of the Object to grant access to. e.g. A User, Application or Service Principal. | Typically in Bicep we are granting a deployed Application access via Managed Identity.

## Changelog

### v1
Initial release