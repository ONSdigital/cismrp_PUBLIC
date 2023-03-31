dummy_data <- structure(
  list(
    gor_code = rep(c("E12000001", "E12000002", "E12000003", "E12000004", "E12000005", "E12000006", "E12000007", "E12000008", "E12000009", "N99999999", "S99999999", "W99999999"), 4),
    sex = rep(c("Male", "Female", "Male", "Female", "Male", "Female", "Male", "Female", "Male", "Female", "Male", "Female"), 4),
    age_group = rep(c("2_11", "12_16", "17_24", "25_34", "35_49", "50_69", "70+", "2_11", "17_24", "25_34", "35_49", "50_69"), 4),
    region = c(
      "North_East_England", "North_West_England", "Yorkshire",
      "East_Midlands", "West_Midlands", "East_England", "London",
      "South_East_England", "South_West_England", "Northern_Ireland",
      "Scotland", "Wales",
      "North_East_England_1", "North_West_England_1",
      "Yorkshire_1", "East_Midlands_1",
      "West_Midlands_1", "East_England_1",
      "London_1", "South_East_England_1",
      "South_West_England_1", "Northern_Ireland_1",
      "Scotland_1", "Wales_1", "North_East_England_2", "North_West_England_2", "Yorkshire_2", "East_Midlands_2", "West_Midlands_2", "East_England_2", "London_2", "South_East_England_2", "South_West_England_2", "Northern_Ireland_2", "Scotland_2", "Wales_2", "North_East_England_3", "North_West_England_3", "Yorkshire_3", "East_Midlands_3", "West_Midlands_3", "East_England_3", "London_3", "South_East_England_3", "South_West_England_3", "Northern_Ireland_3", "Scotland_3", "Wales_3"
    ),
    lab_id = rep(c("GLS"), 48),
    N = rep(c(
      156095,
      76293, 127286, 171797, 226730, 336546, 147522, 72755, 119118, 127286, 226730, 127286
    ), 4)
  ),
  row.names = c(NA, -48L), class = "data.frame"
)

cleaned_dummy_data <- clean_population_counts(dummy_data)
output <- merge_boost_regions(cleaned_dummy_data)
output

# Test function returns data frame
testthat::test_that("function returns a dataframe", {
  expect_true(is.data.frame(output))
})


# Test that number of columns in output dataframe is 6
testthat::test_that("Function creates output with 6 columns", {
  testthat::expect_length(output, 6)
})


# Test column names created
expected_col_names <- c("gor_code", "sex", "age_group", "region", "lab_id", "N")

testthat::test_that("columns have right names", {
  expect_named(output, expected_col_names)
})

# Test Function merges boost regions correctly so returns less rows

testthat::test_that("Function creates output with 12 row by merging boost regions", {
  testthat::expect_vector(output, ptype = NULL, size = 12)
})
