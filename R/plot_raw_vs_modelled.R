#### PLOT RAW VS MODELLED ####
#
#  1. plot_raw_vs_modelled
#
#    1.1 get_sample_and_hh_rolling_means
#
#      1.1.1 get_rolling_means
#
#        1.1.1.1 get_positives_and_totals_from_raw
#
#        1.1.1.2 aggregate_raw_england_region_stats
#
#        1.1.1.3 filter_by_region_or_country
#
#        1.1.1.4 format_visit_dates
#
#        1.1.1.5 positivity_rolling_mean
#
#          1.1.1.5.1 lag_twice_and_sum
#
#    1.2 plot_positivity_and_raw
#
#### End of module ####

#' @title Plot Raw vs Modelled
#'
#' @description plot the raw household and sample data against the modelled data
#'
#' @param sample_data a dataframe containing the aggregated_sample
#'
#' @param household_data a dataframe containing the aggregated_HH the aggregated household datafor
#'
#' @param prevalence_time_series a dataframe containing the prevalence time series
#'
#' @param COUNTRY  string containing the name of a country to filter by
#'
#' @param country_configs a list object containing the configuration settings
#'
#' @param region_or_country string containing 'region' or 'country' levels
#'
#' @export

plot_raw_vs_modelled <- function(sample_data,
                                 household_data,
                                 prevalence_time_series,
                                 COUNTRY,
                                 country_configs,
                                 region_or_country) {
  filtered_prevalence <- prevalence_time_series %>%
    dplyr::filter(variant == "ctall")

  if (region_or_country == "country") {
    filtered_prevalence_by_region_country <- filtered_prevalence %>%
      dplyr::filter(region == COUNTRY)
  } else {
    filtered_prevalence_by_region_country <- filtered_prevalence %>%
      dplyr::filter(
        country == COUNTRY,
        region != country
      )
  }

  rolling_means <- get_sample_and_hh_rolling_means(
    sample_data,
    household_data,
    COUNTRY,
    country_configs,
    region_or_country
  )

  plot_positivity_and_raw(
    filtered_prevalence_by_region_country,
    rolling_means$sample_data,
    rolling_means$household_data,
    region_or_country
  )
}

#' @title get_sample_and_hh_rolling_means
#'
#' @description parent function to get sample and household 3-day rolling means
#'
#' @param sample_data a dataframe containing the aggregated_sample
#'
#' @param household_data a dataframe containing the aggregated_HH the aggregated household datafor
#' @param country_filter string containing the name of a country to filter by
#'
#' @param country_configs a list object containing the configuration settings
#'
#' @param region_or_country string containing 'region' or 'country' levels
#'
#' @return a list containing both the sample_data and the household_data with a 3-day rolling positivity_rate

get_sample_and_hh_rolling_means <- function(sample_data,
                                            household_data,
                                            country_filter,
                                            country_configs,
                                            region_or_country) {
  datasets <- list(
    sample_data = sample_data,
    household_data = household_data
  )

  purrr::map(
    .x = datasets,
    .f = get_rolling_means,
    country_filter,
    region_or_country,
    country_configs
  )
}

#' @title get_rolling_means
#'
#' @description function to calculate 3-day rolling means and append to dataframe
#'
#' @param data a dataframe from which the rolling means will be calculated
#'
#' @param country_filter a string containing the country to be filtered
#'
#' @param region_or_country a string containing either 'region' or 'country'
#'
#' @param country_configs a list object containing the configuration settings
#'
#' @return a data frame with 3-day rolling means

get_rolling_means <- function(data, country_filter, region_or_country, country_configs) {
  cleaned_data <- clean_region(data, "gor_name")

  formatted_data <- get_positives_and_totals_from_raw(cleaned_data)

  aggregated_data <- aggregate_raw_england_region_stats(formatted_data, country_filter, region_or_country)

  filtered_data <- filter_by_region_or_country(aggregated_data, country_filter, region_or_country) %>%
    format_visit_dates() %>%
    filter_dates(data = ., country_configs, country_filter)



  rolling_mean <- positivity_rolling_mean(filtered_data)

  return(rolling_mean)
}

#' @title get_positives_and_totals_from_raw
#'
#' @description function to get positive totals from raw aggregated data
#'
#' @param data a dataframe containing the data from which to retrieve the positives and totals
#'
#' @return a dataframe with the positives and totals

get_positives_and_totals_from_raw <- function(data) {
  colnames <- names(data)

  # if any colnames are NOT in the vector
  if (!any(colnames %in% c("n_pos", "n_neg"))) {
    data %>%
      dplyr::mutate(
        n_total = n_hh_for_pos,
        n_pos = n_hh_with_pos
      )
  } else {
    data %>%
      dplyr::mutate(n_total = n_pos + n_neg)
  }
}

#' @title aggregate_raw_england_region_stats
#'
#' @description function to aggregate England region raw statistics for comparison with modelled data
#'
#' @param data a data frame from which you want to caluclate the statistics
#'
#' @param country_filter a string containing the country to be filtered
#'
#' @param region_or_country a string containing either 'region' or 'country'
#'
#' @return a dataframe with aggregated region statistics

aggregate_raw_england_region_stats <- function(data, country_filter, region_or_country) {
  if (region_or_country == "country" & country_filter == "England") {
    data %>%
      dplyr::group_by(visit_date) %>%
      dplyr::summarise(
        n_pos = sum(n_pos, na.rm = TRUE),
        n_total = sum(n_total, na.rm = TRUE)
      ) %>%
      dplyr::mutate(region = "England") %>%
      dplyr::ungroup()
  } else {
    return(data)
  }
}

#' @title filter_by_region_or_country
#'
#' @description filters dataframe and keeps specific regions or countries
#'
#' @param data a data frame containing the dataset to filter
#' @param country_filter string continaing the name of a specific country for which to filter
#' @param region_or_country a string containing either 'region' or 'country'
#'
#' @return dataframe which has been filtered keeping only specific regions

filter_by_region_or_country <- function(data, country_filter, region_or_country) {
  regions <- gcptools::england_regions

  if (region_or_country == "region") {
    dplyr::filter(data, region %in% regions)
  } else {
    dplyr::filter(data, region == country_filter)
  }
}

#' @title format_visit_dates
#'
#' @description function to format visit dates from string (day month year) to date format
#'
#' @param data a dataframe containing the data with dates to reformat
#'
#' @return a dataframe with the reformatted visit_dates

format_visit_dates <- function(data) {
  data %>%
    dplyr::mutate(visit_date = lubridate::dmy(visit_date))
}

#' @title positivity_rolling_mean
#'
#' @description function to caluclate the 3-day rolling mean for raw positivity estimates
#'
#' @param data a dataframe containing the raw data
#'
#' @return a data frame with 3-day rolling means appended

positivity_rolling_mean <- function(data) {
  rolling_means <- data %>%
    dplyr::group_by(region, visit_date) %>%
    dplyr::summarise(
      n_total = sum(n_total, na.rm = T),
      n_pos = sum(n_pos, na.rm = T)
    ) %>%
    dplyr::group_by(region) %>%
    dplyr::arrange(visit_date) %>%
    dplyr::mutate(
      dplyr::across(c(n_pos, n_total), lag_twice_and_sum, .names = "{.col}_spread"),
      positivity_rate = n_pos_spread / n_total_spread
    ) %>%
    dplyr::ungroup()

  return(rolling_means)
}

#' @title lag_twice_and_sum
#'
#' @description function to lag a vector two times and sum the values
#'
#' @param vector a vector of data for which to lag twice and sum
#'
#' @return a new vector which has been lagged twice and summed

lag_twice_and_sum <- function(vector) {
  assertive.types::assert_is_numeric(c(1, 2, 3, 4))
  vector + dplyr::lag(vector, 1) + dplyr::lag(vector, 2)
}

#' @title plot_positivity_and_raw
#'
#' @description generates a plot with modelled positivity, household rolling positivity and test rolling positivity
#'
#' @param household_rolling_means data frame with 3-day rolling household positivity
#'
#' @param sample_rolling_means data frame with 3-day rolling test positivity
#'
#' @param prevalence_time_series MRP modelled_data series
#
#' @param region_or_country whether to plot by region
#'
#' @return overlay plot with mrp estimates and raw data, and horizontally aligned regional plots

plot_positivity_and_raw <- function(prevalence_time_series,
                                    sample_rolling_means,
                                    household_rolling_means,
                                    region_or_country) {
  prevalence_time_series <- prevalence_time_series %>%
    dplyr::mutate(
      time = as.Date(time, "%Y-%m-%d"),
      dplyr::across(c(mean, ll, ul), ~ .x / 100)
    )

  date_axis_breaks <- seq(max(prevalence_time_series$time), min(prevalence_time_series$time), -7)

  legend_labels <- stringr::str_wrap(c(
    "Un-modelled %",
    "Un-modelled household %",
    "Modelled estimates"
  ), 25)

  plot <- ggplot2::ggplot() +
    ggplot2::geom_line(
      data = prevalence_time_series,
      ggplot2::aes(
        x = time,
        y = mean,
        colour = "Modelled estimates"
      ),
      na.rm = TRUE
    ) +
    ggplot2::geom_ribbon(
      data = prevalence_time_series,
      ggplot2::aes(
        x = time,
        ymin = ll,
        ymax = ul,
        colour = "Modelled estimates"
      ),
      fill = "#00BA38",
      alpha = 0.3,
      na.rm = TRUE
    ) +
    ggplot2::geom_line(
      data = sample_rolling_means,
      ggplot2::aes(
        x = visit_date,
        y = positivity_rate,
        colour = "Un-modelled %"
      ),
      alpha = 0.7,
      na.rm = TRUE
    ) +
    ggplot2::geom_line(
      data = household_rolling_means,
      ggplot2::aes(
        x = visit_date,
        y = positivity_rate,
        colour = "Un-modelled household %"
      ),
      alpha = 0.4,
      na.rm = TRUE
    ) +
    ggplot2::labs(
      title = paste0("Model fit against raw data"),
      x = "Date",
      y = "Prevalence"
    ) +
    ggplot2::scale_colour_manual(
      name = "Positivity",
      guide = ggplot2::guide_legend(override.aes = list(fill = c("#00BA38", "white", "white"))),
      values = c(
        "#00BA38",
        "#F8766D",
        "#619CFF"
      ),
      labels = c(
        "Modelled estimates",
        "Un-modelled %",
        "Un-modelled household %"
      )
    ) +
    ggplot2::scale_y_continuous(
      expand = c(0, 0),
      position = "left",
      labels = scales::percent_format(accuracy = 0.1)
    ) +
    ggplot2::scale_x_date(
      date_labels = "%d\n %b",
      breaks = date_axis_breaks
    ) +
    theme_CIS()
  add_region_or_country_layer(plot, region_or_country)
}
