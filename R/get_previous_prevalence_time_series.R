#### GET PREVIOUS PREVALENCE TIME SERIES ####
#
#  1. get_previous_prevalence_time_series
#
#    1.1 find_previous_time_series_path
#
#### End of module ####

#' @title Get Previous Prevalence Time Series
#'
#' @description retrieve the previous prevalence time series
#'
#' @param main_config a list object containing the configuration settings for the system
#'
#' @return a dataframe containing the previous prevalence time series
#'
#' @export

get_previous_prevalence_time_series <- function(main_config) {
  previous_prevalence_time_series_path <- find_previous_time_series_path(main_config)

  data <- gcptools::gcp_read_csv(
    file_paths = previous_prevalence_time_series_path,
    bucket = "review_bucket",
    col_types = list("c", "c", "c", "d", "d", "d", "c", "c")
  )
  return(data)
}

#' @title Find Previous Time Series Path
#'
#' @description function to find the previous time series file path using the system configuration settings
#'
#' @param main_config a list object containing the configuration settings for the system
#'
#' @return a string containing the previous prevelance series filepath
#'
#' @export

find_previous_time_series_path <- function(main_config) {
  review_bucket <- gcptools::gcp_paths$review_bucket

  settings <- main_config$run_settings

  gcptools::authenticate_gcp()

  all_folders <- googleCloudStorageR::gcs_list_objects(bucket = review_bucket)
  prev_data_run <- date_to_clean_string(settings$prev_data_run)

  search_pattern <- paste0(
    "^", prev_data_run,
    "_mrp/prev_time_series_mrp_", "|",
    "^", prev_data_run,
    "_mrp_rerun/prev_time_series_mrp_"
  )

  possible_filepaths <- grep(
    x = all_folders$name,
    pattern = search_pattern,
    value = TRUE
  )

  most_recent_filepath <- utils::tail(possible_filepaths, 1)

  return(most_recent_filepath)
}
