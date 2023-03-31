#' @title date_to_clean_string
#'
#' @description convert date type object to yyyymmdd string
#'
#' @param date a date type object <yyyy-mm-dd>
#'
#' @return reformatted date
#'
#' @export

date_to_clean_string <- function(date) {
  gsub(
    pattern = "-",
    replacement = "",
    x = as.character(date)
  )
}
