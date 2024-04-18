# Azure KeyVaults in Bicep

This document contains general information and gotchas around using Azure KeyVaults and Bicep use in DRS Projects.

## KeyVaults in DRS

Because of the need to pre-populate secrets so they can be [used](#accessing-keyvault-secrets-in-bicep-files) or [referenced](#referencing-keyvault-secrets-in-app-service) during bicep deployments, in DRS KeyVault setup is manual.

### Creating and configuring KeyVaults

- For some projects you may want a general shared KeyVault for keeping human or process use secrets in - e.g. private ssh keys for a shared VM.
- You'll always want an environment specific KeyVault for that environment's apps to reference secrets in.

1. Create a KeyVault

- Preferable name it similarly to `<serviceName>-<environment>-kv`
- Allow Azure Resource Manager access for Template Deployments
  - This lets Bicep files retrieve secrets directly

2. Add Secrets as required by the project. This should be documented in a given repository's Bicep docs.

## Referencing KeyVault Secrets in App Service

`// TODO expand write-up`

For now, refer to `config/keyvault-access` [docs](config/keyvault-access.md) and [module](../modules/config/keyvault-access.bicep)

## Accessing KeyVault Secrets in Bicep files

`// TODO expand write-up`

You can get the value of a secret directly in Bicep as follows:

```bicep
// Get resource reference
resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
    name: kvName
}

// Get secret
kv.getSecret('my-secret-name')
```

- KeyVaults accessed directly by Bicep modules must be pre-existing and populated with the secrets being accessed
    - MUST have template access enabled on the kv for bicep to fetch secrets
    - MUST have `Key Vault Secrets User` on the KV for the user running the bicep

## Accessing Key Vault Secrets as a User

Users need the `Key Vault Secrets User` role to access secrets.
This applies whether from the portal, the Azure CLI, or when deploying Bicep.

Some Users (but almost never applications/Service Principals) may want greater access. Choose the appropriate role (e.g. `Key Vault Secrets Officer`, `Key Vault Administrator`...)

> [!TIP]
> The below steps work for granting Key Vault access to any kind of Azure AD Principal.

### Assigning Roles

- Manage Access Control (IAM) for the Key Vault
  - Assign roles (you'll need to be `Owner` or `RBAC Administrator` on the Key Vault)
    - Select the `Key Vault Secrets User` role, or whichever other role is appropriate
    - Search for the Principal's display name (or principal id)

## Accesssing KeyVault Secrets in Azure Pipelines

New pipelines / new bicep environments deployed to by existing pipelines may need access granted to Key Vault resources.

This is done as follows:

- the "Azure Subscription" name in the pipelines is the name of the Service Connection in Azure DevOps
- If this is a new pipeline you may need a new service connection.
  - I suggest creating it manually in DevOps and controlling the name, then matching that in the pipeline.
  - It will make things a lot clearer.
- If an existing pipeline, find the service connection in DevOps by its name.
- For the service connection, click "Manage Service Principal".
  - This will take you to the Service Principal (the actual Azure AD account, essentially) in Azure Portal
  - It gives you all the info you need like IDs and names
- Go to "Branding" and change the Name to something meaningful
  - the default is `<DevOpsOrganisation>-<DevOpsProject>-<AzureSubscriptionId>`, not unique
  - giving it something meaningful makes the next step easier!
  - consider matching the Service Connection name?
- Grant access to the Service Principal following the [Role Assignment](#assigning-roles) steps above.

## SSH Keys in KeyVault

To correctly store and/or retrieve SSH keys in KeyVault, it's necessary to use the azure cli, not just copy the text of the secret into a file.

### Storing SSH keys
Upload each file to KeyVault using the Azure CLI:

- `az keyvault secret set --vault-name '<vault-name>' -n '<secret-name>' -f '<key-file-path>'`
- use a sensible secret name like `<vmName>-ssh-<public|private>`
- this has to be done via the CLI at the moment; the Portal stores the key data incorrectly
    - https://serverfault.com/questions/848168/putting-rsa-keys-into-azure-key-vault
- do it for `<keyname>` (the private key) and `keyname.pub` (the public key)

### Retrieving SSH keys

If you need to fetch the private key for logging in yourself:

`az keyvault secret download --vault-name '<vault-name>' -n '<secret-name>' -f '<target-file-path>'`

> [!TIP]
> Don't forget to `chmod` the key and it's directory (preferably `~/.ssh`?) to the correct permissions for Open SSH:
>
> - `chmod 700 ~/.ssh`
> - `chmod 600 ~/.ssh/privatekey_rsa`