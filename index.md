# tuikr

**tuikr** provides functions to query Turkish Statistical Institute
(TUIK) data from two portals:

- **Statistical data**: Themes, file downloads, SDMX dataflows, and
  legacy databases from
  [veriportali.tuik.gov.tr](https://veriportali.tuik.gov.tr/)
- **Geographic data**: Maps and spatial statistics from
  [cip.tuik.gov.tr](https://cip.tuik.gov.tr/)

**Disclaimer**: This package is not affiliated with, endorsed by, or
connected to Turkish Statistical Institute (TUIK). It is an independent
tool for academic research purposes.

## Installation

``` r
# Install from GitHub
devtools::install_github("emraher/tuikr")
```

## Quick Start

### Statistical Data

#### 1. List themes

``` r
library(tuikr)
library(tibble)

(theme_catalog <- statistical_themes())
#> # A tibble: 19 × 2
#>    theme_name                                             theme_id
#>    <chr>                                                  <chr>   
#>  1 Justice and Elections                                  1       
#>  2 Science, Technology and Information Society            2       
#>  3 Environment                                            3       
#>  4 Education                                              4       
#>  5 Energy                                                 5       
#>  6 Price Statistics                                       6       
#>  7 Income, Consumption and Poverty                        7       
#>  8 Employment, Unemployment and Wages                     8       
#>  9 Short-Term Economic Indicators                         9       
#> 10 Culture and Sports                                     10      
#> 11 Population and Demography                              11      
#> 12 Health and Social Protection                           12      
#> 13 Agriculture                                            13      
#> 14 Tourism                                                14      
#> 15 Transport and Communication                            15      
#> 16 National Accounts                                      16      
#> 17 International Trade                                    17      
#> 18 Structural Business Statistics and Business Demography 18      
#> 19 Multi-Domain Statistics                                20
```

#### 2. Tables for Population & Demography (theme 11)

``` r
(population_tables <- statistical_tables("11"))
#> # A tibble: 673 × 6
#>    theme_name                theme_id table_name node_type dataflow_id table_url
#>    <chr>                     <chr>    <chr>      <chr>     <chr>       <chr>    
#>  1 Population and Demography 11       "Foreign … istab     <NA>        https://…
#>  2 Population and Demography 11       "Foreign-… istab     <NA>        https://…
#>  3 Population and Demography 11       "Foreign-… istab     <NA>        https://…
#>  4 Population and Demography 11       "Median A… istab     <NA>        https://…
#>  5 Population and Demography 11       "Number a… istab     <NA>        https://…
#>  6 Population and Demography 11       "Populati… istab     <NA>        https://…
#>  7 Population and Demography 11       "Populati… istab     <NA>        https://…
#>  8 Population and Demography 11       "Populati… istab     <NA>        https://…
#>  9 Population and Demography 11       "Populati… istab     <NA>        https://…
#> 10 Population and Demography 11       "Populati… istab     <NA>        https://…
#> # ℹ 663 more rows
```

#### 3. SDMX dataflows only

``` r
(population_dataflows <- dplyr::filter(
  population_tables,
  node_type == "dataflow"
))
#> # A tibble: 86 × 6
#>    theme_name                theme_id table_name node_type dataflow_id table_url
#>    <chr>                     <chr>    <chr>      <chr>     <chr>       <chr>    
#>  1 Population and Demography 11       Age depen… dataflow  TR,DF_ADNK… https://…
#>  2 Population and Demography 11       Age depen… dataflow  TR,DF_ADNK… https://…
#>  3 Population and Demography 11       Annual gr… dataflow  TR,DF_ADNK… https://…
#>  4 Population and Demography 11       Annual gr… dataflow  TR,DF_ADNK… https://…
#>  5 Population and Demography 11       Average s… dataflow  TR,DF_ADNK… https://…
#>  6 Population and Demography 11       Foreign p… dataflow  TR,DF_ADNK… https://…
#>  7 Population and Demography 11       Foreign p… dataflow  TR,DF_ADNK… https://…
#>  8 Population and Demography 11       Foreign-b… dataflow  TR,DF_ADNK… https://…
#>  9 Population and Demography 11       Foreign-b… dataflow  TR,DF_ADNK… https://…
#> 10 Population and Demography 11       Life Expe… dataflow  TR,DF_DNG_… https://…
#> # ℹ 76 more rows
```

#### 4. File downloads expose a direct table_url

``` r
population_files <- dplyr::filter(
  population_tables,
  node_type == "istab"
)
population_files$table_url[1]
#> [1] "https://veriportali.tuik.gov.tr/api/en/data/downloads?t=i&p=y6zmfhOmCjQjF4ZfBaWIpFhBjpeLg3lcu5mxFfrBelfKUj1RnEPdoKevC%2BFZ3GOiiWgNOga6%2BreB5jAY1IkWPxniqzaveWLwU2fGqU8Mrns%3D"
```

#### 5. Download one dataset

``` r
(population_observations <- statistical_data(
  population_dataflows$dataflow_id[1]
))
#> # A tibble: 54 × 4
#>    ADNKS_GOSTERGE ADNKS_GOSTERGE_label                  obsTime obsValue
#>    <chr>          <chr>                                 <chr>      <dbl>
#>  1 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2007        39.7
#>  2 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2008        39.3
#>  3 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2009        38.8
#>  4 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2010        38.1
#>  5 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2011        37.5
#>  6 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2012        36.9
#>  7 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2013        36.3
#>  8 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2014        35.8
#>  9 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2015        35.4
#> 10 COCUK_BAG_ORAN Child dependency ratio % (0-14 years) 2016        34.9
#> # ℹ 44 more rows
```

[`statistical_data()`](https://eremrah.com/tuikr/reference/statistical_data.md)
adds adjacent `*_label` columns when TUIK exposes human-readable
code-list metadata. The default `key = "ALL"` works for many datasets,
but some SDMX dataflows need a narrower key to constrain the remaining
dimensions.

#### 6. Legacy database URLs

``` r
(population_databases <- statistical_databases("11"))
#> # A tibble: 20 × 4
#>    theme_name                theme_id db_name                             db_url
#>    <chr>                     <chr>    <chr>                               <chr> 
#>  1 Population and Demography 11       Address Based Population Registrat… http:…
#>  2 Population and Demography 11       Family Structure                    http:…
#>  3 Population and Demography 11       Child Statistics-Culture and Sports http:…
#>  4 Population and Demography 11       Child Statistics-Demographic Chara… http:…
#>  5 Population and Demography 11       Child Statistics-Education          http:…
#>  6 Population and Demography 11       Child Statistics-Health             http:…
#>  7 Population and Demography 11       Child Statistics-Housing Character… http:…
#>  8 Population and Demography 11       Child Statistics-ICT Usage          http:…
#>  9 Population and Demography 11       Child Statistics-Labour Force       http:…
#> 10 Population and Demography 11       Child Statistics-Poverty            http:…
#> 11 Population and Demography 11       Child Statistics-Security and Just… http:…
#> 12 Population and Demography 11       General Population Census           http:…
#> 13 Population and Demography 11       Survey on Building and Dwelling Ch… http:…
#> 14 Population and Demography 11       Internal migration                  http:…
#> 15 Population and Demography 11       Life Tables                         http:…
#> 16 Population and Demography 11       Marriage Statistics                 http:…
#> 17 Population and Demography 11       Divorce Statistics                  http:…
#> 18 Population and Demography 11       Birth Statistics                    http:…
#> 19 Population and Demography 11       Suicide Statistics                  http:…
#> 20 Population and Demography 11       Death Statistics                    http:…
```

#### 7. All portal resources

``` r
(population_resources <- statistical_resources("11"))
#> # A tibble: 718 × 6
#>    theme_name      theme_id resource_name resource_type dataflow_id resource_url
#>    <chr>           <chr>    <chr>         <chr>         <chr>       <chr>       
#>  1 Population and… 11       "The Results… press         <NA>        https://ver…
#>  2 Population and… 11       "Urban-Rural… press         <NA>        https://ver…
#>  3 Population and… 11       "Foreign pop… istab         <NA>        https://ver…
#>  4 Population and… 11       "Foreign-bor… istab         <NA>        https://ver…
#>  5 Population and… 11       "Foreign-bor… istab         <NA>        https://ver…
#>  6 Population and… 11       "Median Age … istab         <NA>        https://ver…
#>  7 Population and… 11       "Number and … istab         <NA>        https://ver…
#>  8 Population and… 11       "Population … istab         <NA>        https://ver…
#>  9 Population and… 11       "Population … istab         <NA>        https://ver…
#> 10 Population and… 11       "Population … istab         <NA>        https://ver…
#> # ℹ 708 more rows
```

#### 8. Press releases and reports keep their portal URLs

``` r
population_publications <- dplyr::filter(
  population_resources,
  resource_type %in% c("press", "report")
)
population_publications |>
  dplyr::select(resource_type, resource_name, resource_url) |>
  dplyr::slice(3)
#> # A tibble: 1 × 3
#>   resource_type resource_name        resource_url                               
#>   <chr>         <chr>                <chr>                                      
#> 1 press         World Population Day https://veriportali.tuik.gov.tr/en/press/5…
```

### Geographic Data

#### 1. List available geographic variables

``` r
(geo_variable_catalog <- geo_data())
#> # A tibble: 80 × 4
#>    var_name                                        var_num var_levels var_period
#>    <chr>                                           <chr>   <list>     <chr>     
#>  1 Rate of population served by municipal waste s… CVRBA-… <int [2]>  yillik    
#>  2 Ratio of Population Served by Wastewater Treat… CVRAS-… <int [2]>  yillik    
#>  3 Daily Per Capita Wastewater Amount (L/Capita-D… CVRAS-… <int [2]>  yillik    
#>  4 Ratio of Population Provided with Sewerage Ser… CVRAS-… <int [2]>  yillik    
#>  5 Proportion of Population with Potable Water Ne… CVRBS-… <int [2]>  yillik    
#>  6 Ratio of Population Served by Drinking Water T… CVRBS-… <int [2]>  yillik    
#>  7 Total electricity consumption per capita (kWh)  ENR-GK… <int [1]>  yillik    
#>  8 Average Socioeconomic Level Scores              ses123  <int [2]>  yillik    
#>  9 Mean Years of Schooling (year)                  ULE-GK… <int [2]>  yillik    
#> 10 Number of Illiterate                            ULE-GK… <int [3]>  yillik    
#> # ℹ 70 more rows
```

#### 2. List geographic variables in Turkish

``` r
(geo_variable_catalog_tr <- geo_data(lang = "tr"))
#> # A tibble: 80 × 4
#>    var_name                                        var_num var_levels var_period
#>    <chr>                                           <chr>   <list>     <chr>     
#>  1 Atık hizmeti verilen belediye nüfusunun toplam… CVRBA-… <int [2]>  yillik    
#>  2 Atıksu Arıtma Hizmeti Verilen Nüfus Oranı (%)   CVRAS-… <int [2]>  yillik    
#>  3 Kişi Başı Günlük Atıksu Miktarı (L/Kişi-Gün)    CVRAS-… <int [2]>  yillik    
#>  4 Kanalizasyon Hizmeti Verilen Nüfus Oranı (%)    CVRAS-… <int [2]>  yillik    
#>  5 İçme Suyu Şebekesi Bulunan Nüfus Oranı (%)      CVRBS-… <int [2]>  yillik    
#>  6 İçme Suyu Arıtma Hizmeti Verilen Nüfus Oranı (… CVRBS-… <int [2]>  yillik    
#>  7 Kişi Başına Elektrik Tüketimi (kWh)             ENR-GK… <int [1]>  yillik    
#>  8 Ortalama Sosyoekonomik Seviye Skorları          ses123  <int [2]>  yillik    
#>  9 Ortalama Eğitim Süresi (yıl)                    ULE-GK… <int [2]>  yillik    
#> 10 Okuma Yazma Bilmeyen Sayısı                     ULE-GK… <int [3]>  yillik    
#> # ℹ 70 more rows
```

#### 3. Download data for a specific variable

``` r
(population_values <- geo_data(
  var_num = "ADNKS-GK137473-O29001",
  var_level = 3
))
#> # A tibble: 405 × 3
#>    code  date  population_of_sre_1_sre_2_provinces_and_districts
#>    <chr> <chr> <chr>                                            
#>  1 39    2025  379595                                           
#>  2 39    2024  379031                                           
#>  3 39    2023  377156                                           
#>  4 39    2022  369347                                           
#>  5 39    2021  366363                                           
#>  6 8     2025  167531                                           
#>  7 8     2024  169280                                           
#>  8 8     2023  172356                                           
#>  9 8     2022  169403                                           
#> 10 8     2021  169543                                           
#> # ℹ 395 more rows
```

#### 4. Get map boundaries at different levels

``` r
nuts2_map <- geo_map(level = 2)  # 26 regions
nuts3_map <- geo_map(level = 3)  # 81 provinces
lau1_map <- geo_map(level = 4)   # 973 districts
settlements <- geo_map(level = 9)  # settlement points
```

[`geo_map()`](https://eremrah.com/tuikr/reference/geo_map.md) returns
`sf` objects in WGS 84 (EPSG:4326), ready for
[`dplyr::left_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
on the `code` column when you want to combine boundaries with values
returned by
[`geo_data()`](https://eremrah.com/tuikr/reference/geo_data.md).

## Learn More

- **[Getting
  Started](https://emraher.github.io/tuikr/articles/getting-started.html)**
- **[Geographic
  Mapping](https://emraher.github.io/tuikr/articles/geographic-mapping.html)**
- **[Function
  Reference](https://emraher.github.io/tuikr/reference/index.html)**
