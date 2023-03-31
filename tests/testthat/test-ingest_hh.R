# dummy_config <- list(
#   "run_settings" = list(
#     "environment" = "GCP",
#     "test" = as.logical("F"), # test run with 'full' model settings - set to false as default for production
#     "test_configs_short" = as.logical("T"), # test run with 'short' model settings - set to false as default for production
#     "rerun" = as.logical("F"), # only set to true if changing end_date for secondary run
#     "data_run" = "20221205", # enter this weeks data_run date "yyyymmdd"
#     "end_date" = list(
#       "England" = "20221126",
#       "Northern Ireland" = "20221123",
#       "Scotland" = "20221124",
#       "Wales" = "20221124"
#     ), # enter this weeks end_date date "yyyymmdd"
#     "prev_data_run" = "20221128", # enter desired previous data run date for overlay plots and tables "yyyymmdd"
#     "prev_end_date" = list(
#       "England" = "20221121",
#       "Northern Ireland" = "20221121",
#       "Scotland" = "20221121",
#       "Wales" = "20221121"
#     ), # enter desired previous end date for overlay plots and tables "yyyymmdd"
#     "analyst" = "Christina", # enter your "name"
#     "qa_report_filename_suffix" = NULL, # change this to a string if you want to change the end of your qa_report filename
#     "days_to_check" = 60
#   ),
#   "paths" = list(
#     "population_totals" = "poststrat_updated_pop_totals_7agegroups_202010", # please ensure this is poststrat_updated_pop_totals_7agegroups_202010 until census data received
#     "sample_aggregates" = "_main_aggregates",
#     "household_checks" = "_hh_checks_aggregates"
#   ),
#   "GCP" = list(
#     "wip_bucket" = "ons-psplus-analysis-prod-cis-wip", # this is where you can save work in progress datasets
#     "data_bucket" = "ons-psplus-data-prod-psplus-cis-data", # this is where the ingest data will be located
#     "review_bucket" = "ons-psplus-analysis-prod-cis-review" # this is where you can save data ready for review and export
#   )
# )

# # Test function returns data frame
# testthat::test_that("function returns a dataframe", {
#   testthat::skip_on_ci()

#   dummy_config <- format_config_end_dates(dummy_config)
#   output <- ingest_hh(dummy_config)

#   expect_true(is.data.frame(ingest_hh(dummy_config)))
# })


# # test col names are expected
# col_names <- c(
#   "visit_date", "gor_name", "lab_id",
#   "data_run_date", "n_hh_for_ab_pos",
#   "n_hh_for_pos", "n_hh_ever_ab",
#   "n_hh_ever_ab_pos", "n_hh_with_first_hh_pos",
#   "n_hh_with_pos", "max_pos_hh"
# )

# testthat::test_that("columns have right names", {
#   testthat::skip_on_ci()

#   dummy_config <- format_config_end_dates(dummy_config)
#   output <- ingest_hh(dummy_config)

#   expect_named(output, col_names)
# })
