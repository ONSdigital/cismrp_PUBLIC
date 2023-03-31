testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    test_data <- probabilities_compared_to_previously_published(
      dummy_reference_day_vs_weeks_before_probabilities,
      dummy_reference_day_vs_weeks_before_probabilities
    )
    testthat::expect_s3_class(object = test_data, class = "data.frame")
  }
)

testthat::test_that(
  desc = "function an object with the dimensions of 16x9",
  code = {
    test_data <- probabilities_compared_to_previously_published(
      dummy_reference_day_vs_weeks_before_probabilities,
      dummy_reference_day_vs_weeks_before_probabilities
    )
    testthat::expect_true(all(dim(test_data) == c(16, 9)))
  }
)


testthat::test_that(
  desc = "function returns the correct colnames",
  code = {
    test_data <- probabilities_compared_to_previously_published(
      dummy_reference_day_vs_weeks_before_probabilities,
      dummy_reference_day_vs_weeks_before_probabilities
    )
    expected_colnames <- c(
      "comparison_period",
      "region",
      "variant",
      "probability_increase_current",
      "summary_current",
      "probability_increase_previous",
      "summary_previous",
      "formatting_current",
      "formatting_previous"
    )
    testthat::expect_true(all(colnames(test_data) %in% expected_colnames))
  }
)
