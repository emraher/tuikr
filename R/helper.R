#' Helper functions
#'
#' @keywords internal
#' @name helpers
NULL

make_request <- function(url) {
  cli <- crul::HttpClient$new(url = url)
  http_response <- cli$post()
  http_response$raise_for_status()
  return(http_response$parse("UTF-8"))
}

check_theme_id <- function(theme) {
  sthemes <- statistical_themes()

  if (length(theme) != 1 || !(theme %in% sthemes$theme_id)) {
    message(crayon::blue("Valid themes and IDs are:"))
    print(sthemes)

    if (length(theme) != 1) {
      stop(crayon::red("You can select only one theme!"))
    } else {
      stop(crayon::red("You should select a valid theme ID!"))
    }
  }

  sthemes
}
