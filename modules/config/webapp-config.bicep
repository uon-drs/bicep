import { ConnectionStringDictionary } from '../utils/types.bicep'

param appName string

// az webapp list-runtimes --os-type linux
@allowed(['DOTNETCORE|8.0', 'NODE|20-lts', 'PYTHON|3.12'])
param appFramework string = 'DOTNETCORE|8.0'

// Key Value pairs in here
param appSettings object = {}

param connectionStrings ConnectionStringDictionary = {}

// Optional
// Default behaviour depends on runtime
// As does format of valid override values
// https://learn.microsoft.com/en-gb/troubleshoot/azure/app-service/faqs-app-service-linux#what-are-the-expected-values-for-the-startup-file-section-when-i-configure-the-runtime-stack-
param startCommand string = ''

module settings 'app-service-config.bicep' = {
  name: 'functionConfig-${uniqueString(appName)}'
  params: {
    appName: appName
    appFramework: appFramework
    siteConfig: {
      appCommandLine: startCommand
    }
    appSettings: appSettings
    connectionStrings: connectionStrings
  }
}
