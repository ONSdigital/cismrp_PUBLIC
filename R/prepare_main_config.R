#### PREPARE MAIN CONFIG ####
#
#  1 prepare_main_config
#
#    1.1 format_config_end_dates
#
#    1.2 run_config_checks
#
#      1.2.3 check_data_run_vs_previous
#
#      1.2.4 check_end_date_occurs_after_prev_end_date
#
#        1.2.4.1 check_end_date_occurs_after_prev_end_date_by_vars
#
#      1.2.5 check_end_date_occurs_after_data_run
#
#      1.2.5.1 check_end_date_occurs_after_data_run_by_vars
#
#      1.2.6 check_dual_parameters_are_not_both_true
#
#        1.2.6.1 check_dual_parameters_are_not_both_true_by_param
#
#### End of contents ####

#' @title prepare_main_config
#'
#' @description formats the end_date and prev_end_date to date format
#'
#' @param config_filename a string containing the filename of the main config
#'
#' @return a formatted config which has been checked for user errors
#'
#' @export

prepare_main_config <- function(config_filename) {
  config <- yaml::read_yaml(config_filename) %>%
    format_config_end_dates()

  run_config_checks(config)

  return(config)
}

#' @title format_config_end_dates
#'
#' @description formats the end_date and prev_end_date to date format
#'
#' @param config a list object containing the config
#'
#' @return a list object containing reformatted config with end_date and prev_end_date formatted as date type.

format_config_end_dates <- function(config) {
  countries <- sort(rep(c("England", "Wales", "Scotland", "Northern Ireland"), 2))

  version <- rep(c("end_date", "prev_end_date"), 4)

  for (country in countries) {
    for (version_date in version) {
      formatted <- as.Date(config$run_settings[[version_date]][[country]], format = "%Y%m%d")
      config$run_settings[[version_date]][[country]] <- formatted
    }
  }
  return(config)
}

#' @title run_config_checks
#'
#' @description checking config is compatible with model
#'
#' @param config - a list object containing the configurations for the system
#'
#' @return warning messages or errors if configuration is set incorrectly

run_config_checks <- function(config) {
  check_data_run_vs_previous(config)
  check_end_date_occurs_after_prev_end_date(config)
  check_end_date_occurs_after_data_run(config)
  check_dual_parameters_are_not_both_true(config)
  return(invisible())
}

#' @title check_data_run_vs_previous
#'
#' @description checking data run occurs after the previous data run
#'
#' @param config - a list object containing the configurations for the system
#'
#' @return error if datarun does not occur after the previous data run

check_data_run_vs_previous <- function(config) {
  data_run <- config$run_settings$data_run

  prev_data_run <- config$run_settings$prev_data_run

  assertthat::assert_that(data_run > prev_data_run,
    msg = paste0(
      "data_run(",
      data_run,
      ") must occur after the prev_data_run(",
      prev_data_run,
      ")"
    )
  )
}

#' @title check_end_date_occurs_after_prev_end_date
#'
#' @description checking end date occurs after the previous end date across all countries
#'
#' @param config - a list object containing the configurations for the system
#'
#' @return errors if any country end date occurs before the previous end date

check_end_date_occurs_after_prev_end_date <- function(config) {
  countries <- c("England", "Wales", "Scotland", "Northern Ireland")

  purrr::map(
    .x = countries,
    .f = check_end_date_occurs_after_prev_end_date_by_vars,
    config
  )
}

#' @title check_end_date_occurs_after_prev_end_date_by_vars
#'
#' @description checking end date occurs after the previous end date by country
#'
#' @param country - a string containing the name of a country in the dataset,
#' @param config - a list object containing the configurations for the system
#'
#' @return error if the country end date occurs before the previous end date

check_end_date_occurs_after_prev_end_date_by_vars <- function(country, config) {
  prev_end_date <- as.Date(config$run_settings$prev_end_date[[country]],
    format = "%Y%m%d"
  )

  end_date <- as.Date(config$run_settings$end_date[[country]],
    format = "%Y%m%d"
  )

  assertthat::assert_that(
    end_date > prev_end_date,
    msg = paste0(
      country,
      " end_date(",
      end_date,
      ") must occur after the prev_end_date(",
      prev_end_date
    )
  )
}

#' @title check_end_date_occurs_after_data_run
#'
#' @description checking end dates occurs after the data runs
#'
#' @param config - a list object containing the configurations for the system
#'
#' @return error if any of the countries end dates occur after the data runs

check_end_date_occurs_after_data_run <- function(config) {
  countries <- sort(rep(c("England", "Wales", "Scotland", "Northern Ireland"), 2))

  data_runs <- rep(c("data_run", "prev_data_run"), 4)

  end_dates <- rep(c("end_date", "prev_end_date"), 4)

  purrr::pmap(
    .l = list(countries, data_runs, end_dates),
    .f = check_end_date_occurs_after_data_run_by_vars,
    config
  )
}

#' @title check_end_date_occurs_after_data_run_by_vars
#'
#' @description checking end dates occurs before the data runs by country
#'
#' @param country - a string containing the name of a country in the dataset
#' @param data_run - a string containing the reference to a data run variable in the config
#' @param end_date - a string containing the reference to an end date variable in the config
#' @param config - a list object containing the configurations for the system
#'
#' @return error if the country end dates occur after the data runs

check_end_date_occurs_after_data_run_by_vars <- function(country,
                                                         data_run,
                                                         end_date,
                                                         config) {
  data_run_value <- as.Date(config$run_settings[[data_run]], format = "%Y%m%d")

  end_date_value <- as.Date(config$run_settings[[end_date]][[country]], format = "%Y%m%d")

  assertthat::assert_that(
    data_run_value > end_date_value,
    msg = paste0(
      country, " ",
      end_date, "(",
      end_date_value, ") ",
      "must occur before the ",
      data_run, " ",
      data_run_value
    )
  )
}

#' @title check_dual_parameters_are_not_both_true
#'
#' @description checking test and rerun are not set to true while test config short is set to true in the config
#'
#' @param config a list object containing the configurations settings
#'
#' @return error if the test and rerun are set to true while test config short is set to true in the config

check_dual_parameters_are_not_both_true <- function(config) {
  param_1 <- c("test", "rerun")
  param_2 <- rep("test_configs_short", 2)

  purrr::map2(
    .x = param_1,
    .y = param_2,
    .f = check_dual_parameters_are_not_both_true_by_param,
    config
  )
}

#' @title check_dual_parameters_are_not_both_true_by_param
#'
#' @description checking test and rerun are not set to true while test config short is set to true in the config
#'
#' @param param_1 - a string containing the first reference to test and rerun in the config
#' @param param_2 - a string containing the second reference to test_configs_short
#' @param config - a string containing the reference to test with short configs in the config
#' @param config - a list object containing the configurations for the system
#'
#' @return error if the test and rerun are set to true while test config short is set to true in the config

check_dual_parameters_are_not_both_true_by_param <- function(param_1, param_2, config) {
  param_1_value <- config$run_settings[[param_1]]

  param_2_value <- config$run_settings[[param_2]]

  assertthat::assert_that(
    !all(c(param_1_value, param_2_value) == TRUE),
    msg = paste0(
      "config parameters '",
      param_1,
      "' and '",
      param_2,
      "' cannot both be set to TRUE"
    )
  )
}
