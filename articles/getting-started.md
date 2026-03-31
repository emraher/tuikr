# Downloading Statistical Data with tuikr

## Introduction

`tuikr` exposes two statistical download paths from the TUIK portal:

- `dataflow` rows point to SDMX datasets that work with
  [`tuikr::statistical_data()`](https://eremrah.com/tuikr/reference/statistical_data.md)
- `istab` rows point to spreadsheet downloads served by the portal

This vignette walks through one theme, downloads one SDMX series, and
then downloads one spreadsheet file with the same browser-style session
that the portal expects.

## Discover a Theme

Start with the theme catalog and locate the Population and Demography
folder:

``` r
theme_catalog <- tuikr::statistical_themes()

theme_catalog |>
  dplyr::filter(theme_id == "11")
#> # A tibble: 1 × 2
#>   theme_name                theme_id
#>   <chr>                     <chr>   
#> 1 Population and Demography 11
```

## Inspect Table Nodes

[`tuikr::statistical_tables()`](https://eremrah.com/tuikr/reference/statistical_tables.md)
returns both SDMX dataflows and spreadsheet downloads for the same
theme. The `node_type` column tells you which path you are looking at.

``` r
population_tables <- tuikr::statistical_tables("11")

population_tables |>
  dplyr::count(node_type)
#> # A tibble: 2 × 2
#>   node_type     n
#>   <chr>     <int>
#> 1 dataflow     86
#> 2 istab       587
```

``` r
population_tables |>
  dplyr::select(table_name, node_type, dataflow_id, table_url) |>
  dplyr::slice_head(n = 6)
#> # A tibble: 6 × 4
#>   table_name                            node_type dataflow_id table_url
#>   <chr>                                 <chr>     <chr>       <chr>    
#> 1 "Foreign population by provinces and… istab     NA          https://…
#> 2 "Foreign-born population by age grou… istab     NA          https://…
#> 3 "Foreign-born population by place of… istab     NA          https://…
#> 4 "Median Age by Sex "                  istab     NA          https://…
#> 5 "Number and Population of Municipali… istab     NA          https://…
#> 6 "Population  of  Province / District… istab     NA          https://…
```

## Check Legacy Database Links

The legacy database URLs are still useful for manual browsing, even
though they are not the main programmatic download path.

``` r
population_databases <- tuikr::statistical_databases("11")

population_databases |>
  dplyr::select(db_name, db_url) |>
  dplyr::slice_head(n = 3)
#> # A tibble: 3 × 2
#>   db_name                                              db_url          
#>   <chr>                                                <chr>           
#> 1 Address Based Population Registration System Results http://biruni.t…
#> 2 Family Structure                                     http://biruni.t…
#> 3 Child Statistics-Culture and Sports                  http://biruni.t…
```

## Download an SDMX Dataset

Use the `dataflow_id` to request observations directly from the SDMX
endpoint. This chunk discovers the current flow ID for the “Age
dependency ratio” table before it calls
[`tuikr::statistical_data()`](https://eremrah.com/tuikr/reference/statistical_data.md).

``` r
age_dependency_flow <- population_tables |>
  dplyr::filter(
    node_type == "dataflow",
    table_name == "Age dependency ratio"
  ) |>
  dplyr::slice_head(n = 1)

population_data <- tuikr::statistical_data(
  dataflow_id = age_dependency_flow$dataflow_id[[1]],
  start = "2020",
  end = "2023"
)

population_data
#> # A tibble: 12 × 4
#>    ADNKS_GOSTERGE   ADNKS_GOSTERGE_label               obsTime obsValue
#>    <chr>            <chr>                              <chr>      <dbl>
#>  1 COCUK_BAG_ORAN   Child dependency ratio % (0-14 ye… 2020        33.7
#>  2 COCUK_BAG_ORAN   Child dependency ratio % (0-14 ye… 2021        33.0
#>  3 COCUK_BAG_ORAN   Child dependency ratio % (0-14 ye… 2022        32.3
#>  4 COCUK_BAG_ORAN   Child dependency ratio % (0-14 ye… 2023        31.4
#>  5 TOP_YAS_BAG_ORAN Total age dependency ratio (%)     2020        47.7
#>  6 TOP_YAS_BAG_ORAN Total age dependency ratio (%)     2021        47.4
#>  7 TOP_YAS_BAG_ORAN Total age dependency ratio (%)     2022        46.8
#>  8 TOP_YAS_BAG_ORAN Total age dependency ratio (%)     2023        46.3
#>  9 YASLI_BAG_ORAN   Elderly dependency ratio % (65+ y… 2020        14.1
#> 10 YASLI_BAG_ORAN   Elderly dependency ratio % (65+ y… 2021        14.3
#> 11 YASLI_BAG_ORAN   Elderly dependency ratio % (65+ y… 2022        14.5
#> 12 YASLI_BAG_ORAN   Elderly dependency ratio % (65+ y… 2023        15.0
```

[`tuikr::statistical_data()`](https://eremrah.com/tuikr/reference/statistical_data.md)
adds adjacent `*_label` columns when TUIK publishes code-list labels, so
you can work with readable values without losing the original codes.

## Download a Spreadsheet Table

`istab` rows expose the spreadsheet download link in `table_url`.

``` r
population_file_url <- population_tables |>
  dplyr::filter(node_type == "istab") |>
  dplyr::slice_head(n = 1) |>
  dplyr::pull(table_url)

population_file_url
#> [1] "https://veriportali.tuik.gov.tr/api/en/data/downloads?t=i&p=fPjQ%2BJp5JIDcsemzyzvwfF4kbvFSyh%2BVwY8OlkKjh6FPegiisUvSE3h%2BuReg72X%2FHBre1cw%2BHTuv8vcZMhu%2BXZ4Xn6TBglafAp4Ge1ogo58%3D"
```

Open that URL in a browser, or pass it to your own download workflow.
`istab` files often arrive with stacked headers, mixed labels, and
source notes inside the worksheet.

## Inspect the Full Resource Catalog

Use
[`tuikr::statistical_resources()`](https://eremrah.com/tuikr/reference/statistical_resources.md)
when you want one table of all supported resource types for a theme.

``` r
population_resources <- tuikr::statistical_resources("11")

population_resources |>
  dplyr::count(resource_type)
#> # A tibble: 5 × 2
#>   resource_type     n
#>   <chr>         <int>
#> 1 database         20
#> 2 dataflow         86
#> 3 istab           587
#> 4 press            22
#> 5 report            3
```
