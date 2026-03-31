# Get Statistical Tables for a Theme from TUIK

Retrieves SDMX dataflows and direct file downloads for a specific theme
from the TUIK data portal. Theme IDs can be obtained using
[`statistical_themes`](https://eremrah.com/tuikr/reference/statistical_themes.md).
This is a filtered convenience wrapper around
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md)
for `"dataflow"` and `"istab"` resources.

## Usage

``` r
statistical_tables(theme, lang = "en")
```

## Arguments

- theme:

  Character or numeric. A single theme ID (e.g., `"11"` or `11`). Only
  one theme can be queried at a time. Invalid or multiple theme IDs
  return an error with a list of valid themes.

- lang:

  Character string. Portal language code. Default `"en"` for English.
  Use `"tr"` for Turkish.

## Value

A tibble with 6 columns:

- theme_name:

  Character. Name of the statistical theme.

- theme_id:

  Character. Numeric ID of the theme.

- table_name:

  Character. Name of the table or dataset.

- node_type:

  Character. `"dataflow"` for SDMX interactive datasets; `"istab"` for
  direct file downloads.

- dataflow_id:

  Character. SDMX dataflow identifier (e.g., `"TR,DF_ADNKS_T18,1.1"`).
  `NA` for `istab` nodes.

- table_url:

  Character. For `dataflow` nodes: URL to the interactive data browser.
  For `istab` nodes: direct download URL.

## Note

The TUIK portal distinguishes between SDMX dataflows (interactive query
interface via <https://databrowser2.tuik.gov.tr>) and static file
downloads (`istab`). `dataflow_id` is the canonical machine identifier
for SDMX-backed datasets. Use it with
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md)
to download observations.

## See also

[`statistical_themes`](https://eremrah.com/tuikr/reference/statistical_themes.md)
to get theme IDs,
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md)
for the full resource catalog,
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md)
to download SDMX observations

## Examples

``` r
if (FALSE) { # \dontrun{
# Get all themes first
themes <- statistical_themes()

# Get tables for Population and Demography (theme 11)
tables <- statistical_tables(11)

# Get the broader resource catalog for the same theme
resources <- statistical_resources(11)

# Filter to SDMX dataflows only
dataflows <- dplyr::filter(tables, node_type == "dataflow")

# Download observations for one dataflow
sdmx_data <- statistical_data(
  dataflow_id = dataflows$dataflow_id[1]
)
} # }
```
