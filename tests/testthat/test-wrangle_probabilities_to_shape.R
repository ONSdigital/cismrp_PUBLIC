test_data <- filter_draws_by_region_country_and_variant(
  dummy_post_stratified_draws,
  "All",
  "England",
  "1"
) %>%
  create_comparison_dates_dataframe(dummy_country_configs, "England") %>%
  probability_of_increase() %>%
  probability_of_at_least_x_percent_increase(dummy_country_configs, "England") %>%
  probability_of_at_least_x_percent_decrease(dummy_country_configs, "England") %>%
  add_region_country_and_variant_cols("North East", "England", "1") %>%
  wrangle_probabilities_to_shape()

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
      rep("character", 4),
      rep("numeric", 3)
    )
    testthat::expect_true(all(col_classes == expected_col_classes))
  }
)

testthat::test_that(
  desc = "Function returns a dataframe with two rows and seven columns",
  code = {
    testthat::expect_true(all(dim(test_data) == c(2, 7)))
  }
)

testthat::test_that(
  desc = "Function returns a dataframe with the correctly named columns",
  code = {
    testthat::expect_true(all(colnames(test_data) == c(
      "region",
      "country",
      "variant",
      "comparison_period",
      "probability_increase",
      "prob_min_15_percent_increase",
      "prob_min_15_percent_decrease"
    )))
  }
)
