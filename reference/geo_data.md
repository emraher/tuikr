# Get Geographic Data from TUIK

Retrieve geographic metadata or indicator values from the TUIK
geographic portal.

## Usage

``` r
geo_data(var_num = NULL, var_level = NULL, lang = "en")
```

## Arguments

- var_num:

  Character. Data Series Number (e.g., "SNM-GK160951-O33303"). Obtain
  from metadata mode. Required for data download.

- var_level:

  Numeric or `NULL`. NUTS level for the download. Optional when the
  selected series is available at only one level.

- lang:

  Character. Language code. Use `"en"` for English or `"tr"` for
  Turkish.

## Value

Returns different structures depending on usage mode:

**Metadata mode** (no parameters): A tibble with 4 columns:

- var_name:

  Character. Variable name in the selected language

- var_num:

  Character. Variable number/code for queries

- var_levels:

  List. Available NUTS levels for this variable

- var_period:

  Character. Time period type ("yillik" or "aylik")

**Data mode** (all parameters): A tibble with 3+ columns:

- code:

  Character. Geographic unit code (NUTS-2, NUTS-3, or LAU-1)

- date:

  Character. Time period (YYYY or YYYY-MM format)

- variable_name:

  Numeric/Character. Values for the requested variable. The column name
  uses the selected language when available.

## See also

[`geo_map`](https://eremrah.com/tuikr/reference/geo_map.md) for boundary
geometries

## Examples

``` r
if (FALSE) { # \dontrun{
# Get metadata for all available variables
geo_data()

# Get metadata in Turkish
geo_data(lang = "tr")

# Get data for a specific variable
geo_data(
  var_num = "SNM-GK160951-O33303",
  var_level = 2,
  lang = "tr"
)
} # }
```
