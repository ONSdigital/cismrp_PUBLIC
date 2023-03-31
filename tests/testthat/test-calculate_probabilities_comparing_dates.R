countries <- list("Scotland", "England")
country_list <- cismrp::get_map_lists(countries, dummy_country_configs)$country
variant_list <- cismrp::get_map_lists(countries, dummy_country_configs)$variant

region_list <- list(
  "All", "North East", "North West",
  "Yorkshire and The Humber", "East Midlands",
  "West Midlands", "East of England", "London",
  "South East", "South West"
)


test_data <- calculate_probabilities_comparing_dates(
  dummy_post_stratified_draws,
  dummy_country_configs,
  region_list,
  country_list,
  variant_list
)


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
    testthat::expect_true(ncol(test_data) == 8)
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
