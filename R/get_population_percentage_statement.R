#' @title Get Population Percentage Statement
#'
#' @description create a sentence summarising the estimated percentage of people with covid with a 1 in x ratio
#'
#' @param prevalence_time_series a dataframe containing the prevalence time series
#'
#' @param REGION a string containing the name of the region you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @return a sentence summarising the estimated number of people with covid with credible intervals
#'
#' @export

get_population_percentage_statement <- function(prevalence_time_series, REGION, VARIANT) {
  reference_day_data <- prevalence_time_series %>%
    dplyr::filter(
      region == REGION,
      variant == VARIANT,
      time == max(as.Date(time, "%Y-%m-%d")) - 3
    ) %>%
    dplyr::mutate(dplyr::across(c(mean, ll, ul), ~ round(.x, 2)))

  one_in_x_ratio <- signif(100 / reference_day_data$mean, 2)

  paste0(
    "This equates to ",
    reference_day_data$mean,
    "% of the population who had COVID-19 (95% credible interval: ",
    reference_day_data$ll,
    "% to ",
    reference_day_data$ul,
    "%) or around 1 in ",
    one_in_x_ratio,
    " people."
  )
}
