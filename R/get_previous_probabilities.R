#' @title get_previous_probabilities
#'
#' @description function to fetch previous probabilities from the review bucket
#'
#' @param main_config a list object containing the main configuration settings
#'
#' @return a dataframe with the previous weeks probablities
#'
#' @export

get_previous_probabilities <- function(main_config) {
  settings <- main_config$run_settings

  previous_data_run_date <- settings$prev_data_run

  latest_previous_end_date <- purrr::map(settings$prev_end_date, format, "%Y%m%d") %>%
    unlist() %>%
    max()


  pattern <- paste0(
    previous_data_run_date,
    "_mrp/probs_over_time_mrp_",
    latest_previous_end_date
  )

  filepath <- grep(
    x = googleCloudStorageR::gcs_list_objects(gcptools::gcp_paths$review_bucket)$name,
    pattern = pattern,
    value = TRUE
  )

  data <- suppressMessages(gcptools::gcp_read_csv(filepath,
    col_types = list("c", "c", "c", "n", "n", "n", "c", "c", "c", "n", "n")
  )) %>%
    dplyr::select(comparison_period:variant)

  return(data)
}
