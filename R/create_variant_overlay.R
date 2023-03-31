#### CREATE OVERLAY PLOT ####
#
#  1. create_variant_overlay
#
#    1.1 relabel_variants
#
#### End of module ####

#' @title Create Variant Overlay
#'
#' @description creates a plot comparing each variant over time
#'
#' @param prevalence_time_series MRP modelled_data series
#'
#' @param COUNTRY character
#'
#' @param main_config a list object containing the configuration settings for the system
#'
#' @param region_or_country character either "region" or "country"
#'
#' @return plot
#'
#' @export

create_variant_overlay <- function(prevalence_time_series, COUNTRY, main_config, region_or_country) {
  filtered_data <- prevalence_time_series %>%
    dplyr::filter(country == COUNTRY) %>%
    dplyr::mutate(time = lubridate::ymd(time)) %>%
    relabel_variants(main_config) %>%
    dplyr::mutate("Variant" = stringr::str_wrap(variant, 12))



  if (region_or_country == "region") {
    filtered_by_region_country <- filtered_data %>%
      dplyr::filter(region != COUNTRY)
  } else {
    filtered_by_region_country <- filtered_data %>%
      dplyr::filter(region == COUNTRY)
  }

  date_axis_breaks <- seq(max(filtered_by_region_country$time), min(filtered_by_region_country$time), -7)

  end_date <- max(filtered_by_region_country$time)

  vline_intercepts <- c(
    "1 week prior" = end_date - 10,
    "2 weeks prior" = end_date - 17,
    "Reference Day" = end_date - 3
  )

  vline_labels <- c(
    "1 week prior",
    "2 weeks prior",
    "Reference Day"
  )

  plot <- ggplot2::ggplot(data = filtered_by_region_country) +
    purrr::map2(vline_intercepts, vline_labels, ~ ggplot2::geom_vline(ggplot2::aes(xintercept = as.Date(.x), colour = .y),
      linetype = "longdash",
      size = 0.6
    )) +
    ggplot2::geom_line(mapping = ggplot2::aes(x = time, y = mean / 100, group = Variant)) +
    ggplot2::geom_ribbon(
      mapping = ggplot2::aes(x = time, ymin = ll / 100, ymax = ul / 100, fill = Variant),
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
    ggplot2::scale_colour_manual(
      name = "",
      guide = "legend",
      values = c(
        "#fc8d62",
        "#8da0cb",
        "#66c2a5"
      )
    ) +
    ggplot2::labs(
      title = paste0("Prevalence by variant in ", COUNTRY),
      x = "Date",
      y = "Prevalence"
    )


  add_region_or_country_layer(plot, region_or_country)
}

#' @title Relabel Variants
#'
#' @description re-label variant column with the replacements from the main_config
#'
#' @param prevalence_time_series MRP modelled_data series
#' @param main_config a list object containing the configuration settings for the system
#'
#' @return a dataframe with the relabeled variants

relabel_variants <- function(prevalence_time_series, main_config) {
  prevalence_time_series %>%
    dplyr::mutate(variant = as.character(main_config$variant_labels[variant]))
}
