# Get Statistical Databases for a Theme from TUIK

Retrieves interactive database URLs for a specific theme from the TUIK
data portal. Theme IDs can be obtained using
[`statistical_themes`](https://eremrah.com/tuikr/reference/statistical_themes.md).
This is a filtered convenience wrapper around
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md)
for `"database"` resources.

## Usage

``` r
statistical_databases(theme, lang = "en")
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

A tibble with 4 columns:

- theme_name:

  Character. Name of the statistical theme.

- theme_id:

  Character. Numeric ID of the theme.

- db_name:

  Character. Name of the interactive database.

- db_url:

  Character. URL to the database query interface.

## Note

Database URLs link to the legacy `biruni.tuik.gov.tr` interactive query
interface, not direct downloads. For SDMX-backed datasets, use
[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md)
to discover `dataflow_id` values, then use
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md).
For press releases and reports, use
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md)
with `type = "press"` or `type = "report"`.

## See also

[`statistical_themes`](https://eremrah.com/tuikr/reference/statistical_themes.md),
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md),
[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Get databases for Population and Demography (theme 11)
databases <- statistical_databases(11)

# Retrieve press releases for the same theme
press_releases <- statistical_resources(11, type = "press")

# Open a database in the browser
browseURL(databases$db_url[1])
} # }
```
