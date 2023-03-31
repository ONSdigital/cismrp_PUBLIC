test_data <- get_population_numbers_statement(
  synthetic_filtered_pop_tables,
  synthetic_prevalence_time_series,
  "England",
  "ctall"
)
test_data
testthat::test_that(
  desc = "function returns a string",
  code = {
    testthat::expect_true(class(test_data) == "character")
  }
)


testthat::test_that(
  desc = "function returns the correct format statement",
  code = {
    pattern_to_match <- "Between [0-9]{1,2} .* [0-9]{4}, we estimate that an average of [0-9]{1,2},[0-9]{1,3},[0-9]{1,3} people in England had COVID-19 \\(95% credible interval: [0-9]{1,3},[0-9]{1,3} to [0-9]{1,2},[0-9]{1,3},[0-9]{1,3}\\)."
    outcome <- grepl(pattern = pattern_to_match, x = test_data)
    testthat::expect_true(outcome)
  }
)
