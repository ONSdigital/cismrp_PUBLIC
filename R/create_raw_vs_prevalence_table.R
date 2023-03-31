#### CREATE RAW VS PREVALENCE TABLE ####
#
#  1. create_raw_vs_prevalence_table
#
#    1.1 make_trimmed_raw_and_prevalence
#
#### End of module ####

#' @title Create Raw vs Prevalence Table
#'
#' @description function to create raw vs prevalence table by region or country
#'
#' @param aggregated_sample a dataframe containing the raw participant sample
#' @param aggregated_HH a dataframe containing the raw household sample
#' @param prevalence_time_series a dataframe containing the modelled prevalence
#' estimates
#' @param COUNTRY a string containing the name of the country you want to filter by
#' @param region_or_country a string containing either 'region' or 'country'
#'
#' @return a styled html table with raw and prevalence data
#'
#' @export
create_raw_vs_prevalence_table <- function(aggregated_sample,
                                           aggregated_HH,
                                           prevalence_time_series,
                                           COUNTRY,
                                           region_or_country) {
  raw_and_prevalence <- create_raw_counts_with_prevalence(
    aggregated_sample,
    aggregated_HH,
    prevalence_time_series
  ) %>%
    dplyr::filter(country == COUNTRY)


  raw_and_prevalence %>%
    make_trimmed_raw_and_prevalence(region_or_country)
}

#' @title Make Trimmed Raw and Prevalence
#'
#' @description Takes in a raw and prevalence table and formats it using the kable package.
#'
#' @param raw_and_prevalence data frame
#'
#' @param region_or_country character either "region" or "country"
#'
#' @return a kable table
make_trimmed_raw_and_prevalence <- function(raw_and_prevalence, region_or_country) {
  trim_date <- max(lubridate::ymd(raw_and_prevalence$visit_date) - 17)

  trimmed_data <- raw_and_prevalence %>%
    dplyr::mutate(visit_date = lubridate::ymd(visit_date)) %>%
    dplyr::filter(visit_date >= trim_date) %>%
    dplyr::mutate(
      proportion = round(proportion, 4),
      mean_estimate = round(mean_estimate, 2),
      visit_date = format(visit_date, "%d %b %y")
    ) %>%
    dplyr::rename(
      "Region" = region,
      "Total Sample" = N,
      "Visit Date" = visit_date,
      "Positives" = positives,
      "Unweighted Mean (%)" = proportion,
      "Modelled Mean (%)" = mean_estimate,
      `Households with Positives` = n_hh_with_pos,
      `Most Positives in Household` = max_pos_hh
    )


  if (region_or_country == "region") {
    filtered_data <- trimmed_data %>%
      dplyr::filter(Region != country) %>%
      dplyr::select(-country)
    embolden <- TRUE
  } else {
    filtered_data <- trimmed_data %>%
      dplyr::filter(Region == country) %>%
      dplyr::select(-Region, -country)
    embolden <- FALSE
  }

  table <- filtered_data %>%
    kableExtra::kbl(align = "c") %>%
    kableExtra::kable_styling(
      bootstrap_options = "striped",
      font_size = 18,
      position = "left",
      full_width = TRUE
    ) %>%
    kableExtra::column_spec(column = 1:2, bold = embolden) %>%
    kableExtra::collapse_rows(columns = 1, valign = "middle") %>%
    kableExtra::scroll_box(width = "100%", height = "470px")
  return(table)
}
