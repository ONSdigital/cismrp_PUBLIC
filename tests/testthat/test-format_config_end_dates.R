dummy_config <- list(
  "run_settings" = list(
    "environment" = "GCP",
    "test" = "false", # test run with 'full' model settings - set to false as default for production
    "test_configs_short" = "true", # test run with 'short' model settings - set to false as default for production
    "rerun" = "false", # only set to true if changing end_date for secondary run
    "data_run" = "20221205", # enter this weeks data_run date "yyyymmdd"
    "end_date" = list(
      "England" = "20221126",
      "Northern Ireland" = "20221123",
      "Scotland" = "20221124",
      "Wales" = "20221124"
    ), # enter this weeks end_date date "yyyymmdd"
    "prev_data_run" = "20221128", # enter desired previous data run date for overlay plots and tables "yyyymmdd"
    "prev_end_date" = list(
      "England" = "20221121",
      "Northern Ireland" = "20221121",
      "Scotland" = "20221121",
      "Wales" = "20221121"
    ), # enter desired previous end date for overlay plots and tables "yyyymmdd"
    "analyst" = "Christina", # enter your "name"
    "qa_report_filename_suffix" = NULL, # change this to a string if you want to change the end of your qa_report filename
    "days_to_check" = 60
  ),
  "paths" = list(
    "population_totals" = "poststrat_updated_pop_totals_7agegroups_202010", # please ensure this is poststrat_updated_pop_totals_7agegroups_202010 until census data received
    "sample_aggregates" = "_main_aggregates",
    "household_checks" = "_hh_checks_aggregates"
  ),
  "GCP" = list(
    "wip_bucket" = "polestar-prod-process-wip", # this is where you can save work in progress datasets
    "data_bucket" = "polestar-prod-cis-data", # this is where the ingest data will be located
    "review_bucket" = "polestar-prod-review" # this is where you can save data ready for review and export
  )
)


output <- format_config_end_dates(dummy_config)

# Output has end_date and prev_end_date formatted as dates for each country

test_dates_by_country <- function(date, country, output) {
  message <- paste0("Output ", date, " is in date format")

  testthat::test_that(message, {
    testthat::expect_type(output$run_settings[[date]][[country]], "double")
  })
}

dates <- rep(c("end_date", "prev_end_date"), 4)
countries <- sort(rep(c("England", "Northern Ireland", "Scotland", "Wales"), 2))

purrr::map2(.x = dates, .y = countries, .f = test_dates_by_country, output)
