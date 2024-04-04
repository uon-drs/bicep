// per https://github.com/Azure/app-service-linux-docs/blob/master/Things_You_Should_Know/kind_property.md

// Friendly values of valid app service kinds;
// bicep tooling should offer autocomplete ;)
@export()
type AppServiceKindDescriptor =
  | 'Linux Web App'
  | 'Linux Function App'
  | 'Linux Container Web App'
  | 'Linux Web App on Kubernetes (ARC)'
  | 'Linux Container Web App on Kubernetes (ARC)'
  | 'Linux Function App on Kubernetes (ARC)'
  | 'Linux Container Function App on Kubernetes (ARC)'
  | 'Windows Web App'
  | 'Windows Function App'
  | 'Windows Container Web App'
  | 'Windows Container Web App on HyperV'

@export()
func getAppServiceKind(descriptor AppServiceKindDescriptor) string =>
  // Dictionary that maps a friendly descriptor to a specific app kind value
  // since app kind values are kind of arbitrary and not well ordered or defined, gg Microsoft
  {
    'Linux Web App': 'app,linux'
    'Linux Function App': 'functionapp,linux'
    'Linux Container Web App': 'app,linux,container'
    'Linux Web App on Kubernetes (ARC)': 'app,linux,kubernetes'
    'Linux Container Web App on Kubernetes (ARC)': 'app,linux,container,kubernetes'
    'Linux Function App on Kubernetes (ARC)': 'functionapp,linux,kubernetes'
    'Linux Container Function App on Kubernetes (ARC)': 'functionapp,linux,container,kubernetes'
    'Windows Web App': 'app'
    'Windows Function App': 'functionapp'
    'Windows Container Web App': 'app,container,windows'
    'Windows Container Web App on HyperV': 'hyperV'
  }[descriptor]
