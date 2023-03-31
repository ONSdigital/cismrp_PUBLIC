test_data <- filter_draws_by_region_country_and_variant(
  dummy_post_stratified_draws,
  "All",
  "England",
  "1"
) %>%
  create_comparison_dates_dataframe(dummy_country_configs, "England") %>%
  probability_of_increase()

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
    expected_col_classes <- c(rep("numeric", 5))
    testthat::expect_true(all(col_classes == expected_col_classes))
  }
)

testthat::test_that(
  desc = "Function returns a dataframe with the correctly named columns",
  code = {
    testthat::expect_true(
      all(colnames(test_data) == c(
        "reference_day",
        "week_minus_1",
        "week_minus_2",
        "probability_increase_week_minus_1",
        "probability_increase_week_minus_2"
      ))
    )
  }
)
