// This is a general "Base" App Service Site Config module
// You probably actually want a higher level opinionated one
// for the type of app you're deploying e.g. Function app or Web app etc.

import { getDotNetVersion } from '../utils/functions.bicep'
import { ConnectionStringDictionary } from '../utils/types.bicep'

param appName string

// accepted values differ between functions and webapps, so use those modules
param appFramework string

// Key Value pairs in here
param siteConfig object = {}
param appSettings object = {}

param connectionStrings ConnectionStringDictionary = {}

resource app 'Microsoft.Web/sites@2023-01-01' existing = {
  name: appName
}

var baseSiteConfig = {
  netFrameworkVersion: getDotNetVersion(appFramework)
  linuxFxVersion: appFramework
  requestTracingEnabled: true
  httpLoggingEnabled: true
  http20Enabled: true
  minTlsVersion: '1.2'
  alwaysOn: true
  use32BitWorkerProcess: false
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-web?pivots=deployment-language-bicep
resource settings 'Microsoft.Web/sites/config@2020-09-01' = {
  parent: app
  name: 'web'
  properties: union(
    baseSiteConfig,
    siteConfig // allows overrides / type specific values e.g. functions vs webapps
  )
}

// Doing appsettings and connection strings combined in the above
// config deployment didn't work, so we do them separately

// https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-appsettings?pivots=deployment-language-bicep
resource appSettingsDeployment 'Microsoft.Web/sites/config@2020-09-01' = {
  parent: app
  name: 'appsettings'
  properties: appSettings
}

// https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-connectionstrings?pivots=deployment-language-bicep
resource connectionStringsDeployment 'Microsoft.Web/sites/config@2020-09-01' = {
  parent: app
  name: 'connectionstrings'
  properties: connectionStrings
}
