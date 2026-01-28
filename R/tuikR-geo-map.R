#' Get Geographic Boundary Maps from TUIK
#'
#' Downloads geographic boundary data from the TUIK Geographic Portal as sf objects
#' for creating choropleth maps and spatial analysis.
#'
#' @param level Numeric. Geographic level:
#' \describe{
#'   \item{2}{NUTS-2 (26 regions) - MULTIPOLYGON}
#'   \item{3}{NUTS-3 (81 provinces) - MULTIPOLYGON}
#'   \item{4}{LAU-1 (973 districts) - MULTIPOLYGON}
#'   \item{9}{Settlement points (1000+ locations) - POINT}
#' }
#' @param dataframe Logical. If TRUE, returns a regular tibble without geometry.
#'   If FALSE (default), returns an sf object.
#'
#' @return An sf object (or tibble if dataframe = TRUE) with WGS 84 CRS (EPSG:4326).
#'
#' For levels 2, 3, 4 (MULTIPOLYGON):
#' \describe{
#'   \item{code}{Character. Geographic area code (duzeyKodu)}
#'   \item{bolgeKodu}{Character. Regional code}
#'   \item{nutsKodu}{Character. NUTS classification code}
#'   \item{name}{Character. English name}
#'   \item{ad}{Character. Turkish name}
#'   \item{geometry}{MULTIPOLYGON. Boundary geometry}
#' }
#'
#' For level 9 (POINT):
#' \describe{
#'   \item{ad}{Character. Settlement name}
#'   \item{tp}{Numeric. Type indicator}
#'   \item{bs}{Numeric. Status indicator}
#'   \item{bm}{Numeric. Municipality indicator}
#'   \item{geometry}{POINT. Location coordinates}
#' }
#'
#' @examples
#' \dontrun{
#' # Get provincial boundaries (NUTS-3)
#' provinces <- geo_map(level = 3)
#'
#' # Get settlement points
#' settlements <- geo_map(level = 9)
#'
#' # Get data without geometry
#' districts_df <- geo_map(level = 4, dataframe = TRUE)
#' }
#'
#' @export
geo_map <- function(level = c(2, 3, 4, 9), dataframe = FALSE) {
  if (is.null(level)) {
    level <- 9
  } else {
    if (!(level %in% c(2, 3, 4, 9))) stop("There's no IBBS at this level!")
  }

  # Direct JSON endpoints (replaced V8-based JavaScript execution for simplicity)
  query_url <- dplyr::case_when(
    level == 2 ~ "https://cip.tuik.gov.tr/assets/geometri/nuts2.json",
    level == 3 ~ "https://cip.tuik.gov.tr/assets/geometri/nuts3.json",
    level == 4 ~ "https://cip.tuik.gov.tr/assets/geometri/nuts4.json",
    level == 9 ~ "https://cip.tuik.gov.tr/assets/geometri/yerlesim_noktalari.json"
  )

  tryCatch(
    expr = {
      dat <- jsonlite::fromJSON(query_url)
    },
    error = function(e) {
      stop(paste0("Mapping is not available at this NUTS level (level = ", level, ")!!!"))
    }
  )


  dt_sf <- dat %>%
    jsonlite::toJSON() %>%
    stringr::str_replace_all(
      '\\[\"FeatureCollection\"\\]',
      '\"FeatureCollection\"'
    ) %>%
    sf::read_sf()

  if (level != 9) {
    dt_sf <- dt_sf %>%
      dplyr::rename("code" = "duzeyKodu") %>%
      dplyr::mutate(code = as.character(code))
  }


  if (dataframe == FALSE) {
    return(dt_sf)
  } else {
    dt <- sf::st_drop_geometry(dt_sf)
    return(dt)
  }
}
