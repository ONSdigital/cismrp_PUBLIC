#' @title transform_matrix_to_dataframe_with_dates
#'
#' @description function to transform the draws matrix to a dataframe with each column representing a different date
#'
#' @param draw a matrix containing the draws filtered by region, country and variant (so only one of each)
#' @param country_configs a list object containing the configuration settings for all of the countries
#' @param country a string containing the name of the country you want to filter by
#'
#' @return a dataframe with the added columns
#'
#' @export

transform_matrix_to_dataframe_with_dates <- function(draw, country_configs, country) {
  settings <- country_configs[[country]]$run_settings

  end_date <- settings$end_date

  days_to_model <- settings$n_days_to_model

  dates <- seq(end_date - days_to_model + 1, end_date, 1)

  df <- data.frame(draw)

  colnames(df) <- dates

  return(df)
}
