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
  doc <- xml2::read_html(resp)

  table_data <- doc |>
    rvest::html_table() |>
    purrr::pluck(1) |>
    dplyr::select(1:2) |>
    dplyr::filter(.data$X2 != "") |>
    dplyr::mutate(
      X1 = stringr::str_remove_all(
        .data$X1,
        "\\u0130statistiksel Tablolar(Yeni)?(\r?\n[ ]+)?"
      )
    ) |>
    purrr::set_names("data_name", "data_date")

  table_links <- doc |>
    rvest::html_nodes("a")

  table_urls <- tibble::tibble(
    url = rvest::html_attr(table_links, "href"),
    title = rvest::html_attr(table_links, "title")
  ) |>
    dplyr::filter(.data$title != "Tablo Metaverisi") |>
    dplyr::mutate(url = paste0("http://data.tuik.gov.tr", .data$url)) |>
    dplyr::pull(.data$url)

  theme_info <- sthemes |>
    dplyr::filter(.data$theme_id %in% theme)

  mylocale <- if (Sys.info()["sysname"] == "Windows") {
    "Turkish_Turkey.utf8"
  } else {
    "tr_TR"
  }

  tibble::tibble(
    theme_name = theme_info$theme_name,
    theme_id = theme_info$theme_id,
    data_name = table_data$data_name,
    data_date = lubridate::dmy(table_data$data_date, locale = mylocale),
    datafile_url = table_urls
  )
}
