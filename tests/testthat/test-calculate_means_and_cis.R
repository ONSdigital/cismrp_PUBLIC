test_data <- filter_draws_by_region_country_and_variant(
  post_stratified_draws = dummy_post_stratified_draws,
  region = "North East",
  country = "England",
  variant = "1"
) %>%
  transform_matrix_to_dataframe_with_dates(dummy_country_configs, "England") %>%
  calculate_means_and_cis()


testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "function an object with the dimensions 49x4",
  code = {
    testthat::expect_true(all(dim(test_data) == c(49, 4)))
  }
)

testthat::test_that(
  desc = "function the correct colnames",
  code = {
    expected_names <- c(
      "date",
      "mean",
      "ll",
      "ul"
    )
    testthat::expect_true(all(colnames(test_data) %in% expected_names))
  }
)

testthat::test_that(
  desc = "function the correct column types",
  code = {
    actual_types <- purrr::map(test_data, class)
    expected_types <- c(
      "character",
      rep("numeric", 3)
    )
    testthat::expect_true(all(actual_types == expected_types))
  }
)
