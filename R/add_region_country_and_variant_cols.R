#' @title add_country_and_variant_cols
#'
#' @description function to add function and variant columns
#'
#' @param data a dataframe containing the data you want to add columns to
#' @param region a string contiaining the name of a region you want to set the region column to
#' @param country a string contiaining the name of a country you want to set the country column to
#' @param variant a string contiaining the name of a variant you want to set the variant column to
#'
#' @return a dataframe with the region, variant and country columns appended
#'
#' @export

add_region_country_and_variant_cols <- function(data, region, country, variant) {
  interim_data <- data %>%
    dplyr::mutate(
      region = region,
      country = country,
      variant = variant
    )
  if (region == "All") {
    output_data <- interim_data %>%
      dplyr::mutate(region = country)
  } else {
    output_data <- interim_data
  }

  return(output_data)
}
