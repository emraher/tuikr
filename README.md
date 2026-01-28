
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tuikr

<!-- badges: start -->

[<span class="image placeholder"
original-image-src="https://zenodo.org/badge/DOI/10.5281/zenodo.18381733.svg"
original-image-title="">DOI</span>](https://doi.org/10.5281/zenodo.18381733)
[![Lifecycle:
stable](README_files/figure-gfm/4c3e7750a6a29618a9285cbb1cb165c8afe9987f.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](README_files/figure-gfm/b3976c6f4514e05c072654df427b2fac2113286a.svg)](https://github.com/emraher/cbRt/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

R package for accessing Turkish Statistical Institute (TUIK) data from
two portals:

- **Statistical data**: Themes, tables, and databases from
  [data.tuik.gov.tr](https://data.tuik.gov.tr/)
- **Geographic data**: Maps and spatial statistics from
  [cip.tuik.gov.tr](https://cip.tuik.gov.tr/)

## Installation

``` r
# Install from GitHub
devtools::install_github("emraher/tuikr")
```

## Quick Start

### Statistical Data

``` r
library(tuikr)

# List all themes
themes <- statistical_themes()
head(themes)
#> # A tibble: 6 × 2
#>   theme_name                        theme_id
#>   <chr>                             <chr>   
#> 1 Adalet ve Seçim                   110     
#> 2 Bilim, Teknoloji ve Bilgi Toplumu 102     
#> 3 Çevre ve Enerji                   103     
#> 4 Dış Ticaret                       104     
#> 5 Eğitim, Kültür, Spor ve Turizm    105     
#> 6 Ekonomik Güven                    117

# Get tables for a theme
tables <- statistical_tables(110)
head(tables, 3)
#> # A tibble: 3 × 5
#>   theme_name      theme_id data_name                     data_date  datafile_url
#>   <chr>           <chr>    <chr>                         <date>     <chr>       
#> 1 Adalet ve Seçim 110      Yurt içi, yurt dışı ve gümrü… 2024-07-03 http://data…
#> 2 Adalet ve Seçim 110      İBBS, 1. Düzeyde, Suç Türü v… 2021-11-02 http://data…
#> 3 Adalet ve Seçim 110      İBBS, 3. Düzeyde, Suç Türü v… 2021-11-02 http://data…

# Get databases for a theme
databases <- statistical_databases(110)
head(databases, 3)
#> # A tibble: 3 × 4
#>   theme_name      theme_id db_name                                        db_url
#>   <chr>           <chr>    <chr>                                          <chr> 
#> 1 Adalet ve Seçim 110      "Milletvekili Seçim Sonuçları "                http:…
#> 2 Adalet ve Seçim 110      "Mahalli İdareler Seçim Sonuçları "            http:…
#> 3 Adalet ve Seçim 110      "Cumhurbaşkanlığı Seçimi / Halk Oylaması Sonu… http:…
```

### Geographic Data

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

# List available geographic variables
variables <- geo_data()
head(variables, 3)
#> # A tibble: 3 × 6
#>   var_name                var_num var_levels var_period var_source var_recordnum
#>   <chr>                   <chr>   <list>     <chr>      <chr>              <int>
#> 1 Atık hizmeti verilen b… CVRBA-… <int [2]>  yillik     medas                  5
#> 2 Atıksu Arıtma Hizmeti … CVRAS-… <int [2]>  yillik     medas                  5
#> 3 Kişi Başı Günlük Atıks… CVRAS-… <int [2]>  yillik     medas                  5

# Download data for a specific variable
population <- geo_data(
  variable_no = "ADNKS-GK137473-O29001",
  variable_level = 3,
  variable_source = "medas",
  variable_period = "yillik",
  variable_recnum = 5
)
head(population, 3)
#> # A tibble: 3 × 3
#>   code  date  toplam_nufus
#>   <chr> <chr> <chr>       
#> 1 39    2024  379031      
#> 2 39    2023  377156      
#> 3 39    2022  369347

# Get map boundaries at different levels
nuts2_map <- geo_map(level = 2)  # 26 regions
nuts3_map <- geo_map(level = 3)  # 81 provinces
lau1_map <- geo_map(level = 4)   # 973 districts

# Preview map data
head(nuts3_map, 3)
#> Simple feature collection with 3 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 27 ymin: 36.54 xmax: 39.26 ymax: 38.4
#> Geodetic CRS:  WGS 84
#> # A tibble: 3 × 6
#>   code  bolgeKodu nutsKodu name     ad                                  geometry
#>   <chr> <chr>     <chr>    <chr>    <chr>                     <MULTIPOLYGON [°]>
#> 1 9     TR32      TR321    AYDIN    AYDIN    (((28.25 37.55, 28.23 37.52, 28.22…
#> 2 1     TR62      TR621    ADANA    ADANA    (((36.18 37.71, 36.19 37.7, 36.14 …
#> 3 2     TRC1      TRC12    ADIYAMAN ADIYAMAN (((38.92 37.82, 38.95 37.8, 38.96 …
```

## Available Map Levels

- **Level 2**: NUTS-2 regions (26 regions)
- **Level 3**: NUTS-3 / Provincial level (81 provinces)
- **Level 4**: LAU-1 / District level (973 districts)
- **Level 9**: Settlement points (returns POINT geometries)

## Documentation

- [Getting
  Started](https://eremrah.com/tuikr/articles/getting-started.html)
- [Geographic Mapping
  Examples](https://eremrah.com/tuikr/articles/geographic-mapping.html)
- [Known Issues](https://eremrah.com/tuikr/articles/known-issues.html)
