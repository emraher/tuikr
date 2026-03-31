# Download SDMX Data from TUIK

Download a TUIK SDMX dataset identified by `dataflow_id`.

## Usage

``` r
statistical_data(
  dataflow_id,
  key = "ALL",
  start = NULL,
  end = NULL,
  detail = "full",
  dimension_at_observation = "TIME_PERIOD",
  lang = "en"
)
```

## Arguments

- dataflow_id:

  Character string. SDMX dataflow identifier from
  [`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md).

- key:

  Character string. SDMX key path. Default `"ALL"`.

- start:

  Character string or `NULL`. Optional start period.

- end:

  Character string or `NULL`. Optional end period.

- detail:

  Character string. Default `"full"`.

- dimension_at_observation:

  Character string. Default `"TIME_PERIOD"`.

- lang:

  Character string. Language for human-readable label columns derived
  from SDMX metadata. Default `"en"`. Use `"tr"` for Turkish labels.

## Value

A tibble with trimmed character columns, invariant dimensions removed,
and `*_label` columns added for coded dimensions when labels are
available.

## See also

[`statistical_tables`](https://eremrah.com/tuikr/reference/statistical_tables.md)
to discover `dataflow_id` values,
[`statistical_resources`](https://eremrah.com/tuikr/reference/statistical_resources.md)
for the portal catalog

## Examples

``` r
if (FALSE) { # \dontrun{
# Download all observations from a dataflow
statistical_data("TR,DF_ADNKS_T26,1.0")

# Download with period filter
statistical_data(
  "TR,DF_ADNKS_T26,1.0",
  start = "2020",
  end = "2023"
)

# Download with specific SDMX key path
statistical_data(
  "TR,DF_UHTI_COGRAFI,1.0",
  key = "TR....../ALL"
)

# Download Turkish labels for dimensions
statistical_data("TR,DF_ADNKS_T26,1.0", lang = "tr")
} # }
```
