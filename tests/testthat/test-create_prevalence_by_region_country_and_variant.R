test_data <- create_prevalence_by_region_country_and_variant(
  region = "North East",
  country = "England",
  variant = "1",
  post_stratified_draws = dummy_post_stratified_draws,
  country_configs = dummy_country_configs
)


testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "function an object with the dimensions 49x7",
  code = {
    testthat::expect_true(all(dim(test_data) == c(49, 7)))
  }
)

testthat::test_that(
  desc = "function the correct colnames",
  code = {
    expected_names <- c(
      "region",
      "time",
      "mean",
      "ll",
      "ul",
      "country",
      "variant"
    )
    testthat::expect_true(all(colnames(test_data) %in% expected_names))
  }
)

testthat::test_that(
  desc = "function the correct column types",
  code = {
    actual_types <- purrr::map(test_data, class)
    expected_types <- c(
      rep("character", 2),
      rep("numeric", 3),
      rep("character", 2)
    )
    testthat::expect_true(all(actual_types == expected_types))
  }
)
