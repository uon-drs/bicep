# Deploy an environment

Obviously there is a wealth of official Microsoft documentation for how to deploy using Bicep.

Think of this is as a general quickstart guide for DRS projects.

**Some typical expectations:**

- Your project probably has prerequisite manual infrastructure
    - Does its database exist?
    - Do the necessary KeyVaults exist, with their Secrets in?
    - anything else as documented by your project.

- Your project will be using a `.bicepparam` file per environment, as outlined in the [introduction](intro.md).
- your `stack` entrypoint bicep file (e.g. `main.bicep`) targets a single resource group
    - this is usually the case for DRS projects.
    - It's possible to target the subscription scope and deploy to multiple RGs (including creating new ones) but bear in the mind the steps below are not expressly for this.

## Azure CLI example
```bash
az deployment group create \
  -n <serviceName>-<env>-20230619 \
  -f main.bicep \
  -g <resourceGroupName> \
  -p @path/to/environment.bicepparam
```

> [!TIP]
> It's good practice to name a deployment using `-n`, otherwise the name of the template file (e.g. `main`) will be used.
>
> It's useful to be able to distinguish deployments when troubleshooting failures in the Azure Portal.

Specify desired optional parameters using `--parameters | -p` or a Parameters File.

Fill out requested parameters (if any) the same way as optional, or wait to be prompted.

## VS Code example
Using the VS Code Bicep extension:

1. Right click `main.bicep` and choose `Deploy Bicep File...`
1. Sign into Azure if necessary
1. Name the deployment
1. Select subscription, RG, parameter file

### Notes / Examples:

- Assuming all deployments are scoped to a single target resource group; no subscription level deployments.
  - You **MUST** specify the target resource group.
    - example: `-g my-resource-group`
  - If you have different RGs for different environments (e.g. `non-prod` RG for `dev` and `test`), double check to ensure the RG is correct for the environment params you're using!
    
```bash
# ✅
az deployment group create \
  -n myservice-prod-20230619 \
  -f main.bicep \
  -g myservice-prod \
  -p @myservice/prod.bicepparam

# ✅
az deployment group create \
  -n myservice-dev-20230619 \
  -f main.bicep \
  -g myservice-nonprod \
  -p @myservice/dev.bicepparam

# ❌
az deployment group create \
  -n myservice-dev-20230619 \
  -f main.bicep \
  -g myservice-prod \
  -p @myservice/dev.bicepparam
```

- If you want resources in a different location than the target resource group:
  - specify the value of the optional `location` parameter
  - example: `-p location=uksouth`