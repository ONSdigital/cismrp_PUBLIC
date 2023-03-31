dummy_data <- structure(
  list(
    data_run_date = rep(c(as.Date = "05dec2022", format = "%d%b%Y"), 12),
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
    region = factor(
      c(
        "North East", "North West",
        "Yorkshire and The Humber",
        "East Midlands", "West Midlands",
        "East of England", "London",
        "South East", "South West",
        "Northern Ireland", "Wales", "Scotland"
      ),
      levels = c(
        "London", "South East",
        "North West", "South West",
        "West Midlands", "East Midlands",
        "East of England",
        "Yorkshire and The Humber",
        "North East", "Northern Ireland",
        "Scotland", "Wales"
      )
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

output <- check_missing_dates_between(
  dummy_data, "Scotland",
  as.Date("26apr2020", format = "%d%b%Y"),
  as.Date("07may2020", format = "%d%b%Y")
)

# Function returns message confirming No missing dates
testthat::test_that("Function returns message confirming no missing dates", {
  testthat::expect_message(check_missing_dates_between
  (
    dummy_data, "Scotland",
    as.Date("26apr2020", format = "%d%b%Y"),
    as.Date("07may2020", format = "%d%b%Y")
  ))
})

# test warning produced if missing dates

dummy_data$visit_date <- c(as.Date("26apr2020", format = "%d%b%Y"), as.Date("28apr2020", format = "%d%b%Y"), as.Date("29apr2020", format = "%d%b%Y"), as.Date("29apr2020", format = "%d%b%Y"), as.Date("30apr2020", format = "%d%b%Y"), as.Date("01may2020", format = "%d%b%Y"), as.Date("02may2020", format = "%d%b%Y"), as.Date("03may2020", format = "%d%b%Y"), as.Date("04may2020", format = "%d%b%Y"), as.Date("05may2020", format = "%d%b%Y"), as.Date("06may2020", format = "%d%b%Y"), as.Date("07may2020", format = "%d%b%Y"))

testthat::test_that("Function returns warning confirming  missing dates", {
  testthat::expect_warning(check_missing_dates_between
  (
    dummy_data, "Scotland",
    as.Date("26apr2020", format = "%d%b%Y"),
    as.Date("07may2020", format = "%d%b%Y")
  ))
})
