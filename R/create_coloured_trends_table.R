#' @title Create Coloured Trends Table

#' @description makes sequence of dates from start to end date
#'
#' @param data a dataframe containing the post-stratified probabilities with formatting
#'
#' @param COUNTRY a string containing the name of the region you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @param region_or_country a string containing either region or country
#'
#' @return a kable formatted table for rendering in HTML
#'
#' @export

create_coloured_trends_table <- function(data, COUNTRY, VARIANT, region_or_country) {
  nuts1_england_regions <- gcptools::england_regions

  filtered_data <- data %>%
    dplyr::mutate(country = dplyr::case_match(region,
      nuts1_england_regions ~ "England",
      .default = region
    )) %>%
    dplyr::filter(
      country == COUNTRY,
      variant == VARIANT
    ) %>%
    dplyr::mutate(
      comparison_period = as.character(comparison_period),
      comparison_period = dplyr::case_match(comparison_period, "7" ~ "1 Week Prior", "14" ~ "2 Weeks Prior")
    ) %>%
    dplyr::rename(
      "Region" = region,
      "Compared to" = comparison_period,
      "Latest Trend" = summary_current,
      "Latest Probability" = probability_increase_current,
      "Previous Trend" = summary_previous,
      "Previous Probability" = probability_increase_previous
    )

  if (region_or_country == "region") {
    filtered_by_region_or_country <- filtered_data %>%
      dplyr::filter(Region != country)

    cols_to_select <- c("Region", "Compared to", "Latest Trend", "Latest Probability", "Previous Trend", "Previous Probability")
    colour_cols_current <- c(3, 4)
    colour_cols_previous <- c(5, 6)
  } else {
    filtered_by_region_or_country <- filtered_data %>%
      dplyr::filter(Region == country)

    cols_to_select <- c("Compared to", "Latest Trend", "Latest Probability", "Previous Trend", "Previous Probability")
    colour_cols_current <- c(2, 3)
    colour_cols_previous <- c(4, 5)
  }

  table <- filtered_by_region_or_country %>%
    dplyr::select(cols_to_select) %>%
    kableExtra::kbl(align = "c") %>%
    kableExtra::kable_styling(bootstrap_options = "hover", font_size = 18, position = "left", full_width = TRUE) %>%
    kableExtra::column_spec(column = colour_cols_current, background = filtered_by_region_or_country$formatting_current) %>%
    kableExtra::column_spec(column = colour_cols_previous, background = filtered_by_region_or_country$formatting_previous)


  if (region_or_country == "region") {
    table %>%
      kableExtra::column_spec(column = 1, bold = TRUE) %>%
      kableExtra::collapse_rows(columns = 1, valign = "middle") %>%
      kableExtra::scroll_box(width = "100%", height = "470px")
  } else {
    table
  }
}
