dummy_data <- structure(
  list(
    gor_code = c("E12000001", "E12000002", "E12000003", "E12000004", "E12000005", "E12000006", "E12000007", "E12000008", "E12000009", "E12000001", "E12000001", "E12000001"),
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

output <- clean_population_counts(dummy_data)

# Test that number of columns increases by 1 to 6 columns
testthat::test_that("Function creates output with 6 columns", {
  testthat::expect_length(output, 6)
})

# Test column names created
col_names <- c("gor_code", "sex", "age_group", "region", "lab_id", "N")

testthat::test_that("columns have right names", {
  expect_named(output, col_names)
})

# Test function returns data frame
testthat::test_that("function returns a dataframe", {
  expect_true(is.data.frame(output))
})
