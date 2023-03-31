#### CLEAN AGGREGATED ####
#
#  1 clean_aggregated
#
#    1.1 remove_ethnicity
#
#### End of contents ####

#' @title clean aggregated sample
#'
#' @description basic data cleaning
#'
#' @param data aggregated sample dataframe
#'
#' @export

clean_aggregated <- function(data) {
  data %>%
    dplyr::mutate(
      visit_date = as.Date(visit_date, format = "%d%b%Y"),
      data_run_date = as.Date(data_run_date, format = "%d%b%Y"),
      # lab_id =  factor(lab_id, levels = c("GLS", "LML", "BB", "NA")),
      age_group = factor(ageg_7,
        levels = c(
          "2-11",
          "12-16",
          "17-24",
          "25-34",
          "35-49",
          "50-69",
          "70+"
        )
      ),
      sex = factor(sex, levels = c("Male", "Female")),
    ) %>%
    clean_region("gor_name") %>%
    remove_ethnicity() %>%
    create_country_from_region()
}

#' @title remove_ethnicity
#'
#' @description function to aggregate up to remove ethnicity breakdown
#'
#' @param data dataframe containing data to aggregate
#'
#' @return a dataframe with ethnicity removed.

remove_ethnicity <- function(data) {
  data <- data %>%
    dplyr::group_by(
      data_run_date, visit_date, sex,
      age_group, region, lab_id
    ) %>%
    dplyr::summarise(
      dplyr::across(c(
        n_pos, n_neg, n_void, ab_pos, ab_neg, n_ctpattern4,
        n_ctpattern7, n_ctpattern5, n_ctpattern6
      ), sum),
      mean(ct_mean, na.rm = TRUE)
    ) %>%
    dplyr::ungroup()

  return(data)
}

#' @title create_country_from_region
#'
#' @description function to infer country name from region column
#'
#' @param data a dataframe containing a region column
#'
#' @return a dataframe with an additional country column

create_country_from_region <- function(data) {
  data %>%
    dplyr::mutate(
      country = dplyr::case_when(
        region %in% c(
          "Scotland",
          "Wales",
          "Northern Ireland"
        ) ~ as.character(region),
        region %in% c(
          "North East",
          "North West",
          "Yorkshire and The Humber",
          "East Midlands",
          "West Midlands",
          "East of England",
          "London",
          "South East",
          "South West"
        ) ~ "England"
      ), .after = region
    )
}
