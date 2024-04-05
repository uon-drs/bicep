# Non-Bicep Infrastructure

Not everything for DRS Projects is deployed with Bicep/ARM.

Typically there are two reasons why not:

1. The resource in question isn't "throwaway"
    - Typically we consider Bicep resources totally throwaway - you could delete them and redeploy the environment in minutes with no issues.
    - Therefore resources with persistent configuration or data not captured in Bicep are usually handled manually
    - Databases are a good example of this
    - Another typical example is SaaS services that require configuration outside the Azure Portal, via the Vendor. Examples include **Elastic Cloud**, **Sendgrid**, etc.
2. The resource in question requires manual configuration and must be present **before** Bicep deployments are run
    - This is the case for KeyVaults
    - Bicep could create them, but would be unable to put the correct Secret values in place.

Some notes follow on Resources that meet the above criteria.

# Databases

Unlike App Service etc (most other Azure Resources), databases aren't exactly throwaway.

Partly as a result of this decision, db migrations are not run by ARM, so must be run manually / by deployment pipeline as appropriate.

## Creating Database Server

Database Servers are often shared, so this step may not be needed for every environment. e.g. If Dev and QA use the same `non-prod` db server, it only needs creating before Dev is deployed.

DRS Team members may follow the guidance [here](https://github.com/orgs/uon-drs/discussions/23).

## Creating Database / Users for the App

DRS Team members may follow the guidance [here](https://github.com/orgs/uon-drs/discussions/23).

# Key Vaults

Key Vaults are covered in more detail [here](keyvaults.md).

# Common SaaS Resources

## SendGrid

SendGrid accounts are SaaS resources, and so require manual configuration with the SaaS provider (in this case SendGrid) once created in Azure.

DRS Team members may follow the guidance [here](https://github.com/orgs/uon-drs/discussions/32).