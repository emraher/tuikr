#' Get Statistical Themes and URLs from TUIK
#'
#' Retrieves all available statistical themes from the TUIK data portal.
#' Theme IDs are used with \code{\link{statistical_tables}} and
#' \code{\link{statistical_databases}} to access specific data.
#'
#' @return A tibble with 2 columns:
#' \describe{
#'   \item{theme_name}{Character. Turkish name of the statistical theme}
#'   \item{theme_id}{Character. Numeric ID used to query tables and databases}
#' }
#'
#' @examples
#' \dontrun{
#' # Get all available themes
#' themes <- statistical_themes()
#'
#' # View theme names and IDs
#' print(themes)
#' }
#'
#' @export
statistical_themes <- function() {
  doc <- xml2::read_html("https://data.tuik.gov.tr/") %>%
    rvest::html_nodes("div.text-center") %>%
    rvest::html_nodes("a")

  theme_name <- doc %>%
    rvest::html_text() %>%
    stringr::str_trim()

  theme_id <- doc %>%
    rvest::html_attr("href") %>%
    stringr::str_extract_all("[:digit:]+") %>%
    unlist()

  statistical_themes <- tibble::tibble(theme_name, theme_id)

  return(statistical_themes)
}
