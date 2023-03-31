#### CREATE RAW COUNTS WITH PREVALENCE ####
#
#  1 create_raw_counts_with_prevalence
#
#    1.1 prepare_sample_and_household_for_joining
#
#      1.1.1 transform_gor_name_to_full_name
#
#      1.1.2 aggregate_england_from_regions_and_date
#
#    1.2 join_raw_data
#
#    1.3 join_raw_with_prevalence
#
#### End of module ####

#' @title Create Raw Counts with Prevalence
#'
#' @description a function to join the cleaned raw data with the modelled prevalence estimates
#'
#' @param aggregated_sample a dataframe containing the raw participant sample
#' @param aggregated_HH a dataframe containing the raw household sample
#' @param prevalence_time_series a dataframe containing the modelled prevalence estimates
#'
#' @return a dataframe with the modelled estimates combined with raw counts
#'
#' @export

create_raw_counts_with_prevalence <- function(aggregated_sample,
                                              aggregated_HH,
                                              prevalence_time_series) {
  prepare_sample_and_household_for_joining(aggregated_sample, aggregated_HH) %>%
    join_raw_data() %>%
    join_raw_with_prevalence(prevalence_time_series)
}

#' @title Prepare Sample and Household Data for Joining
#'
#' @description carry out prepatory cleaning and formatting of the aggregated sample and
#' aggregated household files so that they are compatible for joining
#'
#' @param aggregated_sample a dataframe containing the raw participant sample
#' @param aggregated_HH a dataframe containing the raw household sample
#'
#' @return a list object containing the cleaned participant and household samples
prepare_sample_and_household_for_joining <- function(aggregated_sample, aggregated_HH) {
  clean_sample <- aggregated_sample %>%
    transform_gor_name_to_full_name() %>%
    dplyr::mutate(time = as.character(lubridate::dmy(visit_date))) %>%
    aggregate_england_from_regions_and_date() %>%
    dplyr::mutate(
      positives = n_pos,
      total = n_pos + n_neg,
      group = "participant",
      most_positives_within = 0
    ) %>%
    dplyr::select(
      group,
      region,
      country,
      time,
      total,
      positives,
      most_positives_within
    )


  clean_hh <- aggregated_HH %>%
    transform_gor_name_to_full_name() %>%
    dplyr::mutate(time = as.character(lubridate::dmy(visit_date))) %>%
    aggregate_england_from_regions_and_date() %>%
    dplyr::mutate(
      total = n_hh_for_pos,
      positives = n_hh_with_pos,
      most_positives_within = max_pos_hh,
      group = "household"
    ) %>%
    dplyr::select(
      group,
      region,
      country,
      time,
      total,
      positives,
      most_positives_within
    ) %>%
    tidyr::replace_na(list(most_positives_within = 0))

  output <- list(
    clean_sample = clean_sample,
    clean_hh = clean_hh
  )

  return(output)
}

#' @title Transform gor_name to Full Geography Area Name
#'
#' @description function to format gor_names to full names for region and country
#'
#' @param data a data frame containing the gor_name column
#'
#' @return a dataframe with the NUTS1 regions and UK countries

transform_gor_name_to_full_name <- function(data) {
  geography_codes <- list(
    "7_LD" = "London",
    "8_SE" = "South East",
    "2_NW" = "North West",
    "9_SW" = "South West",
    "5_WM" = "West Midlands",
    "4_EM" = "East Midlands",
    "6_EE" = "East of England",
    "3_YH" = "Yorkshire and The Humber",
    "1_NE" = "North East",
    "10_NI" = "Northern Ireland",
    "11_SCO" = "Scotland",
    "12_WAL" = "Wales"
  )


  data %>%
    dplyr::mutate(
      region = as.character(geography_codes[gor_name]),
      country = dplyr::case_match(region,
        gcptools::england_regions ~ "England",
        .default = region
      )
    )
}

#' @title Aggregate England by Region and Time Columns
#'
#' @description function to create England from the NUTS1 England regions
#'
#' @param data a data frame containing two columns (region and time)
#'
#' @return a dataframe with England as a region, as well as the NUTS1 regions
aggregate_england_from_regions_and_date <- function(data) {
  data %>%
    dplyr::filter(region %in% gcptools::england_regions) %>%
    dplyr::group_by(time, region) %>%
    dplyr::summarise(dplyr::across(tidyselect::where(is.double),
      .fns = ~ sum(.x, na.rm = TRUE)
    ), .groups = "drop") %>%
    dplyr::mutate(region = "England") %>%
    dplyr::bind_rows(data)
}

#' @title Join Raw Data
#'
#' @description a function to join the cleaned household and participant data
#' into a single data frame
#'
#' @param cleaned_raw_data a list object containing clean_sample and clean_hh dataframes
#'
#' @return a dataframe with the particpant and household data combined
join_raw_data <- function(cleaned_raw_data) {
  cleaned_raw_data$clean_sample %>%
    dplyr::bind_rows(cleaned_raw_data$clean_hh) %>%
    dplyr::group_by(region, time, group) %>%
    dplyr::summarise(
      dplyr::across(c(total, positives),
        .fns = ~ sum(.x, na.rm = TRUE)
      ),
      most_positives_within = max(most_positives_within, na.rm = TRUE),
      unweighted_percentage = round((positives / total) * 100, 2)
    ) %>%
    dplyr::mutate(
      most_positives_within = dplyr::case_match(group,
        "participant" ~ NA,
        .default = most_positives_within
      )
    ) %>%
    tidyr::pivot_wider(
      id_cols = c("region", "time"),
      names_from = group,
      values_from = c(
        unweighted_percentage,
        total,
        positives,
        most_positives_within
      )
    )
}

#' @title Join Raw with Prevalence
#'
#' @description a function to join the cleaned and joined particpant and household data
#' with the modelled prevalence time series.
#'
#' @param cleaned_raw_data a dataframe containing the cleaned and joined particpant and
#' household raw data
#' @param prevalence_time_series a dataframe containing the modelled prevalence estimates
#'
#' @return a dataframe with the raw and modelled data combined together
join_raw_with_prevalence <- function(cleaned_raw_data, prevalence_time_series) {
  prevalence_time_series %>%
    dplyr::filter(variant == "ctall") %>%
    dplyr::left_join(cleaned_raw_data, by = c("region", "time")) %>%
    dplyr::select(region,
      country,
      "visit_date" = time,
      "N" = total_participant,
      "positives" = positives_participant,
      "n_hh_with_pos" = positives_household,
      "max_pos_hh" = most_positives_within_household,
      "proportion" = unweighted_percentage_participant,
      "mean_estimate" = mean
    )
}
