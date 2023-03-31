test_data <- filter_draws_by_region_country_and_variant(
  dummy_post_stratified_draws,
  "All",
  "England",
  "1"
)
testthat::test_that(
  desc = "function returns a matrix",
  code = {
    testthat::expect_true("matrix" %in% class(test_data))
  }
)

testthat::test_that(
  desc = "function returns an array of doubles",
  code = {
    testthat::expect_true(typeof(test_data) == "double")
  }
)
