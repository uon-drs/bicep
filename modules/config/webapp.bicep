import { ConnectionStringDictionary } from '../utils/types.bicep'

param appName string

// az webapp list-runtimes --os-type linux
@allowed(['DOTNETCORE|10.0', 'NODE|20-lts', 'PYTHON|3.12', 'DOCKER'])
param appFramework string = 'DOTNETCORE|10.0'

// This is required if appFramework is set to DOCKER
param dockerImage string = ''

// Key Value pairs in here
param appSettings object = {}

param connectionStrings ConnectionStringDictionary = {}

// Optional
// Default behaviour depends on runtime
// As does format of valid override values
// https://learn.microsoft.com/en-gb/troubleshoot/azure/app-service/faqs-app-service-linux#what-are-the-expected-values-for-the-startup-file-section-when-i-configure-the-runtime-stack-
param startCommand string = ''

module settings 'base/app-service.bicep' = {
  name: 'functionConfig-${uniqueString(appName)}'
  params: {
    appName: appName
    appFramework: appFramework == 'DOCKER' ? '${appFramework}|${dockerImage}' : appFramework
    siteConfig: {
      appCommandLine: startCommand
    }
    appSettings: appSettings
    connectionStrings: connectionStrings
  }
}
