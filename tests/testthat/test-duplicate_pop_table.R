dummy_data <- structure(
  list(
    gor_code = c("E12000001", "E12000002", "E12000003", "E12000004", "E12000005", "E12000006", "E12000007", "E12000008", "E12000009", "N99999999", "S99999999", "W99999999"),
    sex = c("Male", "Female", "Male", "Female", "Male", "Female", "Male", "Female", "Male", "Female", "Male", "Female"),
    age_group = c("2_11", "12_16", "17_24", "25_34", "35_49", "50_69", "70+", "2_11", "17_24", "25_34", "35_49", "50_69"),
    region = c("North_East_England", "North_West_England", "Yorkshire", "East_Midlands", "West_Midlands", "East_England", "London", "South_East_England", "South_West_England", "Northern_Ireland", "Scotland", "Wales"),
    lab_id = rep(c("GLS"), 12),
    N = c(
      156095,
      76293, 127286, 171797, 226730, 336546, 147522, 72755, 119118, 127286, 226730, 127286
    )
  ),
  row.names = c(NA, -12L), class = "data.frame"
)

cleaned_dummy_data <- clean_population_counts(dummy_data)

dummy_config <- list(
  "run_settings" = list(
    "environment" = "GCP",
    "test" = as.logical("F"), # test run with 'full' model settings - set to false as default for production
    "test_configs_short" = as.logical("T"), # test run with 'short' model settings - set to false as default for production
    "rerun" = as.logical("F"), # only set to true if changing end_date for secondary run
    "data_run" = "20221205", # enter this weeks data_run date "yyyymmdd"
    "end_date" = list(
      "England" = as.Date("20200507", format = "%Y%m%d"),
      "Northern Ireland" = as.Date("20200507", format = "%Y%m%d"),
      "Scotland" = as.Date("20200507", format = "%Y%m%d"),
      "Wales" = as.Date("20200507", format = "%Y%m%d")
    ), # enter this weeks end_date date "yyyymmdd"
    "prev_data_run" = "20221128", # enter desired previous data run date for overlay plots and tables "yyyymmdd"
    "prev_end_date" = list(
      "England" = as.Date("20200507", format = "%Y%m%d"),
      "Northern Ireland" = as.Date("20200507", format = "%Y%m%d"),
      "Scotland" = as.Date("20200507", format = "%Y%m%d"),
      "Wales" = as.Date("20200507", format = "%Y%m%d")
    ), # enter desired previous end date for overlay plots and tables "yyyymmdd"
    "analyst" = "Christina", # enter your "name"
    "qa_report_filename_suffix" = NULL, # change this to a string if you want to change the end of your qa_report filename
    "days_to_check" = 11
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

countries <- list("Northern Ireland", "Wales", "Scotland", "England")

country_dummy_configs <- list(
  "Northern Ireland" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  ),
  "Wales" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  ),
  "Scotland" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  ),
  "England" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  )
)

config <- country_dummy_configs[["Scotland"]]

config$run_settings$end_date <- dummy_config$run_settings$end_date[["Scotland"]]

output <- duplicate_pop_table(cleaned_dummy_data, config)

# Test function returns data frame
testthat::test_that("function returns a dataframe", {
  expect_true(is.data.frame(output))
})


# Test that number of columns in output dataframe is 7
testthat::test_that("Function creates output with 7 columns, as adds study day as added column", {
  testthat::expect_length(output, 7)
})

# Test column names created
expected_col_names <- c("gor_code", "sex", "age_group", "region", "lab_id", "N", "study_day")

testthat::test_that("columns have right names", {
  expect_named(output, expected_col_names)
})

# Test Function duplicates data according to config data so returns more rows

testthat::test_that("Function creates output with 672 rows by duplicating data 56 times according to this being days to model", {
  testthat::expect_vector(output, ptype = NULL, size = 672)
})
