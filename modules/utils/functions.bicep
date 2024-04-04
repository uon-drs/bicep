@export()
func referenceSecret(vaultName string, secretName string) string =>
  '@Microsoft.KeyVault(VaultName=${vaultName};SecretName=${secretName})'

// .NET needs separate version specifier (on Windows at least; not sure about Linux)
@export()
func getDotNetVersion(appFramework string) string =>
  startsWith(split(appFramework, '|')[0], 'DOTNET')
    ? 'v${split(appFramework, '|')[1]}'
    : 'v4.0' // this is what you get if you don't set it ;)
