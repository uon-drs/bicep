import { ConnectionStringDictionary } from '../utils/types.bicep'

param appName string
param appServicePlanSku string

// az functionapp list-runtimes --os-type linux
@allowed(['DOTNET-ISOLATED|8.0', 'Node|20', 'Python|3.11'])
param appFramework string = 'DOTNET-ISOLATED|8.0'

// Key Value pairs in here
param appSettings object = {}

param connectionStrings ConnectionStringDictionary = {}

// calculate the runtime stack from the framework identifier
var runtime = empty(appFramework) ? 'custom' : toLower(split(appFramework, '|')[0])

var baseFunctionSettings = {
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: runtime
}

module settings 'app-service-config.bicep' = {
  name: 'functionConfig-${uniqueString(appName)}'
  params: {
    appName: appName
    appFramework: appFramework
    siteConfig: {
      alwaysOn: appServicePlanSku != 'Y1'
    }
    appSettings: union(baseFunctionSettings, appSettings)
    connectionStrings: connectionStrings
  }
}
