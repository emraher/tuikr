#' Get Geographic Data from TUIK
#'
#' Retrieves geographic statistical data from the TUIK geographic portal.
#' Can be used in two modes: metadata retrieval (no parameters) or
#' data download (with all parameters specified).
#'
#' @param variable_level NUTS Level (2, 3, or 4). Required for data download.
#' @param variable_no Character. Data Series Number (e.g., "SNM-GK160951-O33303").
#'   Obtain from metadata mode. Required for data download.
#' @param variable_source Character. Data Series Source. Either "medas" or
#'   "ilGostergeleri". Required for data download.
#' @param variable_period Character. Data Series Period. Either "yillik" (yearly)
#'   or "aylik" (monthly). Required for data download.
#' @param variable_recnum Numeric. Data Series Record Number (3, 5, or 24).
#'   Number of time periods to retrieve. Required for data download.
#'
#' @return Returns different structures depending on usage mode:
#'
#' **Metadata mode** (no parameters): A tibble with 6 columns:
#' \describe{
#'   \item{var_name}{Character. Turkish name of the variable}
#'   \item{var_num}{Character. Variable number/code for queries}
#'   \item{var_levels}{List. Available NUTS levels for this variable}
#'   \item{var_period}{Character. Time period type ("yillik" or "aylik")}
#'   \item{var_source}{Character. Data source ("medas" or "ilGostergeleri")}
#'   \item{var_recordnum}{Numeric. Number of available time periods}
#' }
#'
#' **Data mode** (all parameters): A tibble with 3+ columns:
#' \describe{
#'   \item{code}{Character. Geographic unit code (NUTS-2, NUTS-3, or LAU-1)}
#'   \item{date}{Character. Time period (YYYY or YYYY-MM format)}
#'   \item{[variable_name]}{Numeric/Character. Values for the requested variable.
#'     Column name matches the variable name (snake_case)}
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


  # NOTE: Previous implementation used regex string parsing to extract variable
  # metadata. Replaced with structured JSON parsing using purrr::pluck() for
  # more reliable data extraction.

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
