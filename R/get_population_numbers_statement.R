#' @title Get Population Numbers Statement
#'
#' @description create a sentence summarising the estimated number of people with covid-19
#'
#' @param filtered_pop_tables a dataframe containing the population totals by demographic
#'
#' @param prevalence_time_series a dataframe containing the prevalence time series
#'
#' @param REGION a string containing the name of the region you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @return a sentence summarising the estimated number of people with covid with credible intervals

get_population_numbers_statement <- function(filtered_pop_tables, prevalence_time_series, REGION, VARIANT) {
  pop_total <- get_country_pop_total(filtered_pop_tables, REGION)

  end_date <- max(as.Date(prevalence_time_series$time, "%Y-%m-%d"))

  start_of_week <- end_date - 6

  formatted_end_date <- format(end_date, "%d %B %Y")

  formatted_start_of_week <- format(start_of_week, "%d %B %Y")

  reference_day_data <- prevalence_time_series %>%
    dplyr::filter(
      region == REGION,
      variant == VARIANT,
      time == end_date
    ) %>%
    dplyr::mutate(dplyr::across(c(mean, ll, ul),
      .fns = ~ format(round((.x / 100) * pop_total, -2), big.mark = ","),
      .names = "pop_{.col}"
    ))

  paste0(
    "Between ",
    formatted_start_of_week,
    " and ",
    formatted_end_date,
    ", we estimate that an average of ",
    reference_day_data$pop_mean,
    " people in ",
    REGION,
    " had COVID-19 (95% credible interval: ",
    reference_day_data$pop_ll,
    " to ",
    reference_day_data$pop_ul,
    ")."
  )
}

#' @title Get Country Population Totals
#'
#' @description retrieves a specific countries population totals from the filtered_pop_tables
#'
#' @param filtered_pop_tables a dataframe containing the population totals by demographic
#'
#' @param country a string containing the name of a country you want to filter by
#'
#' @return a value containing the aggregated population for that given country

get_country_pop_total <- function(filtered_pop_tables, country) {
  country_variant <- paste0(country, 1)

  filtered_pop_tables[[country_variant]] %>%
    dplyr::filter(study_day == 1) %>%
    dplyr::group_by(study_day) %>%
    dplyr::summarise(N = sum(as.numeric(N))) %>%
    dplyr::pull(N)
}
