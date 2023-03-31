#### CREATE PREVALENCE SERIES ####
#
# 1 create_prevalence_series
#
#   1.1 create_prevalence_by_region_country_and_variant
#
#   1.2 calculate_means_and_cis
#
#### End of contents ####

#' @title create_prevalence_series
#' @description gets the prevalence time series output from the list of poststratified draws
#' @param country_configs  a list of country configs
#' @param post_stratified_draws a list of poststratified draws (country x variant)
#' @param country_list A list of the four UK countries, England, Scotland, Wales and Northern_Ireland
#' @param region_list a list of the regions
#' @param variant_list a list of the variant 1, 2, 4, 5
#' @export
create_prevalence_series <- function(country_configs,
                                     post_stratified_draws,
                                     region_list,
                                     country_list,
                                     variant_list) {
  parameters <- filter_for_region_country_and_variant(
    region_list,
    country_list,
    variant_list
  )

  prevalence_series_list <- purrr::pmap(
    .l = parameters,
    .f = create_prevalence_by_region_country_and_variant,
    post_stratified_draws,
    country_configs
  )

  prevalance_series <- do.call(rbind, prevalence_series_list)

  return(prevalance_series)
}

#' @title create_prevalence_by_region_country_and_variant
#'
#' @description function to create summarised prevalence estimates (mean, ll, ul) by region country and variant
#'
#' @param region a string containing the name of the region you want to filter by
#' @param country a string containing the name of the country you want to filter by
#' @param variant a string containing the name of the variant you want to filter by
#' @param post_stratified_draws a list of poststratified draws (country x variant)
#' @param country_configs a list object containing the country configuration settings
#'
#' @return a dataframe with summarised prevalence estimates by region, country, variant

create_prevalence_by_region_country_and_variant <- function(region,
                                                            country,
                                                            variant,
                                                            post_stratified_draws,
                                                            country_configs) {
  filter_draws_by_region_country_and_variant(
    post_stratified_draws,
    region, country, variant
  ) %>%
    transform_matrix_to_dataframe_with_dates(country_configs, country) %>%
    calculate_means_and_cis() %>%
    add_region_country_and_variant_cols(region, country, variant) %>%
    dplyr::select(region, "time" = date, mean, ll, ul, country, variant) %>%
    dplyr::mutate(
      variant = as.character(variant),
      variant = dplyr::case_match(variant,
        "1" ~ "ctall",
        "2" ~ "ct4",
        "4" ~ "ct7",
        "5" ~ "ctnot4not7",
        .default = variant
      ),
      dplyr::across(c(mean, ll, ul), .fns = ~ .x * 100)
    )
}

#' @title calculate_means_and_cis
#'
#' @description function to calculate means and credible intervals for the set of draws you have provided.
#'
#' @param draws a dataframe containing the poststratified draws for a specific region, country and variant, with each column containing draws for each date.
#'
#' @return a dataframe containing the date, mean, ll (lower credible interval), and ul (upper credible interval)

calculate_means_and_cis <- function(draws) {
  draws %>%
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(), ~ mean(.x, na.rm = TRUE),
        .names = "mean_{.col}"
      ),
      dplyr::across(
        !dplyr::contains("mean"),
        .fns = ~ stats::quantile(.x, probs = 0.025),
        .names = "ll_{.col}"
      ),
      dplyr::across(
        !tidyselect::matches("mean|ll"),
        .fns = ~ stats::quantile(.x, probs = 0.975),
        .names = "ul_{.col}"
      )
    ) %>%
    dplyr::select(tidyselect::matches("mean|ll|ul")) %>%
    unique() %>%
    tidyr::pivot_longer(cols = dplyr::everything(), names_to = "measure", values_to = "value") %>%
    dplyr::mutate(
      date = gsub(".*_", "", measure),
      measure = sub("_.*", "", measure)
    ) %>%
    tidyr::pivot_wider(names_from = measure, values_from = value)
}
