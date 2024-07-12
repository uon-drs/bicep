> [!TIP]
> DELETE THIS TIP!
>
> This template is an example structure for a Bicep README to include in your projects, describing their project specific infrastructure needs.

# Bicep / Infrastructure Overview

This repo uses Bicep modules and general guidance from here: https://github.com/uon-drs/bicep

This document describes the project specific parts.

# Step by step deploy an environment

Not everything is done by ARM (see below for details), so here is a list of steps for setting up a project environment, including the manual bits:

## Pre Bicep Deployment

> [!TIP]
> These steps may differ per project, but this template includes the following as commonly needed.

1. Create Database resources if necessary.
    - See [Databases](https://github.com/uon-drs/bicep/blob/main/docs/non-bicep.md#databases) in the DRS Bicep Guidance.
    - See also [DRS Postgres Guidance](https://github.com/orgs/uon-drs/discussions/23).
1. Optional Custom Hostname configuration
    - If you pass a custom hostname to an ARM Template, it _will_ do a cursory check of your DNS settings
    - so you need to set an `asuid` subdomain TXT record to point to your Azure subscription. This is well documented by Microsoft.
1. Decide on a suitable resource group for the environment.
    - Sometimes this may be out of your hands, if provided with an existing Resource Group
    - A project's bicep stack may often share some resources at a resource group level
    - for example, a `non-prod` resource group could have several non production environments for several services all share the same app service plan.
1. Create the resource group if necessary
    - give it a sensible name e.g. `myproject-nonprod`
    - Make the location the same as you want the resources to be, ideally. e.g. `uksouth`
1. Create Key Vaults
    - To store secrets that will be used during deployment to configure resources
        - e.g. DB Connection string, Sendgrid API keys, Recaptcha secrets...
    - If you created a new shared Resource Group above, optionally create a matching Key Vault for shared secrets like SSH keys.
        - name it sensibly e.g.
            - `<resource-group-name>-kv`
            - `<service-name>-kv`
            - `<service-name>-nonprod-kv`
    - Create a Key Vault for the specific environment you're deploying
        - name it `<service-name>-<env>-kv`
1. Create Third Party (e.g. Google) Service credentials for the environment, if necessary e.g.
    - ReCAPTCHA credentials
    - Maps API Keys
    - Analytics API Keys
    - Elastic Cloud credentials
    - etc.
1. Create a SendGrid account if necessary
    - validate it
    - create an api key
    - see [**DRS SendGrid Guidance**](https://github.com/orgs/uon-drs/discussions/32)
1. Keycloak deployment
    - Project deployment if necessary - or use drs-core-identity:
        - This project uses Keycloak / OIDC. All current environments refer to the drs-core-identity keycloak, but if a new environment should differ, Keycloak deployment and configuration will be needed
    - Realm configuration will be needed
    - If connecting to Azure AD / Microsoft Entra, an App Registration will be needed.
1. Populate Environment Key Vault with App Secrets
   - You **must** put in secrets that are expected by app settings configured by the templates else they will not be correctly linked
   - Required Secrets are documented in the [**Key Vault Secrets**](#key-vault-secrets) section below

## Deploy Bicep Environment

Follow the guidance [here](https://github.com/uon-drs/bicep/blob/main/docs/deployment.md)

`// TODO Amend the following as necessary`

This project targets a single resource group `my-resource-group` / multiple resources groups for different services/ environments (list them)

### Stack Parameters (`main.bicep`)

Stack Parameters are detailed below, for authoring new environments

Name | Type | Description | Notes
-|-|-|-


## Post Bicep Deployment

Any configuration once the resources are created, that can't be done by Bicep.

This section may not be needed for your project.

# Key Vault Secrets

Here are the Secrets requirements for ARM and DevOps deployments of bits of the stack.

These go in the Environment Specific Key Vault only. e.g. `<service-name>-dev-kv`.

Secret Name | Description | Consumer | Use
-|-|-|-
`db-connection-string` |connection string for the App DB | ARM, Pipelines | App Settings, Database migrations
`sendgrid-api-key` | SendGrid API key | ARM | App Settings
`google-recaptcha-secret` | Google ReCAPTCHA Secret that corresponds to the Public Key in the environment Template | ARM | App Settings

Optionally include advice on how to generate certain secret values e.g. SSH Keys, API keys etc.