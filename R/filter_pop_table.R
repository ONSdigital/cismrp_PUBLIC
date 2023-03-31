#### FILTER POP TABLE ####
#
#  1 filter_pop_table
#
#    1.1 merge_boost_regions
#
#    1.2 duplicate_pop_table
#
#### End of contents ####

#' @title filter_pop_table
#'
#' @description filters and cleans the whole uk population counts into DAs and England tables
#'
#' @param population_counts population counts input data.frame
#' @param main_config main config
#' @param country_configs  a list of country configs
#' @param country_list A list of the four UK countries, England, Scotland, Wales and Northern_Ireland
#' @param variant_list a list of the variant 1,2,4,5
#'
#' @export

filter_pop_table <- function(population_counts,
                             main_config,
                             country_configs,
                             country_list,
                             variant_list) {
  filtered_pop_tables <- Map(function(country, variant) {
    config <- country_configs[[country]]

    config$run_settings$end_date <- main_config$run_settings$end_date[[country]]

    population_counts$region <- stringr::str_replace_all(population_counts$region, "Northern_Ireland", "Northern Ireland")

    filtered_pop_counts <- filter_by_country(population_counts, country)
    # filtered_pop_counts <- merge_boost_regions(filtered_pop_counts)

    pop_counts_per_day <- duplicate_pop_table(filtered_pop_counts, config)

    return(pop_counts_per_day)
  }, country_list, variant_list)

  names(filtered_pop_tables) <- paste0(country_list, variant_list)

  return(filtered_pop_tables)
}

#' @title merge_boost_regions
#'
#' @description merge _0, _1 and _2 region names, effectively this removes boost regions from the data
#'
#' @param pop_table data frame
#'
#' @return data frame

merge_boost_regions <- function(pop_table) {
  pop_table$region <- gsub(
    pattern = "(_1)|(_2)|(_3)",
    replacement = "_0",
    x = pop_table$region
  )
  pop_table <- pop_table %>%
    dplyr::group_by(gor_code, sex, age_group, region, lab_id) %>%
    dplyr::summarise(N = sum(N))

  return(pop_table)
}

#' @title Duplicate population tables
#'
#' @description Duplicate input data and add it to the bottom of the data.
#' repeat duplication of original input data a specified number of times.
#'
#' @param pop_table data frame
#' @param config a config list containing $run_settings$n_days_to_model
#'
#' @return data frame

duplicate_pop_table <- function(pop_table, config) {
  n_days_to_model <- config$run_settings$n_days_to_model

  if (!(ncol(pop_table) > 1)) {
    stop("data frame should have more than one variable")
  }

  duplicate_pop_table <- data.frame(apply(pop_table, 2, function(x) rep(x, n_days_to_model)))

  duplicate_pop_table$study_day <- sort(rep(c(0:(n_days_to_model - 1)), times = nrow(pop_table)))

  return(duplicate_pop_table)
}
