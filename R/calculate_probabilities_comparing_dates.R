#### CALCULATE PROBABILITIES COMPARING DATES ####
#
# 1 calculate_probabilities_comparing_dates
#
#   1.1 calculate_probabilities_by_country_and_variant
#
#     1.1.1 create_comparison_dates_dataframe
#
#       1.1.1.1 get_reference_dates
#
#     1.1.2 probability_of_increase
#
#       1.1.2.1 probability_reference_greater_than_comparison
#
#     1.1.3 probability_of_at_least_x_percent_increase
#
#       1.1.3.1 probability_reference_at_least_x_percent_greater_than_comparison
#
#     1.1.4 probability_of_at_least_x_percent_decrease
#
#       1.1.4.1 probability_reference_at_least_x_percent_less_than_comparison
#
#     1.1.5 wrangle_probabilities_to_shape
#
#     1.1.6 add_trend_summary
#
#     1.1.7 recode_variant_names
#
#### End of contents ####

#' @title calculate_probabilities_comparing_dates
#'
#' @description a function that iterates ofver the calcualte probabilities_by_region_country_and_variant_function and binds the outputs together into a single dataframe.
#'
#' @param region_list a string containing the name of the region you want to filter by
#' @param country_list a string containing the name of the country you want to filter by
#' @param variant_list a string containing the name of the variant you want to filter by
#' @param post_stratified_draws a list object containing the post-stratified draws from the model
#' @param country_configs a list object containing the configuration settings for each country
#'
#' @return a matrix containing the predicted draws for the specific region, country and variant
#' @export

calculate_probabilities_comparing_dates <- function(post_stratified_draws,
                                                    country_configs,
                                                    region_list,
                                                    country_list,
                                                    variant_list) {
  parameters <- filter_for_region_country_and_variant(
    region_list,
    country_list,
    variant_list
  )

  probabilities_by_region_country_and_variant <- purrr::pmap(
    .l = parameters,
    .f = calculate_probabilities_by_region_country_and_variant,
    post_stratified_draws,
    country_configs
  )

  probabilities <- purrr::map_df(probabilities_by_region_country_and_variant, rbind)

  return(probabilities)
}

#' @title calculate_probabilities_by_region_country_and_variant
#'
#' @description function to filter post_stratified_draws by region, country and variant to keep only one type.
#'
#' @param region a string containing the name of the region you want to filter by
#' @param country a string containing the name of the country you want to filter by
#' @param variant a string containing the name of the variant you want to filter by
#' @param post_stratified_draws a list object containing the post-stratified draws from the model
#' @param country_configs a list object containing the configuration settings for each country
#'
#' @return a matrix containing the predicted draws for the specific region, country and variant

calculate_probabilities_by_region_country_and_variant <- function(region,
                                                                  country,
                                                                  variant,
                                                                  post_stratified_draws,
                                                                  country_configs) {
  filter_draws_by_region_country_and_variant(post_stratified_draws, region, country, variant) %>%
    create_comparison_dates_dataframe(country_configs, country) %>%
    probability_of_increase() %>%
    probability_of_at_least_x_percent_increase(country_configs, country) %>%
    probability_of_at_least_x_percent_decrease(country_configs, country) %>%
    add_region_country_and_variant_cols(region, country, variant) %>%
    wrangle_probabilities_to_shape() %>%
    add_trend_summary(country_configs, country) %>%
    recode_variant_names() %>%
    dplyr::select(
      comparison_period,
      region,
      probability_increase,
      tidyselect::contains("prob_min_"),
      summary,
      country,
      variant
    )
}

#' @title create_comparison_dates_dataframe
#'
#' @description function to create a dataframe of reference day and comparison date draws
#'
#' @param draw a matrix of draws (rows) by date (cols)
#' @param country_configs a list object containing the country configuration settings
#' @param country a string containing the name of the country you want to filter by
#'
#' @return a dataframe of the reference day and comparison day draws

create_comparison_dates_dataframe <- function(draw, country_configs, country) {
  reference_dates <- get_reference_dates(country_configs, country)

  transform_matrix_to_dataframe_with_dates(draw, country_configs, country) %>%
    dplyr::select(
      "reference_day" = format(!!reference_dates$reference_date, "%Y-%m-%d"),
      "week_minus_1" = format(!!reference_dates$week_minus_1, "%Y-%m-%d"),
      "week_minus_2" = format(!!reference_dates$week_minus_2, "%Y-%m-%d")
    )
}

#' @title Get reference dates
#'
#' @description gets reference dates from country_config for each country
#'
#' @param country_configs a list object containing the country configuration settings
#' @param country a string containing the name of the country you want to filter by
#'
#' @return list of reference dates

get_reference_dates <- function(country_configs, country = c("England", "Scotland", "Wales", "Northern Ireland")) {
  settings <- country_configs[[country]]$probability_output_settings

  comparison_period <- settings$comparison_period
  ref_days_from_end <- settings$ref_days_from_end

  end_date <- country_configs[[country]]$run_settings$end_date

  reference_date <- end_date - ref_days_from_end

  comparison_dates <- end_date - (comparison_period + ref_days_from_end)

  week_minus_1 <- comparison_dates[1]

  week_minus_2 <- comparison_dates[2]

  dates <- list("reference_date" = reference_date, "week_minus_1" = week_minus_1, "week_minus_2" = week_minus_2)

  return(dates)
}

#' @title probability_of_increase
#'
#' @description function to calculate the probability of being above 1 and 2 weeks
#'
#' @param data a dataframe containing reference_day and week_minus_1 and week_minus_2 columns
#'
#' @return a dataframe with the added columns

probability_of_increase <- function(data) {
  data %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("week"),
        .fns = ~ probability_reference_greater_than_comparison(
          reference_day,
          .x
        ),
        .names = "probability_increase_{.col}"
      )
    )
}

#' @title probability_reference_greater_than_comparison
#'
#' @description function to calculate the probability that a reference group of draws is higher than the comparison group
#'
#' @param reference a vector of draws you want to use as your reference group in comparisons
#' @param comparison a vector of draws you want to use as your comparison group.
#'
#' @return a dataframe with the added columns

probability_reference_greater_than_comparison <- function(reference, comparison) {
  round(sum(reference > comparison) / length(reference) * 100, 2)
}

#' @title probability_of_at_least_x_percent_increase
#'
#' @description function to calculate the probability of being x% above previous weeks estimates.
#' i.e what percentage of the reference_day draws are 15 or more percent above the comparison dates draws on average
#'
#' @param data a dataframe containing reference_day and week_minus_1 and week_minus_2 columns
#' @param country_configs a list object containing the configuration settings for the country
#' @param country a string containing the name of the country you want to filter by
#'
#' @return a dataframe with the added columns

probability_of_at_least_x_percent_increase <- function(data, country_configs, country) {
  percent_change_threshold <- country_configs[[country]]$probability_output_settings$percent_change_threshold

  variable_name <- paste0("prob_min_", percent_change_threshold, "_percent_increase")

  data %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("week"),
        .fns = ~ probability_reference_at_least_x_percent_greater_than_comparison(
          reference_day,
          .x,
          percent_change_threshold
        ),
        .names = "{variable_name}_{.col}"
      )
    )
}

#' @title probability_reference_at_least_x_percent_greater_than_comparison
#'
#' @description function to calculate the probability that a reference group of draws is at least x percent (decided by the percent_change_threshold) greater than the comparison group.
#'
#' @param reference a vector of draws you want to use as your reference group in comparisons
#' @param comparison a vector of draws you want to use as your comparison group
#' @param percent_change_threshold a numeric value between 0-100 which to use as the threshold to determine significant change.
#'
#' @return a dataframe with the added columns

probability_reference_at_least_x_percent_greater_than_comparison <- function(reference,
                                                                             comparison,
                                                                             percent_change_threshold) {
  round(sum((reference - comparison) > comparison * percent_change_threshold / 100) / length(reference) * 100, 2)
}

#' @title probability_of_at_least_x_percent_decrease
#'
#' @description function to calculate the probability of being x% below previous weeks estimates.
#' i.e what percentage of the reference_day draws are 15 or more percent below the comparison dates draws on average.
#'
#' @param data a dataframe containing reference_day and week_minus_1 and week_minus_2 columns
#' @param country_configs a list object containing the configuration settings for the country
#' @param country a string containing the name of the country you want to filter by
#'
#' @return a dataframe with the added columns

probability_of_at_least_x_percent_decrease <- function(data, country_configs, country) {
  percent_change_threshold <- country_configs[[country]]$probability_output_settings$percent_change_threshold

  variable_name <- paste0("prob_min_", percent_change_threshold, "_percent_decrease")

  data %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("week"),
        .fns = ~ probability_reference_at_least_x_percent_less_than_comparison(
          reference_day,
          .x,
          percent_change_threshold
        ),
        .names = "{variable_name}_{.col}"
      )
    )
}

#' @title probability_reference_at_least_x_percent_less_than_comparison
#'
#' @description function to calculate the probability that a reference group of draws is at least x percent (decided by the percent_change_threshold) less than the comparison group.
#'
#' @param reference a vector of draws you want to use as your reference group in comparisons
#' @param comparison a vector of draws you want to use as your comparison group
#' @param percent_change_threshold a numeric value between 0-100 which to use as the threshold to determine significant change.

probability_reference_at_least_x_percent_less_than_comparison <- function(reference,
                                                                          comparison,
                                                                          percent_change_threshold) {
  round(sum((comparison - reference) > comparison * percent_change_threshold / 100) / length(reference) * 100, 2)
}

#' @title wrangle_probabilities_to_shape
#'
#' @description function to format probabilities data into correct shape
#'
#' @param data a probabilities dataframe which you want to get into shape
#'
#' @return a reformatted dataframe which has removed duplication and reshaped for interpretation.

wrangle_probabilities_to_shape <- function(data) {
  data %>%
    dplyr::select(!c(reference_day, week_minus_1, week_minus_2)) %>%
    unique() %>%
    tidyr::pivot_longer(
      cols = tidyselect::contains("week_minus"),
      names_to = c("type", "comparison_period"),
      names_pattern = "(.*)_(week_minus_.*)",
      values_to = "comparison_value"
    ) %>%
    tidyr::pivot_wider(
      names_from = type,
      values_from = comparison_value
    ) %>%
    dplyr::mutate(comparison_period = dplyr::case_when(
      comparison_period == "week_minus_1" ~ "7",
      comparison_period == "week_minus_2" ~ "14"
    )) %>%
    unique()
}


#' @title Add Trend Summary
#'
#' @description function to determine the trend_statement from the probability scores
#'
#' @param likelihood_data a dataframe containing the probability scores
#' @param country_configs a list object containing the configuration settings by country
#' @param country a string containing the name of the country you want to filter by
#'
#' @return a data frame

add_trend_summary <- function(likelihood_data,
                              country_configs,
                              country) {
  percent_change_threshold <- country_configs[[country]]$probability_output_settings$percent_change_threshold

  prob_min_x_percent_increase <- paste0("prob_min_", percent_change_threshold, "_percent_increase")
  prob_min_x_percent_decrease <- paste0("prob_min_", percent_change_threshold, "_percent_decrease")

  likelihood_data %>%
    dplyr::mutate(
      "summary" = dplyr::case_when(
        dplyr::between(probability_increase, 0, 10) ~ "Very likely decreased",
        dplyr::between(probability_increase, 10.01, 20) ~ "Likely decreased",
        !!rlang::sym(prob_min_x_percent_increase) + !!rlang::sym(prob_min_x_percent_decrease) <= 20 ~ "Likely constant at reference points",
        dplyr::between(probability_increase, 20.01, 79.99) &
          !!rlang::sym(prob_min_x_percent_increase) + !!rlang::sym(prob_min_x_percent_decrease) > 20 ~ "Trend uncertain",
        dplyr::between(probability_increase, 80, 89.99) ~ "Likely increased",
        dplyr::between(probability_increase, 90, 100) ~ "Very likely increased"
      )
    )
}


#' @title recode_variant_names
#'
#' @description function to recode variant names from numbers to ct reference strings
#'
#' @param data a probabilities dataframe which you want to reformat the variant column of
#'
#' @return a dataframe with the recoded variant column

recode_variant_names <- function(data) {
  data %>%
    dplyr::mutate(variant = dplyr::case_when(
      variant == "1" ~ "ctall",
      variant == "2" ~ "ct4",
      variant == "4" ~ "ct7",
      variant == "5" ~ "ctnot4not7"
    ))
}
