# utils/functions

Contains useful helper functions, either used by other published modules, or available for import in your own modules.

## Exports

Name | Type | Description
-|-|-
[`referenceSecret`](#referencesecret) | `function` | Builds the `AppSettings` string to reference a given KeyVault Secret
`getDotNetVersion` | `function` | Used by `config/base/app-service` to convert an `appFramework` string e.g. `DOTNETCORE\|8.0` to a `netFrameworkVersion` string

### `referenceSecret`

```bicep
referenceSecret(vaultName, secretName)
```

#### Arguments
Name | Type | Description
-|-|-
`vaultName` | `string` | The name of the KeyVault resource
`secretName` | `string` | The name of the KeyVault Secret

#### Returns
Type | Description
-|-
`string` | The correctly formatted `string` for referencing a KeyVault Secret in a `sites/config` `AppSettings` environment variable.

##### Example

```bicep
'@Microsoft.KeyVault(VaultName=${vaultName};SecretName=${secretName})'
```

## Changelog

### v1

Initial release
