#### CREATE OVERLAY PLOT ####
#
#  1. spaghetti_plot
#
#    1.1 combine_draws_to_single_df
#
#      1.1.1 create_region_variant_country_combos
#
#      1.1.2 transform_draws_to_df
#
#### End of module ####

#' @title Spaghetti Plot
#'
#' @description creates a plot showing how the individual sample draws come together to create the mean and credible intervals
#'
#' @param prevalence_time_series a dataframe containing the prevalence time series
#'
#' @param post_stratified_draws a dataframe of poststratified draws
#'
#' @param COUNTRY a string containing the name of a country you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @param region_or_country specify "country" for one ggplot object of data from an individial country, specify "region" for ggplot object of England regions
#'
#' @param main_config list of configuration settings
#'
#' @return a ggplot object containing the spaghetti plot
#'
#' @export

spaghetti_plot <- function(prevalence_time_series, post_stratified_draws, COUNTRY, VARIANT, region_or_country, main_config) {
  draws_for_plotting <- combine_draws_to_single_df(post_stratified_draws, main_config) %>%
    filter_plot_by_region_country_and_variant(COUNTRY, VARIANT, region_or_country)

  prevalence_for_plotting <- filter_plot_by_region_country_and_variant(
    prevalence_time_series,
    COUNTRY,
    VARIANT,
    region_or_country
  ) %>%
    dplyr::mutate(time = lubridate::ymd(time))



  end_date <- lubridate::ymd(main_config$run_settings$end_date[[COUNTRY]])


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

  date_axis_breaks <- seq(max(prevalence_for_plotting$time), min(prevalence_for_plotting$time), -7)

  plot <- ggplot2::ggplot(data = prevalence_for_plotting, ) +
    purrr::map2(vline_intercepts, vline_labels, ~ ggplot2::geom_vline(ggplot2::aes(xintercept = as.Date(.x), colour = .y),
      linetype = "longdash",
      linewidth = 0.6
    )) +
    ggplot2::geom_line(
      data = draws_for_plotting,
      mapping = ggplot2::aes(
        x = date,
        y = posterior_probability,
        group = draw
      ),
      linewidth = 0.1,
      alpha = 0.1
    ) +
    ggplot2::geom_line(
      data = prevalence_for_plotting,
      mapping = ggplot2::aes(x = time, y = mean / 100), colour = "red"
    ) +
    ggplot2::geom_ribbon(
      data = prevalence_for_plotting,
      mapping = ggplot2::aes(
        x = time,
        ymin = ll / 100,
        ymax = ul / 100
      ),
      colour = "red", fill = NA
    ) +
    ggplot2::scale_colour_manual(
      name = "",
      guide = "legend",
      values = c(
        "#fc8d62",
        "#8da0cb",
        "#66c2a5"
      ),
      labels = vline_labels
    ) +
    ggplot2::scale_y_continuous(
      expand = c(0, 0),
      position = "left",
      labels = scales::percent_format(accuracy = 0.1)
    ) +
    ggplot2::labs(
      title = paste0("Spaghetti plot of posterior draws in ", COUNTRY),
      x = "Date",
      y = "Prevalence"
    ) +
    ggplot2::scale_x_date(date_labels = "%d\n %b", breaks = date_axis_breaks) +
    theme_CIS()

  add_region_or_country_layer(plot, region_or_country)
}

#' @title Combine Draws to a Single Dataframe
#'
#' @description combines post_stratified_draws from a list of matricies to a single data frame
#'
#' @param post_stratified_draws a list object containing the post stratified draws matricies
#'
#' @param main_config a list object containing the main configuration settings for the system
#
#' @return transformed_draws a dataframe with all of the draws broken down by country, region, variant and date

combine_draws_to_single_df <- function(post_stratified_draws, main_config) {
  region_variant_countries_combos <- create_region_variant_country_combos(main_config)

  transformed_draws <- purrr::pmap(
    .l = list(
      COUNTRY = region_variant_countries_combos$country,
      VARIANT = region_variant_countries_combos$variant,
      REGION = region_variant_countries_combos$region
    ),
    .f = transform_draws_to_df,
    post_stratified_draws,
    main_config
  )

  do.call(rbind, transformed_draws)
}

#' @title Create Region, Variant, and Country Combinations
#'
#' @description create a dataframe with all of the combinations of Region, Variant and Country which exist within the post_stratified_draws matrix
#'
#' @param main_config a list object containing the main configuration settings for the system
#'
#' @return a dataframe with all of the combinations of region, variant and country that occur in the post_stratified_draws

create_region_variant_country_combos <- function(main_config) {
  variants <- c(1, 2, 4, 5)
  countries <- gcptools::uk_countries
  regions <- list(
    "England" = c("All", gcptools::england_regions),
    "Scotland" = "All",
    "Wales" = "All",
    "Northern Ireland" = "All"
  )

  region_col <- c(
    rep(gcptools::england_regions, length(variants)),
    rep("All", length(variants) * length(countries))
  )

  variant_col <- c(
    sort(rep(variants, length(gcptools::england_regions))),
    rep(variants, length(countries))
  )

  country_col <- c(
    rep("England", length(variants) * length(gcptools::england_regions)),
    sort(rep(countries, length(variants)))
  )

  output <- data.frame(
    country = country_col,
    variant = variant_col,
    region = region_col
  ) %>%
    dplyr::filter(country %in% main_config$run_settings$countries)
  return(output)
}

#' @title Transform Draws to a Data Frame
#'
#' @description selects and transforms a post-stratifed draws matrix from the wider list into a dataframe with date, region, country and variant columns
#'
#' @param COUNTRY a string containing the name of the country which the draws relate to
#'
#' @param VARIANT a string containing the name of the variant which the draws relate to
#'
#' @param REGION a string contianing the name of the region which the draws relate to
#'
#' @param post_stratified_draws a list object containing the complete set of post-stratified draws matricies
#'
#' @param main_config a list object containing the main configuration settings for the system
#'
#' @return a dataframe for the specific region, country and variant post-stratified draws

transform_draws_to_df <- function(COUNTRY, VARIANT, REGION, post_stratified_draws, main_config) {
  country_variant <- paste0(COUNTRY, VARIANT)

  end_date <- main_config$run_settings$end_date[[COUNTRY]]

  length_draws <- nrow(t(post_stratified_draws[[country_variant]][[REGION]]))

  start_date <- end_date - (length_draws - 1)

  date_sequence <- seq(start_date, end_date, 1)

  post_stratified_draws[[country_variant]][[REGION]] %>%
    t() %>%
    data.frame() %>%
    dplyr::mutate(
      date = date_sequence,
      country = COUNTRY,
      region = dplyr::case_match(REGION,
        "All" ~ COUNTRY,
        .default = REGION
      ),
      variant = dplyr::case_match(
        VARIANT,
        1 ~ "ctall",
        2 ~ "c4",
        4 ~ "ct7",
        5 ~ "ctnot4not7"
      ),
      .before = X1
    ) %>%
    dplyr::rename_with(.cols = tidyselect::contains("X"), .fn = ~ gsub("X", "draw_", .x)) %>%
    tidyr::pivot_longer(
      cols = tidyselect::starts_with("draw"),
      names_to = "draw",
      values_to = "posterior_probability",
      names_prefix = "draw_"
    )
}
