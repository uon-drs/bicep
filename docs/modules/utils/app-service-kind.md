# utils/app-service-kind

Attempts to resolve the inconsistent structure of App Service `kind` strings with an explicit lookup and a fixed set of valid friendly identifiers.

## Exports

Name | Type | Description
-|-|-
`AppServiceKindDescriptor` | `type` | Enumerates friendly labels for valid App Service `kind`s
`getAppServiceKind` | `function` | Maps an `AppServiceKindDescriptor` value to the correct App Service `kind` string, e.g. `'Linux Web App': 'app,linux'`

## Changelog

### v1

Initial release
