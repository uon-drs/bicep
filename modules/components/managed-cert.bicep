// This will get Azure Managed Certificates for a given custom hostname
// and apply the bindings to a given App service
//
// Recommended usage is to be conditional on any configured hostnames
// and then to use batch configuration to run the bindings serially:
//
// // Add SSL certificates
// // this needs to be done as a separate stage to creating the app with a bound hostname
// @batchSize(1) // also needs to be done serially to avoid concurrent updates to the app service
// module appCert 'components/managed-cert.bicep' = [for hostname in appHostnames: {
//   name: 'app-cert-${uniqueString(hostname)}'
//   params: {
//     location: location
//     hostname: hostname
//     appName: app.outputs.name
//     aspId: app.outputs.aspId
//   }
// }]

param appName string
param hostname string
param aspId string

param location string = resourceGroup().location

resource app 'Microsoft.Web/sites@2020-06-01' existing = {
  name: appName
}

resource cert 'Microsoft.Web/certificates@2022-09-01' = {
  name: '${appName}_${hostname}'
  location: location
  properties: {
    canonicalName: hostname
    serverFarmId: aspId
  }
}

// update the existing app's binding with the cert details
resource hostnameBinding 'Microsoft.Web/sites/hostNameBindings@2021-02-01' = {
  name: hostname
  parent: app
  properties: {
    siteName: appName
    sslState: 'SniEnabled'
    hostNameType: 'Verified'
    customHostNameDnsRecordType: 'CName'
    thumbprint: cert.properties.thumbprint
  }
}
