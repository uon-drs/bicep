## VNET Integration

### App Service settings

`// TODO: expand and clarify`

```bicep
var vnetSettings = {
  // VNET Integration
  // the DNS Server is as configured on the VNET. Default is Azure DNS.
  // https://docs.microsoft.com/en-gb/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#considerations
  // > The Azure DNS IP address is 168.63.129.16. This is a static IP address and will not change.
  WEBSITE_DNS_SERVER: '168.63.129.16'
  WEBSITE_VNET_ROUTE_ALL: 1
}
```