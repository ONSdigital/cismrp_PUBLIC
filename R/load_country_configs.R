#' @title load the country configuration files
#'
#' @description loads pipeline configurations from country yaml files
#'
#' @param countries list of countries
#' @param main_config overall pipeline config settings
#'
#' @return list of country configurations
#'
#' @export

load_country_configs <- function(countries, main_config) {
  test <- main_config$run_settings$test_configs_short

  if (test == TRUE) {
    folder <- "configs_short/"
  } else if (test == FALSE) {
    folder <- "configs_long/"
  }

  country_configs <- lapply(countries, function(country) {
    config <- yaml::read_yaml(paste0(folder, country, "_config.yaml"))

    config$run_settings$end_date <- main_config$run_settings$end_date[[country]]

    return(config)
  })

  names(country_configs) <- countries

  return(country_configs)
}
