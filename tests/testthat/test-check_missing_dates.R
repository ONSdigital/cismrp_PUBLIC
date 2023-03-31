dummy_data <- structure(
  list(
    data_run_date = rep(c(as.Date("05dec2022", format = "%d%b%Y")), 48),
    visit_date = rep(
      c(seq(as.Date("26apr2020", format = "%d%b%Y"),
        as.Date("07may2020", format = "%d%b%Y"),
        by = "day"
      )),
      4
    ),
    sex = factor(rep(c("Male", "Female"), 24), levels = c("Male", "Female")),
    age_group = factor(
      rep(c(
        "2-11", "12-16", "17-24", "25-34",
        "35-49", "50-69", "70+", "2-11",
        "17-24", "25-34", "35-49", "50-69"
      ), 4),
      levels = c(
        "2-11", "12-16",
        "17-24", "25-34",
        "35-49", "50-69", "70+"
      )
    ),
    region = factor(
      c(
        "England", "England", "England", "England",
        "England", "England", "England", "England",
        "England", "England", "England", "England",
        "Wales", "Wales", "Wales", "Wales",
        "Wales", "Wales", "Wales", "Wales",
        "Wales", "Wales", "Wales", "Wales",
        "Scotland", "Scotland", "Scotland", "Scotland",
        "Scotland", "Scotland", "Scotland", "Scotland",
        "Scotland", "Scotland", "Scotland", "Scotland",
        "Northern Ireland", "Northern Ireland",
        "Northern Ireland", "Northern Ireland",
        "Northern Ireland", "Northern Ireland",
        "Northern Ireland", "Northern Ireland",
        "Northern Ireland", "Northern Ireland",
        "Northern Ireland", "Northern Ireland"
      ),
      levels = c(
        "England", "Wales",
        "Scotland", "Northern Ireland"
      )
    ),
    lab_id = factor(rep(c("NA", "GLS", "LML", "BB"), 12),
      levels = c("GLS", "LML", "BB", "NA")
    ),
    n_pos = rep(c(0, 1, 2, 3), 12),
    n_neg = rep(c(0, 1, 2, 3), 12),
    n_void = rep(c(0, 1, 2, 3), 12),
    ab_pos = rep(c(0, 1, 2, 3), 12),
    ab_neg = rep(c(0, 1, 2, 3), 12),
    n_ctpattern4 = rep(c(0, 1, 2, 3), 12),
    n_ctpattern7 = rep(c(0, 1, 2, 3), 12),
    n_ctpattern5 = rep(c(0, 1, 2, 3), 12),
    n_ctpattern6 = rep(c(0, 1, 2, 3), 12),
    ct_mean = rep(c(29.952606, 35.316589, 27.758017, 32.070358), 12)
  ),
  row.names = c(NA, -48L), class = "data.frame"
)

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

# Function returns message confirming No missing dates
testthat::test_that("Function returns message confirming no missing dates", {
  testthat::expect_message(check_missing_dates
  (dummy_data, dummy_config))
})

# test warning produced if missing dates

dummy_data$visit_date <- rep(c(as.Date("26apr2020", format = "%d%b%Y"), as.Date("28apr2020", format = "%d%b%Y"), as.Date("29apr2020", format = "%d%b%Y"), as.Date("29apr2020", format = "%d%b%Y"), as.Date("30apr2020", format = "%d%b%Y"), as.Date("01may2020", format = "%d%b%Y"), as.Date("02may2020", format = "%d%b%Y"), as.Date("03may2020", format = "%d%b%Y"), as.Date("04may2020", format = "%d%b%Y"), as.Date("05may2020", format = "%d%b%Y"), as.Date("06may2020", format = "%d%b%Y"), as.Date("07may2020", format = "%d%b%Y")), 4)

testthat::test_that("Function returns warning confirming  missing dates", {
  w <- capture_warnings(try(check_missing_dates(dummy_data, dummy_config), silent = T))

  testthat::expect_equal(w[1], "The following dates are missing from the England aggregated sample: 2020-04-27. If these are expected, ignore this warning.")
  testthat::expect_equal(w[2], "The following dates are missing from the Wales aggregated sample: 2020-04-27. If these are expected, ignore this warning.")
  testthat::expect_equal(w[3], "The following dates are missing from the Scotland aggregated sample: 2020-04-27. If these are expected, ignore this warning.")
  testthat::expect_equal(w[4], "The following dates are missing from the Northern Ireland aggregated sample: 2020-04-27. If these are expected, ignore this warning.")
})
