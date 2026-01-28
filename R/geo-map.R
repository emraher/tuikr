#' Get Geographic Maps from TUIK
#'
#' Downloads spatial boundary data from the TUIK geographic portal at different
#' administrative levels. Returns simple features (sf) objects with geometries
#' in WGS 84 coordinate reference system (EPSG:4326).
#'
#' @param level Numeric. Administrative level to retrieve:
#' \describe{
#'   \item{2}{NUTS-2 (İstatistiki Bölge Birimleri Sınıflaması - Level 2)}
#'   \item{3}{NUTS-3 / Provincial level (İl)}
#'   \item{4}{LAU-1 / District level (İlçe)}
#'   \item{9}{Settlement points (Yerleşim yerleri) - returns POINT geometries}
#' }
#'
#' @param dataframe Logical. If TRUE, returns a regular tibble without geometry.
#'   If FALSE (default), returns an sf object with spatial data.
#'
#' @return An sf object (or tibble if dataframe = TRUE) with different columns
#'   depending on the level:
#'
#' **Levels 2, 3, 4** return MULTIPOLYGON geometries with columns:
#' \describe{
#'   \item{code}{Character. Unique geographic code}
#'   \item{bolgeKodu}{Character. NUTS region code}
#'   \item{nutsKodu}{Character. NUTS classification code}
#'   \item{name}{Character. Geographic unit name (often in English)}
#'   \item{ad}{Character. Geographic unit name in Turkish}
#'   \item{geometry}{sfc_MULTIPOLYGON. Spatial boundaries (WGS 84)}
#' }
#'
#' **Level 9** returns POINT geometries with columns:
#' \describe{
#'   \item{ad}{Character. Settlement name in Turkish}
#'   \item{tp}{Integer. Settlement type code}
#'   \item{bs}{Integer. Classification code}
#'   \item{bm}{Integer. Additional classification}
#'   \item{geometry}{sfc_POINT. Point coordinates (WGS 84)}
#' }
#'
#' @examples
#' \dontrun{
#' geo_map(level = 2)
#' }
#'
#' @export
geo_map <- function(level = 2, dataframe = FALSE) {
  if (!(level %in% c(2, 3, 4, 9))) {
    stop("level must be 2, 3, 4, or 9")
  }

  urls <- c(
    "2" = "https://cip.tuik.gov.tr/assets/geometri/nuts2.json",
    "3" = "https://cip.tuik.gov.tr/assets/geometri/nuts3.json",
    "4" = "https://cip.tuik.gov.tr/assets/geometri/nuts4.json",
    "9" = "https://cip.tuik.gov.tr/assets/geometri/yerlesim_noktalari.json"
  )

  query_url <- urls[as.character(level)]

  map_json_data <- tryCatch(
    jsonlite::fromJSON(query_url),
    error = function(e) {
      stop("Map data not available at level ", level)
    }
  )

  dt_sf <- map_json_data |>
    jsonlite::toJSON() |>
    stringr::str_replace_all('\\[\"FeatureCollection\"\\]', '\"FeatureCollection\"') |>
    sf::read_sf()

  if (level != 9) {
    dt_sf <- dt_sf |>
      dplyr::rename(code = .data$duzeyKodu) |>
      dplyr::mutate(code = as.character(.data$code))
  }

  if (!dataframe) {
    return(dt_sf)
  }

  sf::st_drop_geometry(dt_sf)
}
