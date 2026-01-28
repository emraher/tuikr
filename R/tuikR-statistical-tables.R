#' Get Statistical Tables for a Theme from TUIK
#'
#' Retrieves all statistical tables available for a specific theme from the
#' TUIK data portal. Theme IDs can be obtained using \code{\link{statistical_themes}}.
#'
#' @param theme Character or numeric. A single theme ID (e.g., "102" or 102).
#'   Only one theme can be queried at a time. Invalid or multiple theme IDs
#'   will return an error with a list of valid themes.
#'
#' @return A tibble with 5 columns:
#' \describe{
#'   \item{theme_name}{Character. Turkish name of the statistical theme}
#'   \item{theme_id}{Character. Numeric ID of the theme}
#'   \item{data_name}{Character. Name/description of the statistical table}
#'   \item{data_date}{Date. Publication or update date of the table}
#'   \item{datafile_url}{Character. Direct download URL for the table file (usually Excel)}
#' }
#'
#' @note TUIK Excel files often have irregular formatting (multiple headers,
#'   mixed languages, source notes). Manual cleaning may be required after download.
#'
#' @examples
#' \dontrun{
#' # Get all themes first
#' themes <- statistical_themes()
#'
#' # Get tables for a specific theme
#' tables <- statistical_tables(102)
#'
#' # Download a specific table
#' download.file(tables$datafile_url[1], destfile = "data.xls")
#' }
#'
#' @export
statistical_tables <- function(theme) {
  sthemes <- check_theme_id(theme)

  request_url <- paste0(
    "https://data.tuik.gov.tr/Kategori/GetIstatistikselTablolar?UstId=",
    theme,
    "&DilId=1&Page=1&Count=10000&Arsiv=true"
  )

  resp <- make_request(request_url)

  doc <- resp %>%
    xml2::read_html()

  table_names <- doc %>%
    rvest::html_table() %>%
    `[[`(1) %>%
    dplyr::select(-X3, -X4) %>%
    dplyr::filter(X2 != "") %>%
    dplyr::mutate(X1 = stringr::str_remove_all(X1, "\\u0130statistiksel TablolarYeni\r\n[ ]+")) %>%
    dplyr::mutate(X1 = stringr::str_remove_all(X1, "\\u0130statistiksel Tablolar\r\n[ ]+")) |>
    dplyr::mutate(X1 = stringr::str_remove_all(X1, "\\u0130statistiksel Tablolar\n[ ]+"))

  table_urls <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")

  table_meta <- doc %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("title")

  table_urls <- tibble::tibble(table_urls, table_meta) %>%
    dplyr::filter(table_meta != "Tablo Metaverisi") %>%
    dplyr::select(-table_meta) %>%
    dplyr::mutate(table_urls = paste0("http://data.tuik.gov.tr", table_urls))

  sthemes <- sthemes %>%
    dplyr::filter(theme_id %in% theme)

  # Quick fix for locale
  mylocale <- dplyr::if_else(Sys.info()["sysname"] == "Windows", "Turkish_Turkey.utf8", "tr_TR")


  st <- tibble::tibble(table_names, table_urls) %>%
    purrr::set_names("data_name", "data_date", "datafile_url") %>%
    dplyr::mutate(data_date = lubridate::dmy(data_date, locale = mylocale)) %>%
    dplyr::bind_cols(sthemes) %>%
    dplyr::select(theme_name, theme_id, tidyselect::everything())


  return(st)
}
