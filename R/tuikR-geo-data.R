#' Get Geographic Data from TUIK
#'
#' Downloads geographic statistical data from the TUIK Geographic Portal.
#' Can be used in two modes: metadata retrieval (no parameters) or data
#' download (all parameters required).
#'
#' @param variable_no Character. Data series number (e.g., "SNM-GK160951-O33303").
#'   Required when downloading data. Find available series using metadata mode.
#' @param variable_level Numeric. NUTS level: 2 (regional), 3 (provincial), or
#'   4 (district/LAU-1). Required when downloading data.
#' @param variable_source Character. Data source: "medas" or "ilGostergeleri".
#'   Required when downloading data.
#' @param variable_period Character. Time period: "yillik" (yearly) or "aylik" (monthly).
#'   Required when downloading data.
#' @param variable_recnum Numeric. Record number: 3, 5, or 24.
#'   Required when downloading data.
#'
#' @return When called without parameters: A tibble with 6 columns containing
#'   metadata for all available variables:
#' \describe{
#'   \item{var_name}{Character. Variable name in Turkish}
#'   \item{var_num}{Character. Variable series number}
#'   \item{var_levels}{List. Available NUTS levels for this variable}
#'   \item{var_period}{Character. Time period (yillik/aylik)}
#'   \item{var_source}{Character. Data source (medas/ilGostergeleri)}
#'   \item{var_recordnum}{Numeric. Record count}
#' }
#'
#' When called with all parameters: A tibble with 3+ columns containing the data:
#' \describe{
#'   \item{code}{Character. Geographic area code}
#'   \item{date}{Character. Time period (YYYY or YYYY-MM)}
#'   \item{...}{Numeric/Character. Variable-specific data column (name varies)}
#' }
#'
#' @examples
#' \dontrun{
#' # Get metadata for all available variables
#' geo_data()
#'
#' # Get data for a specific variable at NUTS-2 level
#' geo_data(
#'   variable_level = 2,
#'   variable_no = "SNM-GK160951-O33303",
#'   variable_source = "medas",
#'   variable_period = "yillik",
#'   variable_recnum = 5
#' )
#' }
#'
#' @export
geo_data <- function(variable_no = NULL,
                     variable_level = NULL,
                     variable_source = NULL,
                     variable_period = NULL,
                     variable_recnum = NULL) {
  if (is.null(variable_level)) {
    variable_level <- 2
  } else {
    if (!(variable_level %in% c(2, 3, 4))) stop("There's no IBBS at this level!")
  }


  doc <- xml2::read_html("https://cip.tuik.gov.tr/assets/sideMenu.json?v=2.000") %>%
    rvest::html_text() |>
    rjson::fromJSON()




  var_num <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~ purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~ purrr::pluck(.x, "gostergeNo")) |>
    unlist()

  var_name <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~ purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~ purrr::pluck(.x, "gostergeAdi")) |>
    unlist()

  var_levels <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~ purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~ purrr::pluck(.x, "duzeyler"))

  var_period <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~ purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~ purrr::pluck(.x, "period")) |>
    unlist()

  var_source <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~ purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~ purrr::pluck(.x, "kaynak")) |>
    unlist()

  var_recordnum <- purrr::pluck(doc[2], "menu") |>
    purrr::map(~ purrr::pluck(.x, "subMenu")) |>
    purrr::flatten() |>
    purrr::map(~ purrr::pluck(.x, "kayitSayisi")) |>
    unlist()

  # Parse JSON structure using purrr (replaced regex-based string parsing)
  variable_dt <- tibble::tibble(
    var_name, var_num, var_levels,
    var_period, var_source, var_recordnum
  )

  if (is.null(variable_no)) {
    return(variable_dt)
  } else {
    query_url <- paste0(
      "https://cip.tuik.gov.tr/Home/GetMapData?kaynak=", variable_source,
      "&duzey=", variable_level,
      "&gostergeNo=", variable_no,
      "&kayitSayisi=", variable_recnum,
      "&period=", variable_period
    )

    # query_url <- dplyr::case_when(
    #   level == 2 ~ paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=medas&duzey=2&gostergeNo=", variable, "&kayitSayisi=5&period=yillik"),
    #   level == 3 ~ paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=medas&duzey=3&gostergeNo=", variable, "&kayitSayisi=5&period=yillik"),
    #   level == 4 ~ paste0("https://cip.tuik.gov.tr/Home/GetMapData?kaynak=medas&duzey=4&gostergeNo=", variable, "&kayitSayisi=5&period=yillik")
    # )

    tryCatch(
      expr = {
        dat <- jsonlite::fromJSON(query_url)
      },
      error = function(e) {
        stop(paste0("This data (", variable_no, ") is not available at this NUTS level (level = ", variable_level, ")!!!"))
      }
    )

    vals_name <- unlist(variable_dt[variable_dt$var_num == variable_no, "var_name"])

    if (nchar(dat$tarihler[1]) == 6) {
      dates <- paste(stringr::str_sub(dat$tarihler, 1, 4), stringr::str_sub(dat$tarihler, 5, 6), sep = "-")
    } else {
      dates <- dat$tarihler
    }

    res <- dat$veriler %>%
      tidyr::unnest_wider(data = ., col = veri, names_sep = ", ") %>%
      purrr::set_names(c("code", dates)) %>%
      tidyr::pivot_longer(-code,
        names_to = "date",
        values_to = vals_name
      ) %>%
      janitor::clean_names() %>%
      dplyr::mutate(code = as.character(code))

    return(res)
  }
}
