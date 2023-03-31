#' @title Filter Plotting Data by Country and Variant
#'
#' @description filters data to be plotting by country and variant
#'
#' @param data data to be filtered
#'
#' @param COUNTRY a string containing the name of a country you want to filter by
#'
#' @param VARIANT a string containing the name of the variant you want to filter by
#'
#' @param region_or_country a string containing either region or country
#
#' @return filtered data
#' @export

filter_plot_by_region_country_and_variant <- function(data, COUNTRY, VARIANT, region_or_country) {
  filter_stage_1 <- data %>%
    dplyr::filter(
      country == COUNTRY,
      variant == VARIANT
    )

  if (region_or_country == "country") {
    filtered_data_by_region_or_country <- dplyr::filter(filter_stage_1, region == COUNTRY)
  } else {
    filtered_data_by_region_or_country <- dplyr::filter(filter_stage_1, region != COUNTRY)
  }

  return(filtered_data_by_region_or_country)
}
