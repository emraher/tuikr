# Get Geographic Maps from TUIK

Downloads spatial boundary data from the TUIK geographic portal at
different administrative levels. Returns simple features (sf) objects
with geometries in WGS 84 coordinate reference system (EPSG:4326).

## Usage

``` r
geo_map(level = 2, dataframe = FALSE)
```

## Arguments

- level:

  Numeric. Administrative level to retrieve:

  2

  :   NUTS-2 (İstatistiki Bölge Birimleri Sınıflaması - Level 2)

  3

  :   NUTS-3 / Provincial level (İl)

  4

  :   LAU-1 / District level (İlçe)

  9

  :   Settlement points (Yerleşim yerleri) - returns POINT geometries

- dataframe:

  Logical. If TRUE, returns a regular tibble without geometry. If FALSE
  (default), returns an sf object with spatial data.

## Value

An sf object (or tibble if dataframe = TRUE) with different columns
depending on the level:

**Levels 2, 3, 4** return MULTIPOLYGON geometries with columns:

- code:

  Character. Unique geographic code (renamed from `duzeyKodu`)

- bolgeKodu:

  Character. NUTS region code

- nutsKodu:

  Character. NUTS classification code

- ad:

  Character. Geographic unit name in Turkish

- geometry:

  sfc_MULTIPOLYGON. Spatial boundaries (WGS 84)

**Level 9** returns POINT geometries with columns:

- ad:

  Character. Settlement name in Turkish

- tp:

  Integer. Settlement type code

- bs:

  Integer. Classification code

- bm:

  Integer. Additional classification

- geometry:

  sfc_POINT. Point coordinates (WGS 84)

## See also

[`geo_data`](https://eremrah.com/tuikr/reference/geo_data.md) for
geographic statistical data

## Examples

``` r
if (FALSE) { # \dontrun{
# Download NUTS-3 boundaries as sf object
nuts3_sf <- geo_map(level = 3)

# Drop geometry — return plain tibble for joins
nuts3_tbl <- geo_map(level = 3, dataframe = TRUE)

# Settlement points (POINT geometry)
settlements <- geo_map(level = 9)
} # }
```
