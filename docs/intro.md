# Bicep?

Deployments ensuring consistent Azure Resource environments are managed through ARM Templates / Bicep files.

We use Bicep cos nobody (not even Microsoft) likes raw ARM templates.

You don't need anything special to use them; just the Azure CLI.

If writing them, you will want the VS code Bicep extension.

# Bicep structure in DRS

We structure our Bicep files in composed layers.

Some of these layers are project-agnostic and are therefore published to a registry as reusable modules. This repository contains the source and documentation for those modules.

Some layers are project specific, and will therefore be written in each projects repository, referencing the reusable modules from the registry.

## Modules

- `components` are the bottom layer.
    - Not project specific.
    - Should be used from the published registry.
    - Scope constrained to DRS needs
        - e.g. Windows App Service is not broadly supported as DRS only use Linux currently)
    - The Repository [README](../README.md) breaks down the modules available.
- `config` modules are next up
    - Not project specific
    - Should be used from the published registry.
    - Scope constrained to DRS needs
    - Differ from components in that they don't deploy top-level resources; rather intended to modify child resources
    - The Repository [README](../README.md) breaks down the modules available.
- `stack` modules are the top layer of modules
  - Project Specific
  - Ideally only one entrypoint module, that represents the complete resource stack for the repo - e.g. `main.bicep`
      - If this file becomes large, breaking it into sub-modules in the project is advisable for related areas, e.g. a Function App and all its config could go in its own module
  - Composes `component` and `config` modules to build a whole stack out of possibly shared resources, and environment specific resources
  - Environment agnostic and configurable to a specific environment via parameters
  - Highly project specific, and can do any configuration that is common between environments.

## Parameters

Configuring the `stack` modules for an environment consists of passing parameters specific to the environment.

The parameters for an environment are contained in `.bicepparam` files.

`.bicepparam` files may import from `.bicep` files, allowing the use of helper functions (e.g. to reference KeyVault secrets) or reusable "base settings" in the form of exported variables.

In this way you could build up parameters from layers.

Imagine a project which is deployed to support two different services, each with the own sets of environments.

- `base-settings.bicep` might export variables for settings that always apply to these apps
- `base-service1-settings.bicep` might export variables that always apply for service1
- `service1-prod.bicepparam` could then compose the settings for Service1's Production environment by importing from the above bicep files, and union-ing all the settings into a single parameter:
    - `union(baseSettings, baseService1Settings, { /* environment specific settings */ })`