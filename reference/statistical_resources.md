# Get Statistical Resources for a Theme from TUIK

Retrieves all supported resource nodes for a specific theme from the
TUIK data portal. Theme IDs can be obtained using
[`statistical_themes`](https://eremrah.com/tuikr/reference/statistical_themes.md).

## Usage

``` r
statistical_resources(theme, type = NULL, lang = "en")
```

## Arguments

- theme:

  Character or numeric. A single theme ID (e.g., `"11"` or `11`). Only
  one theme can be queried at a time. Invalid or multiple theme IDs
  return an error with a list of valid themes.

- type:

  Character vector or `NULL`. Optional resource types to keep. Supported
  values are `"dataflow"`, `"istab"`, `"database"`, `"press"`, and
  `"report"`. Default `NULL` returns all supported resources for the
  theme.

- lang:

  Character string. Portal language code. Default `"en"` for English.
  Use `"tr"` for Turkish.

## Value

A tibble with 6 columns:

- theme_name:

  Character. Name of the statistical theme.

- theme_id:

  Character. Numeric ID of the theme.

- resource_name:

  Character. Name of the portal resource.

- resource_type:

  Character. One of `"dataflow"`, `"istab"`, `"database"`, `"press"`, or
  `"report"`.

- dataflow_id:

  Character. SDMX dataflow identifier for `"dataflow"` rows. `NA` for
  other resource types.

- resource_url:

  Character. Absolute URL for the resource.

## Details

Use `resource_type` to decide how to handle a resource: `"dataflow"`
rows work with
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md);
`"istab"`, `"press"`, and `"report"` rows expose downloadable or
browsable URLs; `"database"` rows point to the legacy interactive
database interface.

## See also

[`statistical_themes`](https://eremrah.com/tuikr/reference/statistical_themes.md)
to get theme IDs,
[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md)
for the tables-only view,
[`statistical_databases`](https://eremrah.com/tuikr/reference/statistical_databases.md)
for the databases-only view,
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md)
to download SDMX observations

## Examples

``` r
if (FALSE) { # \dontrun{
resources <- statistical_resources(11)

press_releases <- statistical_resources(11, type = "press")

reports_and_files <- statistical_resources(
  11,
  type = c("report", "istab")
)
} # }
```
