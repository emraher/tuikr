#' Get Statistical Databases for a Theme from TUIK
#'
#' Retrieves interactive database URLs for a specific theme from the TUIK data
#' portal. Theme IDs can be obtained using \code{\link{statistical_themes}}.
#'
#' @param theme Character or numeric. A single theme ID (e.g., "110" or 110).
#'   Only one theme can be queried at a time. Invalid or multiple theme IDs
#'   will return an error with a list of valid themes.
#'
#' @return A tibble with 4 columns:
#' \describe{
#'   \item{theme_name}{Character. Turkish name of the statistical theme}
#'   \item{theme_id}{Character. Numeric ID of the theme}
#'   \item{db_name}{Character. Name of the interactive database}
#'   \item{db_url}{Character. URL to access the database interface}
#' }
#'
#' @note Some database links may become unavailable if TUIK changes their
#'   website structure. Database URLs lead to interactive query interfaces,
#'   not direct downloads.
#'
#' @examples
#' \dontrun{
#' # Get databases for a specific theme
#' databases <- statistical_databases(110)
#'
#' # View available databases
#' print(databases)
#' }
#'
#' @export

statistical_databases <- function(theme) {
  sthemes <- check_theme_id(theme)

  request_url <- paste0(
    "https://data.tuik.gov.tr/Kategori/GetVeritabanlari?UstId=",
    theme,
    "&DilId=1&Page=1&Count=10000&Arsiv=true"
  )

  resp <- make_request(request_url)

  doc <- resp %>%
    xml2::read_html()

  db_name <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()

  db_url <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")

  sthemes <- statistical_themes() %>%
    dplyr::filter(.data$theme_id %in% theme)

  db <- tibble::tibble(db_name, db_url) %>%
    dplyr::bind_cols(sthemes) %>%
    dplyr::select(.data$theme_name, .data$theme_id, tidyselect::everything())
}
