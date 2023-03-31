#### CHECK MISSING DATES ####
#
#  1 check_missing_dates
#
#    1.1 check_missing_dates_by_country
#
#      1.1.1 check_missing_date
#
#      1.1.2 check_missing_dates_between
#
#### End of contents ####

#' @title check missing dates in the aggregated data
#'
#' @description check all dates needed for the analysis are present in the sample for all countries.
#'
#' @param data the aggregated sample data
#' @param config the main config list
#'
#' @export

check_missing_dates <- function(data, config) {
  countries <- c("England", "Wales", "Scotland", "Northern Ireland")

  invisible(purrr::map(
    .x = countries,
    .f = check_missing_dates_by_country,
    data = data,
    config = config
  ))
}

#' @title check missing dates in the aggregated data by country
#'
#' @description check all dates needed for the analysis are present in the sample by country. Stops the script if the last day in the series is missing, as this will break the model later on.
#'
#' @param country_select the geography to check
#' @param data the aggregated sample data
#' @param config the main config list

check_missing_dates_by_country <- function(country_select,
                                           data,
                                           config) {
  data <- filter_by_country(data, country_select)

  end_date <- as.Date(
    config$run_settings$end_date[[country_select]],
    format = "%Y%m%d"
  )

  check_missing_date(
    data,
    country_select,
    end_date,
    "end_date"
  )

  start_date <- as.Date(
    end_date - config$run_settings$days_to_check
  )

  check_missing_date(
    data,
    country_select,
    start_date,
    "start_date"
  )

  check_missing_dates_between(
    data,
    country_select,
    start_date,
    end_date
  )
}

#' @title check_missing_date
#'
#' @description return an error if a specific date is missing
#'
#' @param data a dataframe which you want to check the data (must have visit_date column)
#' @param country a string of the name of the country on which you want to run this on
#' @param check_date a date value for the check
#' @param date_name a string containing the name of the data (e.g. 'start_date')

check_missing_date <- function(data,
                               country,
                               check_date,
                               date_name) {
  check_date <- as.Date(check_date, format = "%Y%m%d")

  assertthat::assert_that(
    check_date %in% unique(data$visit_date),
    msg = paste0(
      "The ",
      date_name,
      " for ",
      country,
      " does not exist within the aggregated sample, the model cannot proceed without an ",
      date_name,
      " that exists within the data"
    )
  )
}

#' @title check_missing_dates_between
#'
#' @description return a warning if there are any missing visit_dates between start_date and end_date
#'
#' @param data a dataframe which you want to check the data (must have visit_date column)
#' @param country a string of the name of the country on which you want to run this on
#' @param start_date the start date for the check
#' @param end_date the end date for the check

check_missing_dates_between <- function(data,
                                        country,
                                        start_date,
                                        end_date) {
  start_date <- as.Date(start_date, format = "%Y%m%d")

  end_date <- as.Date(end_date, format = "%Y%m%d")

  expected_dates <- seq(start_date, end_date, by = "day")

  unique_dates <- unique(data$visit_date)

  # if not all of the expected dates are in the unique dates
  if (!all(expected_dates %in% unique_dates)) {
    message <- paste0(
      "The following dates are missing from the ",
      country,
      " aggregated sample: ",
      paste0(expected_dates[!expected_dates %in% unique_dates], collapse = ", "),
      ". If these are expected, ignore this warning."
    )

    warning(message)
  } else {
    pass_message <- paste0(
      "Check passed for ",
      country,
      ". No missing dates"
    )
    message(pass_message)
  }
}
