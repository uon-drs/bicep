# Module name

Overview of module, what it's for etc.

## Parameters

Name | Type | Description | Notes
-|-|-|-
`location` | `string?` | Valid Location for the target Resource(s) | Defaults to Resource Group location
`tags` | `{}` | A dictionary of key value pairs to apply to the resource as Azure Resource Tags | All component modules are already tagged with `Source: Bicep` by default

## Exports

Name | Type | Description
-|-|-
`<exportIdentifier>` | `function` \| `type` \| `<variableType>` | Describe the export or its intended use

If necessary, more detailed documentation of exported functions may be given (and should be linked to):

### `exportedFunction`

```bicep
exportedFunction(arg1, arg2)
```

#### Arguments
Name | Type | Description
-|-|-
`arg1` | `<variableType` | 
`arg2` | `<variableType>` |

#### Returns
Type | Description
-|-
`<variableType>` | 

##### Example

```bicep
<Example Return>
```

## Outputs

Name | Type | Description | Notes
-|-|-|-
`<outputIdentifier>` | `<variableType>` | Describe the output | Any usage notes or gotchas

Some outputs may warrant detailed type descriptions:

### `complexOutput`

Describe the type, the contents of the output, intended use etc.

## Changelog

The changelog is very important as published modules are version tagged in the registry.

- Newly published versions must have unique tags so that older projects do not break (they can safely use older versions of published modules)
- The changelog should allow projects to understand which versions of modules they can or cannot use based on their needs
- The changelog may help make clear when updates to a module are warranted, resulting in a new version
- The use of git tags is encouraged to represent commits module versions have been published from. Such a commit should include updated modulex docs and changelog 

### v1
Initial release