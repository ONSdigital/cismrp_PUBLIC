countries <- list("Scotland", "England")

country_list <- cismrp::get_map_lists(
  countries, dummy_country_configs
)$country

variant_list <- cismrp::get_map_lists(
  countries, dummy_country_configs
)$variant

region_list <- list(
  "All", "North East", "North West",
  "Yorkshire and The Humber", "East Midlands",
  "West Midlands", "East of England", "London",
  "South East", "South West"
)

test_data <- create_prevalence_series(
  dummy_country_configs,
  dummy_post_stratified_draws,
  region_list,
  country_list,
  variant_list
)


testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "function an object with the dimensions 2184x7",
  code = {
    testthat::expect_true(all(dim(test_data) == c(2184, 7)))
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
