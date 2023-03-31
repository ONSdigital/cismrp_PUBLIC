#' @title Get Summary Statement
#'
#' @description create a sentence summarising the latest trends
#'
#' @param prevalence_time_series a dataframe containing the prevalence time series
#'
#' @param REGION a string containing the name of the region you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @return a sentence summarising the latest week/s trend statements.
#'
#' @export

get_summary_statement <- function(prevalence_time_series, REGION, VARIANT) {
  filtered_data <- prevalence_time_series %>%
    dplyr::filter(
      region == REGION,
      variant == VARIANT,
      comparison_period == 7
    ) %>%
    dplyr::mutate(dplyr::across(tidyselect::contains("summary"), tolower))


  certain_statements <- c("very likely increased", "likely increased", "likely decreased", "very likely decreased")

  outcome_certain <- paste0("The percentage of people testing positive in ", REGION, " has ", filtered_data$summary_current, " in the most recent week.")

  outcome_constant_at_reference_points <- paste0("The percentage of people testing positive in ", REGION, " is likely similar to that in the previous week.")

  outcome_uncertain_1w_only <- paste0("The trend is uncertain in ", REGION, "in the most recent week. However rates ", filtered_data$summary_previous, " over two weeks.")

  outcome_uncertain_both_weeks <- paste0("The trend is uncertain in ", REGION, ".")


  if (filtered_data$summary_current %in% certain_statements) {
    final_statement <- outcome_certain
  } else if (filtered_data$summary_current == "likely constant at reference points") {
    final_statement <- outcome_constant_at_reference_points
  } else if (filtered_data$summary_current == "trend uncertain" & filtered_data$summary_previous %in% certain_statements) {
    final_statement <- outcome_uncertain_1w_only
  } else {
    final_statement <- outcome_uncertain_both_weeks
  }

  return(final_statement)
}
