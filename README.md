# DRS Bicep

This repo contains reusable Bicep files for DRS projects, as well as documentation and other samples.

Everything in `modules/` is published to a private repository either as a distinct module, or is a base dependency of a published module.

Published modules can then be referenced in your projects without being directly included.

## Non-Module Documentation

The table below describes general documentation available, while below the table there are subheadings for further general documentation.

Doc | Description
-|-
[Intro](docs/intro.md) | Introduction to Bicep usage in DRS
[KeyVaults](docs/keyvaults.md) | Information about DRS use of Azure KeyVault in Bicep and Bicep created resources.

### `bicepconfig.json`

This is an example config file suitable for use in projects that reference the modules in this repo.

## Module Documentation

### Components

These are modules which deploy resources.

- Sometimes multiple related resources that are configured to work with each other.
- Sometimes child resources, if it's appropriate for them to run in the same immediate deployment.

Name | Description
-|-
[`app-service-plan`](docs/modules/components/app-service-plan.md) | Creates a Linux app service plan of a given SKU.
[`app-service`](docs/modules/components/app-service.md) | Creates any kind of App Service. Does some value-add (e.g. AppInsights). Read the docs.
[`log-analytics-workspace`](docs/modules/components/log-analytics-workspace.md) | Creates a Log Analytics Workspace e.g. for AppInsights.
[`managed-cert`](docs/modules/components/managed-cert.md) | Creates a Managed SSL Certificate and binds it to a given hostname for an App Service.
[`storage-account`](docs/modules/components/storage-account.md) | Creates an Azure Storage Account for general use, or Function Apps.
[`vnet`](docs/modules/components/vnet.md) | Creates a basic VNET, optionally suitable for VNET Integration.

### Config

These are modules which deploy a modification or child resource against an already deployed resource.

Name | Description
-|-
[`functionapp`](docs/modules/config/functionapp.md) | Specifies SiteConfig, AppSettings and ConnectionStrings with Function App defaults and valid App Frameworks.
[`webapp`](docs/modules/config/webapp.md) | Specifies SiteConfig, AppSettings and ConnectionStrings with Web App defaults and valid App Frameworks.
[`keyvault-access`](docs/modules/config/keyvault-access.md) | Grants read access to KeyVault Secrets to a given app's Service Principal. This allows that app's AppSettings to reference KeyVault Secrets.

### Utils

These are "non-deployment" modules, in that they don't deploy resources.

Typically they contain exported functions or variables only.

Name | Description
-|-
[`app-service-kind`](docs/modules/utils/app-service-kind.md) | Helpers for App Service `kind` strings
[`functions`](docs/modules/utils/functions.md) | General helper functions for importing
[`types`](docs/modules/utils/types.md) | General type definitions

## Using Modules

### Full documentation:

- [Using modules from a Private Registry](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules#private-module-registry)
- [Configuring Bicep Registry Module Aliases](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config-modules#aliases-for-modules)

### Quick Start

1. Use the `bicepconfig.json` in this repository for an example of defining aliases to the Bicep Registry
1. Declare Modules as you would normally but instead of a relative path, use a Bicep Registry path:
    - e.g. `module myModule 'br/Alias:module-name:v1' = {}`
1. Import Modules as you would normally but instead of a relative path, use a Bicep Registry path:
    - e.g. `import { myExport } from 'br/Alias:module-name:v1'`

> [!TIP]   
> Using the VS Code extension, everything should just work as it automatically restores Registry modules.
>
> **If it doesn't work:**
> - wait a minute for the restore to complete
> - check that aliases are correctly configured and that you have appropriate access to the container registry.
>
> **If not using VS Code** you may have to [restore manually](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli#restore).

## Publishing Modules

> [!IMPORTANT]
> Appropriate permissions are required on the Azure Container Registry in order to publish modules

> [!NOTE]
> The use of git tags is encouraged to represent commits module versions have been published from. Such a commit should include updated modulex docs and changelog

### Example publish command:

```bash
az bicep publish \
--file webapp.bicep \
--target br:<registry-url>/bicep/config/webapp:v1 \
--documentationUri https://github.com/uon-drs/bicep/blob/main/README.md
```

> [!WARNING]
> Remember! 
> - replace the version tag for the registry
> - point at the correct git commit/tag for the README/docs link.

### Publishing new modules

1. Add the module to the correct folder.
1. Add module docs based on the template.
1. Add the module docs link to the README.
1. Push to a branch, raise a PR.
1. Once merged:
    1. `git tag`
    1. Publish as above.

### Updating existing published Modules

1. Amend the module.
1. Update the module docs.
1. Update the changelog in the module docs.
1. Push to a branch, raise a PR.
1. Once merged:
    1. `git tag`
    1. Publish as above.