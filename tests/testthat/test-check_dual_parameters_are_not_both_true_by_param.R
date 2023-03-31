dummy_config <- list(
  "run_settings" = list(
    "environment" = "GCP",
    "test" = as.logical("F"), # test run with 'full' model settings - set to false as default for production
    "test_configs_short" = as.logical("T"), # test run with 'short' model settings - set to false as default for production
    "rerun" = as.logical("F"), # only set to true if changing end_date for secondary run
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

# Function returns TRUE confirming params are not both set to true
testthat::test_that("Function confirms params are not conflicting", {
  output <- check_dual_parameters_are_not_both_true_by_param("test", "test_configs_short", dummy_config)

  testthat::expect_true(output)
})

testthat::test_that("Function errors when dual params are set to true", {
  dummy_config$run_settings$test <- as.logical("T")

  testthat::expect_error(check_dual_parameters_are_not_both_true_by_param("test", "test_configs_short", dummy_config))
})
