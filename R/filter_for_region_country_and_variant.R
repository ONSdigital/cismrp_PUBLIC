#' @title filter_for_region_country_and_variant
#'
#' @description function to filter the hard coded structure required to run the probabilities by the region, country and variants specified in the higher level lists.
#'
#' @param regions_filter a vector containing the names of the regions to filter using "All" for country level region id's at this stage
#' @param countries_filter a vector containing the names of the countries to filter
#' @param variants_filter a vector containing the names of the variants to filter
#'
#' @return a dataframe which has been filtered by region, country and variant
#'
#' @export

filter_for_region_country_and_variant <- function(regions_filter, countries_filter, variants_filter) {
  # hard coded because is required in this specific combination to ensure all variants,
  #   regions and countries are combined in the correct way.

  regions <- sort(c(
    rep("All", 16),
    rep(c(
      "North East", "North West",
      "Yorkshire and The Humber", "East Midlands",
      "West Midlands", "East of England",
      "London", "South East", "South West"
    ), 4)
  ))

  variants <- c(rep(c("1", "2", "4", "5"), 13))

  countries <- c(
    rep("England", 4),
    rep("Wales", 4),
    rep("Scotland", 4),
    rep("Northern Ireland", 4),
    rep("England", 36)
  )

  data.frame(
    "region" = regions,
    "country" = countries,
    "variant" = variants
  ) %>%
    dplyr::filter(
      regions %in% regions_filter,
      countries %in% countries_filter,
      variants %in% variants_filter
    ) %>%
    as.list()
}
