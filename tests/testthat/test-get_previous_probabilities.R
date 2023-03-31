testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    skip_on_ci()
    gcptools::authenticate_gcp()
    test_data <- get_previous_probabilities(
      format_config_end_dates(dummy_config)
    )
    testthat::expect_s3_class(object = test_data, class = "data.frame")
  }
)

testthat::test_that(
  desc = "function an object with the dimensions of 104x8",
  code = {
    skip_on_ci()
    gcptools::authenticate_gcp()
    test_data <- get_previous_probabilities(
      format_config_end_dates(dummy_config)
    )
    testthat::expect_true(all(dim(test_data) == c(104, 8)))
  }
)


testthat::test_that(
  desc = "function returns the correct colnames",
  code = {
    skip_on_ci()
    gcptools::authenticate_gcp()
    test_data <- get_previous_probabilities(
      format_config_end_dates(dummy_config)
    )
    expected_colnames <- c(
      "...1",
      "comparison_period",
      "region",
      "probability_increase",
      "prob_min_15_percent_increase",
      "prob_min_15_percent_decrease",
      "summary",
      "country",
      "variant",
      "prob_below_0_1_percent",
      "prob_below_0_2_percent"
    )
    testthat::expect_true(all(colnames(test_data) %in% expected_colnames))
  }
)
