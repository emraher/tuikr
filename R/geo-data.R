#' Get Geographic Data from TUIK
#'
#' Retrieves geographic statistical data from the TUIK geographic portal.
#' Can be used in two modes: metadata retrieval (no parameters) or
#' data download (all five parameters must be provided together).
#'
#' @param variable_no Character. Data Series Number (e.g., "SNM-GK160951-O33303").
#'   Obtain from metadata mode. Required for data download.
#' @param variable_level Numeric. NUTS Level (2, 3, or 4 for NUTS-2, NUTS-3, or LAU-1).
#'   Required for data download.
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
#'   \item{variable_name}{Numeric/Character. Values for the requested variable.
#'     Column name matches the variable name (snake_case). The actual column
#'     name will vary depending on the variable requested.}
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
  data_params <- c(variable_no, variable_level, variable_source, variable_period, variable_recnum)
  data_mode <- !all(sapply(data_params, is.null))

  if (data_mode) {
    if (any(sapply(data_params, is.null))) {
      stop("All parameters (variable_no, variable_level, variable_source, variable_period, variable_recnum) must be provided together for data download.")
    }
    if (!(variable_level %in% c(2, 3, 4))) {
      stop("variable_level must be 2, 3, or 4 (NUTS-2, NUTS-3, or LAU-1)")
    }
  }

  doc <- jsonlite::fromJSON(
    "https://cip.tuik.gov.tr/assets/sideMenu.json?v=2.000",
    simplifyDataFrame = FALSE
  )

  submenu_items <- doc$menu |>
    purrr::map(~ .x$subMenu) |>
    purrr::flatten()

  variable_dt <- tibble::tibble(
    var_name = submenu_items |> purrr::map_chr(~ .x$gostergeAdi),
    var_num = submenu_items |> purrr::map_chr(~ .x$gostergeNo),
    var_levels = submenu_items |> purrr::map(~ .x$duzeyler),
    var_period = submenu_items |> purrr::map_chr(~ .x$period),
    var_source = submenu_items |> purrr::map_chr(~ .x$kaynak),
    var_recordnum = submenu_items |> purrr::map_int(~ .x$kayitSayisi)
  )

  if (is.null(variable_no)) {
    return(variable_dt)
  }

  query_url <- paste0(
    "https://cip.tuik.gov.tr/Home/GetMapData?kaynak=", variable_source,
    "&duzey=", variable_level,
    "&gostergeNo=", variable_no,
    "&kayitSayisi=", variable_recnum,
    "&period=", variable_period
  )

  geo_json_data <- tryCatch(
    jsonlite::fromJSON(query_url),
    error = function(e) {
      stop("Data '", variable_no, "' is not available at NUTS level ", variable_level)
    }
  )

  vals_name <- variable_dt[variable_dt$var_num == variable_no, "var_name", drop = TRUE]

  dates <- if (nchar(geo_json_data$tarihler[1]) == 6) {
    paste(
      stringr::str_sub(geo_json_data$tarihler, 1, 4),
      stringr::str_sub(geo_json_data$tarihler, 5, 6),
      sep = "-"
    )
  } else {
    geo_json_data$tarihler
  }

  formatted_data <- geo_json_data$veriler |>
    tidyr::unnest_wider(col = .data$veri, names_sep = ", ") |>
    purrr::set_names(c("code", dates)) |>
    tidyr::pivot_longer(
      cols = -.data$code,
      names_to = "date",
      values_to = vals_name
    ) |>
    janitor::clean_names() |>
    dplyr::mutate(code = as.character(.data$code))

  return(formatted_data)
}
