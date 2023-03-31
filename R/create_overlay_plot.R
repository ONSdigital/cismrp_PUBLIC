#### CREATE OVERLAY PLOT ####
#
#  1. create_overlay_plot
#
#    1.1 combine_current_and_previous_prevalence
#
#### End of module ####

#' @title Create Overlay Plot
#'
#' @description creates overlay plot which overlays current prevalence estimates with previous estimates
#'
#' @param prevalence_time_series a dataframe containing the prevalence time series
#'
#' @param previous_prevalence_time_series a dataframe containing the previous prevalence time series
#'
#' @param COUNTRY a string containing the name of a country you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @param region_or_country specify "country" for one ggplot object of data from an individial country, specify "region" for ggplot object of England regions
#'
#' @return a ggplot object containing the current and previous prevalence time series layered on top of the same chart
#'
#' @export

create_overlay_plot <- function(prevalence_time_series,
                                previous_prevalence_time_series,
                                COUNTRY,
                                VARIANT,
                                region_or_country) {
  combined_prevalence <- combine_current_and_previous_prevalence(
    prevalence_time_series,
    previous_prevalence_time_series
  )

  filtered_prevalence <- filter_plot_by_region_country_and_variant(
    combined_prevalence,
    COUNTRY,
    VARIANT,
    region_or_country
  ) %>%
    dplyr::mutate(
      time = as.Date(time, "%Y-%m-%d"),
      dplyr::across(c(mean, ll, ul), ~ .x / 100)
    )

  lab_title <- paste0(
    "Percentage of people testing positive for COVID-19 in ",
    COUNTRY
  )

  date_axis_breaks <- seq(max(filtered_prevalence$time), min(filtered_prevalence$time), -7)

  plot <- ggplot2::ggplot(data = filtered_prevalence, ggplot2::aes(group = Version)) +
    ggplot2::geom_line(ggplot2::aes(
      x = as.Date(time, ),
      y = mean,
      colour = Version
    )) +
    ggplot2::geom_ribbon(
      ggplot2::aes(
        x = time,
        ymin = ll,
        ymax = ul,
        fill = Version
      ),
      alpha = 0.3
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
    theme_CIS() +
    # theme(plot.title = element_text(size = 15))+
    ggplot2::labs(
      title = lab_title,
      x = "Date",
      y = "Prevalence"
    )

  add_region_or_country_layer(plot, region_or_country)
}

#' @title Combine Current and Previous Prevalence
#'
#' @description binds current and previous prevalence data frames together
#'
#' @param current a dataframe containing the prevalence time series
#'
#' @param previous a dataframe containing the previous prevalence time series
#'
#' @return a data frame

combine_current_and_previous_prevalence <- function(current, previous) {
  trimmed_previous <- previous %>%
    dplyr::select(names(current))

  dplyr::bind_rows(Current = current, Previous = trimmed_previous, .id = "Version") %>%
    dplyr::mutate(Version = factor(Version, levels = c("Previous", "Current")))
}
