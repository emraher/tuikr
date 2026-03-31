# Get Statistical Themes from TUIK

Retrieves all top-level statistical themes from the TUIK data portal.
Theme IDs are used with
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md),
[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md),
and
[`statistical_databases`](https://eremrah.com/tuikr/reference/statistical_databases.md)
to access specific portal resources. For SDMX-backed datasets, use
[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md)
or
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md)
to discover `dataflow_id` values, then pass those identifiers to
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md).

## Usage

``` r
statistical_themes(lang = "en")
```

## Arguments

- lang:

  Character string. Portal language code. Default `"en"` for English.
  Use `"tr"` for Turkish.

## Value

A tibble with 2 columns:

- theme_name:

  Character. Name of the statistical theme.

- theme_id:

  Character. Numeric ID used to query tables and databases.

## See also

[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md),
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md),
[`statistical_databases`](https://eremrah.com/tuikr/reference/statistical_databases.md),
[`statistical_data`](https://eremrah.com/tuikr/reference/statistical_data.md)

## Examples

``` r
if (FALSE) { # \dontrun{
themes <- statistical_themes()
} # }
```
