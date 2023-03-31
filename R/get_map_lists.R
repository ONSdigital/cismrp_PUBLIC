#' @title get_map_lists
#'
#' @description Uses the configs to generate lists of variants and countries to iterate over.
#'
#' @param countries a list of countries being run in the pipeline
#'
#' @param country_configs a list of country_configs describing the parameter for the countries being run in the pipeline
#'
#' @return list length 2: containing variant list (a list of all variants found for countries) and country a corresponding list of the same length denoting the corresponding country for each variant in variant list.
#'
#' @export

get_map_lists <- function(countries, country_configs) {
  variant_list <- c(sapply(countries, function(country) {
    country_configs[[country]]$run_settings$variants
  }))

  country_list <- c(sapply(countries, function(country) {
    rep(country, length(country_configs[[country]]$run_settings$variants))
  }))

  if (any(sapply(country_list, FUN = function(X) length(X) == 0))) {
    warning("country_list contains an element of length 0, check all country_configs are being read in correctly")
  }

  if (any(sapply(variant_list, is.null))) {
    warning("variant_list contains a null element, check all country_configs are being read in correctly")
  }

  map_lists <- list(
    variant = variant_list,
    country = country_list
  )

  return(map_lists)
}
