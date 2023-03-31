test_data <- get_previous_population_percentage_statement(
  cismrp::synthetic_previous_prevalence_time_series,
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
    pattern_to_match <- "Previously, the percentage we reported as testing positive was [0-9]{1,2}.[0-9]{1,2}% \\(95% credible interval: [0-9]{1,2}.[0-9]{1,2}% to [0-9]{1,2}.[0-9]{1,2}%\\) or around 1 in [0-9]{1,4} people."
    outcome <- grepl(pattern = pattern_to_match, x = test_data)
    testthat::expect_true(outcome)
  }
)
