test_data <- get_population_percentage_statement(
  cismrp::synthetic_prevalence_time_series,
  "England",
  "ctall"
)


testthat::test_that(
  desc = "function returns a string",
  code = {
    testthat::expect_true(class(test_data) == "character")
  }
)

testthat::test_that(
  desc = "function returns the correct format statement",
  code = {
    pattern_to_match <- "This equates to [0-9]{1,2}.[0-9]{1,2}% of the population who had COVID-19 \\(95% credible interval: [0-9]{1,2}.[0-9]{1,2}% to [0-9]{1,2}.[0-9]{1,2}%\\) or around 1 in [0-9]{1,4} people."
    outcome <- grepl(pattern = pattern_to_match, x = test_data)
    testthat::expect_true(outcome)
  }
)
