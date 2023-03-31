#' @title filter dates
#'
#' @description filter dates outside of the date range for the analysis
#'
#' @param data data frame
#' @param country_configs list object containing the countries config
#' @param country a string containing the name of the country you want to filter by
#'
#' @return data frame
#'
#' @export

filter_dates <- function(data, country_configs, country) {
  settings <- country_configs[[country]]$run_settings

  end_date <- settings$end_date

  days_to_model <- settings$n_days_to_model

  start_date <- end_date - days_to_model

  data <- data %>%
    dplyr::filter(visit_date <= end_date & visit_date > start_date) %>%
    dplyr::mutate(study_day = as.numeric(visit_date - min(visit_date)))

  return(data)
}
