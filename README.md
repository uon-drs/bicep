# Bicep

Here be reusable bicep files for DRS projects, as well as documentation and other samples.

Everything in `modules/` is published to a private repository either as a distinct module, or a dependency of a published module.

These modules can be referenced in your projects without being directly included.

## Non-Module Documentation

`// TODO`

## Module Documentation

`// TODO`

## Using Modules

`// TODO`

## Publishing Modules

`// TODO`

example publish command:

`az bicep publish --file webapp.bicep --target br:<registry-url>/bicep/config/webapp:v1 --documentationUri https://github.com/uon-drs/bicep/blob/main/README.md`

### Updating existing published Modules

`// TODO`