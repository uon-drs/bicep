# components/storage-account

Deploy an Azure Storage Account (v2 Standard), for general use or to back a Function App.

## Parameters

Name | Type | Description | Notes
-|-|-|-
`location` | `string?` | Valid Location for the target Resource(s) | Defaults to Resource Group location
`tags` | `{}` | A dictionary of key value pairs to apply to the resource as Azure Resource Tags | All component modules are already tagged with `Source: Bicep` by default
`baseAccountName` | `string` | Prefix for the storage account name | Keep it short as storage account names have a reasonably low character limit, and the module always adds a 13-character unique string.
`uniqueStringSource` | `string` | A string to hash to create the unique string suffix | Defaults to the ID of the Resource Group. If deploying multiple storage accounts with matching `baseAccountName`, set this to differentiate them, e.g. using an `env` value.
`keyVaultName` | `string?` | Name of a key vault to store connection secrets in | If omitted, secrets will not be stored, only returned directly as outputs.

## Outputs

Name | Type | Description | Notes
-|-|-|-
`name` | `string` | Name of the Storage Account Resource |
`accountName` | `string` | Name of the Storage Account Resource | Used as `AccountName` when connecting, or constructing storage URLs e.g. `https://<accountName>.blob.core.windows.net`
`connectionString` | `string` | The value of a valid Connection String to this Storage Account | Simplest form; doesn't include all service endpoints. Look them up if you need them or get them from the Storage Client library you're using.
`connectionStringKvRef` | `string` | KeyVault Secret Name where the Connection String has been stored | Can be used in `referenceSecret()` when setting environment variables
`accountKey` | `string` | The value of a valid Account Key for this Storage Account AT THE TIME OF DEPLOYMENT | If keys are rotated, any settings dependent on this value will need to be updated.
`accountKeyKvRef` | `string` | KeyVault Secret Name where the Account Key has been stored | If keys are rotated, this KeyVault Secret must be manually updated!


## Changelog

The changelog is very important as published modules are version tagged in the registry.

- Newly published versions must have unique tags so that older projects do not break (they can safely use older versions of published modules)
- The changelog should allow projects to understand which versions of modules they can or cannot use based on their needs
- The changelog may help make clear when updates to a module are warranted, resulting in a new version
- The use of git tags is encouraged to represent commits module versions have been published from. Such a commit should include updated module docs and changelog
    - the git tag format should be:
        - `<module-name>@<version-tag>`
        - bear in mind Module names include their hierarchical path
        - e.g. `config/keyvault-access@v1`

### v1
Initial release