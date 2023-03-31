test_data <- calculate_probabilities_by_region_country_and_variant(
  region = "All",
  country = "England",
  variant = "1",
  post_stratified_draws = dummy_post_stratified_draws,
  country_configs = dummy_country_configs
)

test_data
testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    testthat::expect_s3_class(object = test_data, class = "data.frame")
  }
)

testthat::test_that(
  desc = "function returns the correct column types",
  code = {
    col_classes <- purrr::map(test_data, class)
    expected_col_classes <- c(
      rep("character", 2),
      rep("numeric", 3),
      rep("character", 3)
    )
    testthat::expect_true(all(col_classes == expected_col_classes))
  }
)

testthat::test_that(
  desc = "Function returns a dataframe with two rows and seven columns",
  code = {
    testthat::expect_true(all(dim(test_data) == c(2, 8)))
  }
)

testthat::test_that(
  desc = "Function returns a dataframe with the correctly named columns",
  code = {
    testthat::expect_true(all(colnames(test_data) == c(
      "comparison_period",
      "region",
      "probability_increase",
      "prob_min_15_percent_increase",
      "prob_min_15_percent_decrease",
      "summary",
      "country",
      "variant"
    )))
  }
)
