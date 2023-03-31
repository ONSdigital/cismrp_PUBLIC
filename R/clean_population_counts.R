#### CLEAN POPULATION COUNTS ####
#
#  1 clean_population_counts
#
#    1.1 recode_pop_region_codes
#
#    1.2 recode_age_groups
#
#    1.3 set_pop_table_factors
#
#### End of contents ####

#' @title clean_population_counts
#'
#' @description function to reformat the population counts
#'
#' @param population_counts a dataframe with the aggregated population counts by demographic
#'
#' @returns dataframe
#'
#' @export

clean_population_counts <- function(population_counts) {
  population_counts %>%
    recode_pop_region_codes() %>%
    recode_age_groups() %>%
    set_pop_table_factors() %>%
    dplyr::mutate(
      N = as.numeric(as.character(N)),
      lab_id = "GLS"
    ) # %>%
  # dplyr::select(gor_code, sex, age_group, region, lab_id, N)
}

#' @title recode_pop_region_codes
#'
#' @description function to derive the readable region names from the gor_code column
#'
#' @param data a dataframe containing a gor9d column
#'
#' @return a dataframe containing readable region names, and the gor9d column

recode_pop_region_codes <- function(data) {
  data %>%
    dplyr::mutate(
      region = dplyr::case_when(
        gor_code == "E12000001" ~ "North East",
        gor_code == "E12000002" ~ "North West",
        gor_code == "E12000003" ~ "Yorkshire and The Humber",
        gor_code == "E12000004" ~ "East Midlands",
        gor_code == "E12000005" ~ "West Midlands",
        gor_code == "E12000006" ~ "East of England",
        gor_code == "E12000007" ~ "London",
        gor_code == "E12000008" ~ "South East",
        gor_code == "E12000009" ~ "South West",
        gor_code == "N99999999" ~ "Northern Ireland",
        gor_code == "S99999999" ~ "Scotland",
        gor_code == "W99999999" ~ "Wales"
      )
    )
}

#' @title recode age groups
#'
#' @description recode age groups ("_" to "-") and rename column
#'
#' @param data data frame
#'
#' @returns data frame

recode_age_groups <- function(data) {
  data$age_group <- gsub("_", "-", data$age_group)

  # data$age_group <- gsub("_", "-", data$ageg_7_categories)

  # data$ageg_7_categories <- NULL

  return(data)
}

#' @title set_pop_table_factors
#'
#' @description function to set the factor levels for region and age groups
#'
#' @param data a dataframe containing region and age_group columns
#'
#' @returns data frame with factor levels set

set_pop_table_factors <- function(data) {
  region_code_names <- list(
    "E12000001", # NE
    "E12000002", # NW
    "E12000003", # YH
    "E12000004", # EM
    "E12000005", # WM
    "E12000006", # EE
    "E12000007", # LD
    "E12000008", # SE
    "E12000009", # SW
    "N99999999", # NI
    "S99999999", # SC
    "W99999999"
  ) # WA

  region_names <- list(
    "East of England",
    "East Midlands",
    "London",
    "North East",
    "North West",
    "Northern Ireland",
    "Scotland",
    "South East",
    "South West",
    "Wales",
    "West Midlands",
    "Yorkshire and The Humber"
  )

  age_group_names <- list(
    "2-11",
    "12-16",
    "17-24",
    "25-34",
    "35-49",
    "50-69",
    "70+"
  )

  data <- data %>%
    dplyr::mutate(
      region = factor(region, levels = region_names),
      age_group = factor(age_group, levels = age_group_names)
    )

  return(data)
}
