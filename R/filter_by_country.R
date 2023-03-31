#' @title filter by country
#'
#' @description fiter data by country
#'
#' @param data data frame
#' @param country country to keep in the data ("England", "Wales", "Scotland", "NI")
#'
#' @returns data frame
#'
#' @export

filter_by_country <- function(data, country) {
  if (country == "England") {
    data <- data[!data$region %in% c("Scotland", "Northern Ireland", "Wales"), ]
  } else if (country == "Scotland") {
    data <- data[data$region == "Scotland", ]
  } else if (country == "Wales") {
    data <- data[data$region == "Wales", ]
  } else if (country == "Northern Ireland") {
    data <- data[data$region == "Northern Ireland", ]
  }

  return(data)
}
