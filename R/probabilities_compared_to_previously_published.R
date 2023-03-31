#### PROBABILITIES COMPARED TO PREVIOUSLY PUBLISHED ####
#
#  1 probabilities_compared_to_previously_published
#
#    1.1 combine_probabilities
#
#    1.2 add_conditional_formatting_to_trends
#
#### End of contents ####

#' @title probabilities_compared_to_previously_published
#'
#' @description function to compare current and previous probabilities and prepare table for use in qa report
#'
#' @param probabilities a dataframe which you want to reformat the variant column of
#' @param previous_probabilities a dataframe containing the previous probabilities
#'
#' @return a dataframe with the probabilities
#'
#' @export

probabilities_compared_to_previously_published <- function(probabilities, previous_probabilities) {
  combined_probabilities <- combine_probabilities(probabilities, previous_probabilities)

  formatted_probabtilities <- add_conditional_formatting_to_trends(combined_probabilities)

  return(formatted_probabtilities)
}



#' @title combine_probabilities
#'
#' @description function to bind together current and previous probabilities into one dataframe
#'
#' @param probabilities a dataframe containing the current probabilities
#' @param previous_probabilities a dataframe containing the previous probabitlities
#'
#' @return a dataframe with the combined probablities (both current and previous)

combine_probabilities <- function(probabilities, previous_probabilities) {
  dplyr::bind_rows(
    "current" = probabilities,
    "previous" = previous_probabilities,
    .id = "version"
  ) %>%
    dplyr::select(!tidyselect::contains("prob_min")) %>%
    tidyr::pivot_wider(
      names_from = "version",
      values_from = c("probability_increase", "summary")
    ) %>%
    dplyr::select(
      comparison_period, region, variant,
      probability_increase_current, summary_current,
      probability_increase_previous, summary_previous
    )
}

#' @title add_conditional_formatting_to_trends
#'
#' @description adds conditional formatting to probability/trend tables
#'
#' @param probs_over_time_prep outputted probs_over time
#'
#' @return data.frame

add_conditional_formatting_to_trends <- function(probs_over_time_prep) {
  probs_over_time <- probs_over_time_prep %>%
    dplyr::mutate(
      formatting_current = dplyr::case_when(
        summary_current == "Very likely increased" ~ rgb(170, 0, 0, max = 255, alpha = 100, names = "darkred50"),
        summary_current == "Likely increased" ~ rgb(250, 0, 0, max = 255, alpha = 85, names = "red2_33"),
        summary_current == "Likely constant at reference points" ~ rgb(245, 245, 179, max = 255, alpha = 85, names = "wheat33"),
        summary_current == "Trend uncertain" ~ "white",
        summary_current == "Likely decreased" ~ rgb(143, 200, 143, max = 255, alpha = 125, names = "darkseagreen50"),
        summary_current == "Very likely decreased" ~ rgb(130, 155, 130, max = 255, alpha = 125, names = "darkseagreen_custom50"),
        TRUE ~ "NA"
      ),
      formatting_previous = dplyr::case_when(
        summary_previous == "Very likely increased" ~ rgb(170, 0, 0, max = 255, alpha = 100, names = "darkred50"),
        summary_previous == "Likely increased" ~ rgb(250, 0, 0, max = 255, alpha = 85, names = "red2_33"),
        summary_previous == "Likely constant at reference points" ~ rgb(245, 245, 179, max = 255, alpha = 85, names = "wheat33"),
        summary_previous == "Trend uncertain" ~ "white",
        summary_previous == "Likely decreased" ~ rgb(143, 200, 143, max = 255, alpha = 125, names = "darkseagreen50"),
        summary_previous == "Very likely decreased" ~ rgb(130, 155, 130, max = 255, alpha = 125, names = "darkseagreen_custom50"),
        TRUE ~ "NA"
      )
    )

  return(probs_over_time)
}
