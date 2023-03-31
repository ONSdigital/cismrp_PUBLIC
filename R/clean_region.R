#### CLEAN AGGREGATED ####
#
#  1 clean_region
#
#    1.1 recode_region_names
#
#    1.2 region_to_factor
#
#### End of contents ####

#' @title clean_region
#'
#' @description function recode and reformat the region identifier column to readable names within a factor type
#'
#' @param data a dataframe containing the region codes for renaming
#' @param column a column name which contains the region codes for renaming
#'
#' @return a dataframe with a readable region column which is of the 'factor' type
#'
#' @export

clean_region <- function(data, column) {
  data %>%
    recode_region_names(column) %>%
    region_to_factor()
}

#' @title recode_region_names
#'
#' @description function to recode the region names from alpha-numeric code to readable region names
#'
#' @param data a dataframe containing the region codes for renaming
#' @param column a column name which contains the region codes for renaming
#'
#' @return a vector with the recoded names in a new column called 'region'

recode_region_names <- function(data, column) {
  region_names <- list(
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

  data[["region"]] <- dplyr::recode(data[[column]], !!!region_names)

  return(data)
}


#' @title region_to_factor
#'
#' @description function to convert a region column into an ordered factor
#'
#' @param data a dataframe containing the region codes for renaming
#'
#' @return a vector with the recoded names

region_to_factor <- function(data) {
  region_names <- list(
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

  data$region <- factor(data$region, levels = region_names)

  return(data)
}
