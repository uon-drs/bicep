# config/keyvault-access

This module configures access to an _existing_ Key Vault via RBAC.

- It can grant access to any Service Principal in the Key Vault's Azure AD Tenant.
    - Future versions may offer more Principal types, but this suits our current usage (granting access to Managed Identities for Application deployed via Bicep).
- It only grants read-only access **Secrets** (not Certs or Keys).
    - This is because it always assigns the role `Key Vault Secrets User` currently.
    - Future versions may offer more options, but this suits our current usage.
- This version is for RBAC only, not Key Vault Access Policies.
    - Access Policies are legacy, and will eventually be deprecated in Azure.

## Parameters

Name | Type | Description | Notes
-|-|-|-
`keyVaultName` | `string` | Name of an existing Key Vault to grant access to |
`principalId` | `string` | ID of a Service Principal to grant access to |

## Changelog

### v2
- Grants access via RBAC
- Access Policies are no longer supported.
    - If you have an existing Key Vault secured by Access Policies:
        - Use `v1` of this module, or
        - Migrate the Key Vault to use RBAC.
- Added module parameters:
    - `principalId` - renamed from `objectId`
- Removed module parameters:
    - `tenantId`
    - `objectId` - renamed to `objectId`

### v1
Initial release