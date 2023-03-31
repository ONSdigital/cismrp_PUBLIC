#' @title Ingest Data Frame
#'
#' @description load csv dataset as dataframe
#'
#' @param file_reference the partial name of the file you want to read in
#' @param data_run a string containing the data run date
#'
#' @return data frame
#'
#' @export

ingest_data <- function(file_reference, data_run) {
  run_date <- gsub("-", "", as.character(data_run))
  filename <- paste0(run_date, file_reference)

  exact_file <- googleCloudStorageR::gcs_list_objects(
    bucket = gcptools::gcp_paths$data_bucket,
    prefix = filename
  ) %>%
    dplyr::pull("name")
  data <- suppressMessages(gcptools::gcp_read_csv(exact_file,
    bucket = "data_bucket"
  ))
}
