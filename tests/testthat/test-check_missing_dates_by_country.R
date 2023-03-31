dummy_data <- structure(
  list(
    data_run_date = rep(c(as.Date("05dec2022", format = "%d%b%Y")), 12),
    visit_date = c(seq(as.Date("26apr2020", format = "%d%b%Y"),
      as.Date("07may2020", format = "%d%b%Y"),
      by = "day"
    )),
    sex = factor(c(
      "Male", "Female", "Male", "Female", "Male",
      "Female", "Male", "Female", "Male",
      "Female", "Male", "Female"
    ), levels = c("Male", "Female")),
    age_group = factor(
      c(
        "2-11", "12-16", "17-24", "25-34",
        "35-49", "50-69", "70+", "2-11",
        "17-24", "25-34", "35-49", "50-69"
      ),
      levels = c(
        "2-11", "12-16",
        "17-24", "25-34",
        "35-49", "50-69", "70+"
      )
    ),
    region = factor(rep(c("Scotland"), 12),
      levels = "Scotland"
    ),
    lab_id = factor(
      c(
        "NA", "GLS", "LML", "BB", "NA", "GLS", "LML",
        "BB", "NA", "GLS", "LML", "BB"
      ),
      levels = c("GLS", "LML", "BB", "NA")
    ),
    n_pos = rep(c(0, 1, 2, 3), 3),
    n_neg = rep(c(0, 1, 2, 3), 3),
    n_void = rep(c(0, 1, 2, 3), 3),
    ab_pos = rep(c(0, 1, 2, 3), 3),
    ab_neg = rep(c(0, 1, 2, 3), 3),
    n_ctpattern4 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern7 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern5 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern6 = rep(c(0, 1, 2, 3), 3),
    ct_mean = rep(c(29.952606, 35.316589, 27.758017, 32.070358), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
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

output <- check_missing_dates_by_country("Scotland", dummy_data, dummy_config)


# Function returns message confirming No missing dates
testthat::test_that("Function returns message confirming no missing dates", {
  testthat::expect_message(check_missing_dates_by_country
  ("Scotland", dummy_data, dummy_config))
})

# test warning produced if missing dates

dummy_data$visit_date <- c(as.Date("26apr2020", format = "%d%b%Y"), as.Date("28apr2020", format = "%d%b%Y"), as.Date("29apr2020", format = "%d%b%Y"), as.Date("29apr2020", format = "%d%b%Y"), as.Date("30apr2020", format = "%d%b%Y"), as.Date("01may2020", format = "%d%b%Y"), as.Date("02may2020", format = "%d%b%Y"), as.Date("03may2020", format = "%d%b%Y"), as.Date("04may2020", format = "%d%b%Y"), as.Date("05may2020", format = "%d%b%Y"), as.Date("06may2020", format = "%d%b%Y"), as.Date("07may2020", format = "%d%b%Y"))

testthat::test_that("Function returns warning confirming  missing dates", {
  testthat::expect_warning(check_missing_dates_by_country
  ("Scotland", dummy_data, dummy_config))
})

# Need to have start and end date within Scotland despite being filtered by country. Here the data is all Scotland, so that dummy_data remains short, but filtering by country as part of this function, does not restrict the data and therefore the amount of visit days.
