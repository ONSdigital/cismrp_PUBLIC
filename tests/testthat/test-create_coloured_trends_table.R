test_data <- probabilities_compared_to_previously_published(
  dummy_reference_day_vs_weeks_before_probabilities,
  dummy_reference_day_vs_weeks_before_probabilities
)

create_coloured_trends_table_output <- create_coloured_trends_table(test_data, "England", "ctall", "country")

testthat::test_that(
  desc = "function returns a kableExtra",
  code = {
    testthat::expect_true("kableExtra" %in% class(create_coloured_trends_table_output))
  }
)
