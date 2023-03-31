# 1 save_all_outputs
#   1.1 save_output
#     1.1.1 get_bucket_list
#     1.1.2 get_max_date
#     1.1.3 create_filepath
#        1.1.1.1 create_file_name
#        1.1.1.2 create_folder_name
#          1.1.1.2.1 create_folder_name_prefix

#' @title save_all_outputs
#' @description function to save a set of outputs to the gcp buckets
#'
#' @param objects a list object containing the objects you want to save
#' @param file_ids a list object containing the identifying name components to fit within the naming pattern
#' @param file_types a list containing strings the file extension without the '.' e.g. 'rdata' or 'csv'
#' @param config a list object containing the configurations settings
#'
#' @return nothing
#'
#' @export

save_all_outputs <- function(objects,
                             file_ids,
                             file_types,
                             config) {
  argument_list <- list(
    "object" = objects,
    "file_id" = file_ids,
    "file_type" = file_types
  )

  purrr::pmap(
    .l = argument_list,
    .f = save_output,
    config
  )
}

#' @title save_output
#' @description function to save outputs to a given bucket
#'
#' @param object a data object containing the thing you want to save
#' @param file_id a string containing the identifying characteristics of the object
#' @param file_type a list containing strings the file extension without the '.' e.g. 'rdata' or 'csv'
#' @param config a list object containing the configurations settings
#'
#' @return nothing

save_output <- function(object, file_id, file_type, config) {
  bucket_list <- get_bucket_list(config)

  max_end_date <- get_max_date(config, "end_date")

  filepath <- create_filepath(
    file_id, max_end_date,
    file_type, config
  )

  purrr::map(
    .x = bucket_list,
    .f = gcptools::gcp_upload_object,
    object = object,
    filepath = filepath,
    file_type = file_type
  )
}

#' @title get_bucket_list
#'
#' @description function to retrieve the bucket list from the config
#'
#' @param config a list object containing the configurations settings
#'
#' @return a list object containing the gcp bucket references for saving outputs

get_bucket_list <- function(config) {
  settings <- config$run_settings

  if (settings$test == TRUE | settings$test_configs_short == TRUE) {
    bucket_list <- list(gcptools::gcp_paths$wip_bucket)
  } else {
    bucket_list <- list(
      gcptools::gcp_paths$wip_bucket,
      gcptools::gcp_paths$review_bucket
    )
  }
  return(bucket_list)
}

#' @title get_max_date
#'
#' @description function to retrieve the latest date from a list of dates
#'
#' @param config a list object containing the configurations settings
#' @param end_date a string containing the name of a specfic date reference in the config
#'
#' @return a string containing the maximum date from a list in character form

get_max_date <- function(config, end_date) {
  end_dates <- config$run_settings[[end_date]]

  clean_end_dates <- purrr::map(
    .x = end_dates,
    .f = date_to_clean_string
  )

  max_end_date <- max(unlist(clean_end_dates))

  return(max_end_date)
}

#' @title create_filepath
#' @description function to create a filepath for saving outputs
#'
#' @param file_id a string containing the identifying characteristics of the object
#' @param end_date a cleaned string containing the date in the following format yyyymmdd
#' @param file_type a list containing strings the file extension without the '.' e.g. 'rdata' or 'csv'
#' @param config a list object containing the configurations settings
#'
#' @return a string containing the filepath

create_filepath <- function(file_id,
                            end_date,
                            file_type = c(
                              "rdata",
                              "yaml",
                              "jpeg",
                              "html",
                              "csv",
                              "xlsx",
                              "rds"
                            ),
                            config) {
  file_type <- match.arg(file_type)

  file_name <- create_file_name(file_id, end_date, file_type)

  folder_name <- create_folder_name(config)

  filepath <- paste0(folder_name, file_name)

  return(filepath)
}

#' @title create_file_name
#'
#' @description function to create a file_name for saving outputs
#'
#' @param file_id a string containing the identifying characteristics of the object
#' @param end_date a cleaned string containing the date in the following format yyyymmdd
#' @param file_type a list containing strings the file extension without the '.' e.g. 'rdata' or 'csv'
#'
#' @return a string containing the file_name

create_file_name <- function(file_id,
                             end_date,
                             file_type = c(
                               "rdata",
                               "yaml",
                               "jpeg",
                               "html",
                               "csv",
                               "xlsx",
                               "rds"
                             )) {
  time_stamp <- format(Sys.time(), "DTS%y%m%d_%H%M%Z")

  suffix <- paste0("_mrp_", end_date, "_", time_stamp, ".", file_type)

  filename <- paste0(file_id, suffix)

  return(filename)
}

#' @title create_folder_name
#'
#' @description function to create folder name from config settings
#'
#' @param config a list object containing the main configuration settings for the system
#'
#' @return a string containing the folder name
#'
#' @export

create_folder_name <- function(config) {
  run_settings <- config$run_settings

  data_run <- date_to_clean_string(run_settings$data_run)

  prefix_conditions <- c(
    run_settings$test,
    run_settings$test_configs_short
  )

  suffix_condition <- run_settings$rerun


  if (any(prefix_conditions == TRUE)) {
    prefix <- get_folder_name_prefix(config)
  } else {
    prefix <- ""
  }


  if (suffix_condition == TRUE) {
    suffix <- "_mrp_rerun/"
  } else {
    suffix <- "_mrp/"
  }


  folder_name <- paste0(prefix, data_run, suffix)

  return(folder_name)
}

#' @title create_folder_name_prefix
#'
#' @description function to create prefix for folder_name from configuration file
#'
#' @param config a list object containing the main configuration settings for the system
#'
#' @return a string containing prefix for the folder_name
#'
#' @export

get_folder_name_prefix <- function(config) {
  options <- list(
    test = config$run_settings$test,
    test_configs_short = config$run_settings$test_configs_short
  )

  prefix <- names(options[which(options == TRUE)])

  final_prefix <- paste0(prefix, "_", config$run_settings_analyst)

  return(final_prefix)
}
