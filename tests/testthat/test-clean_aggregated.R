dummy_data <- structure(
  list(
    visit_date = rep(c("26apr2020"), 12),
    sex = c(
      "Male", "Female", "Male", "Female", "Male",
      "Female", "Male", "Female", "Male",
      "Female", "Male", "Female"
    ),
    ageg_7 = c(
      "2-11", "12-16", "17-24", "25-34",
      "35-49", "50-69", "70+", "2-11",
      "17-24", "25-34", "35-49", "50-69"
    ),
    gor9d = c(
      "E12000001", "E12000002", "E12000003", "E12000004",
      "E12000005", "E12000006", "E12000007", "E12000008",
      "E12000009", "N99999999", "W99999999", "S99999999"
    ),
    gor_name = c(
      "1_NE", "2_NW", "3_YH", "4_EM",
      "5_WM", "6_EE", "7_LD", "8_SE",
      "9_SW", "10_NI", "12_WAL", "11_SCO"
    ),
    ethnicityg = c(
      "White", "Mixed", "Asian", "Other", "Black", "White",
      "Mixed", "Asian", "Other", "Black", "White", "Mixed"
    ),
    lab_id = c(
      "MK", "GLS", "z-exception", "LML", "BB", "MK",
      "GLS", "z-exception", "LML", "BB", "MK", "GLS"
    ),
    data_run_date = rep(c("05dec2022"), 12),
    n_pos = rep(c(0, 1, 2, 3), 3),
    n_neg = rep(c(0, 1, 2, 3), 3),
    n_void = rep(c(0, 1, 2, 3), 3),
    ab_pos = rep(c(0, 1, 2, 3), 3),
    ab_pos42 = rep(c(0, 1, 2, 3), 3),
    ab_pos179 = rep(c(0, 1, 2, 3), 3),
    ab_pos800 = rep(c(0, 1, 2, 3), 3),
    ab_neg = rep(c(0, 1, 2, 3), 3),
    ab_neg42 = rep(c(0, 1, 2, 3), 3),
    ab_neg179 = rep(c(0, 1, 2, 3), 3),
    ab_neg800 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern1 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern2 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern4 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern5 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern6 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern7 = rep(c(0, 1, 2, 3), 3),
    ct_mean = rep(c(29.952606, 35.316589, 27.758017, 32.070358), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
)


output <- clean_aggregated(dummy_data)

# Test function returns data frame
testthat::test_that("function returns a dataframe", {
  expect_true(is.data.frame(output))
})

# Test column names created
expected_col_names <- c("data_run_date", "visit_date", "sex", "age_group", "region", "country", "lab_id", "n_pos", "n_neg", "n_void", "ab_pos", "ab_neg", "n_ctpattern4", "n_ctpattern7", "n_ctpattern5", "n_ctpattern6", "mean(ct_mean, na.rm = TRUE)")

testthat::test_that("columns have right names", {
  expect_named(output, expected_col_names)
})

# Test that number of columns in output dataframe is 16
testthat::test_that("Function creates output with 17 columns", {
  testthat::expect_length(output, 17)
})


# Function returns visit date reformatted as date
testthat::test_that("visit date formatted as date", {
  testthat::expect_type(output$visit_date, "double")
})

# Function returns data_run_date reformatted as date
testthat::test_that("data_run_date formatted as date", {
  testthat::expect_type(output$data_run_date, "double")
})

# Function recodes region names

expected_region_names <- factor(
  c(
    "North East", "South West",
    "Yorkshire and The Humber", "West Midlands",
    "Wales", "London", "South East",
    "North West", "East Midlands", "Northern Ireland",
    "East of England", "Scotland"
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
)
actual_region_names <- output %>% dplyr::pull(region)

testthat::test_that("region names, levels and type are correct", {
  testthat::expect_equal(actual_region_names, expected_region_names)
})

# Function returns new clean age_groups with correct levels and as a factor
expected_age_groups <- factor(c("2-11", "12-16", "17-24", "25-34", "35-49", "50-69", "70+"), levels = c("2-11", "12-16", "17-24", "25-34", "35-49", "50-69", "70+"))

actual_age_groups <- levels(output %>% dplyr::pull(age_group))

testthat::test_that("age_groups, levels and type are correct", {
  expect_equal(actual_age_groups, levels(expected_age_groups))
})
