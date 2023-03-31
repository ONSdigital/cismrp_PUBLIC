testthat::test_that(
  desc = "Function returns a data frame",
  code = {
    test_data <- create_raw_counts_with_prevalence(
      synthetic_aggregated_sample,
      synthetic_aggregated_HH,
      synthetic_prevalence_time_series
    )
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "Function returns the correct dimensions",
  code = {
    test_data <- create_raw_counts_with_prevalence(
      synthetic_aggregated_sample,
      synthetic_aggregated_HH,
      synthetic_prevalence_time_series
    )
    testthat::expect_true(all(dim(test_data) == c(105, 9)))
  }
)

testthat::test_that(
  desc = "listed dataframes contain the correct colnames",
  code = {
    test_data <- create_raw_counts_with_prevalence(
      synthetic_aggregated_sample,
      synthetic_aggregated_HH,
      synthetic_prevalence_time_series
    )
    expected_names <- c(
      "region",
      "country",
      "visit_date",
      "N",
      "positives",
      "n_hh_with_pos",
      "max_pos_hh",
      "proportion",
      "mean_estimate"
    )
    testthat::expect_true(
      all(colnames(test_data) %in% expected_names)
    )
  }
)

testthat::test_that(
  desc = "Function returns the correct column types",
  code = {
    test_data <- create_raw_counts_with_prevalence(
      synthetic_aggregated_sample,
      synthetic_aggregated_HH,
      synthetic_prevalence_time_series
    )
    test_classes <- purrr::map(test_data, class)
    expected_types <- c(
      rep("character", 3),
      rep("numeric", 6)
    )
    testthat::expect_true(all(colnames(test_classes) %in% expected_types))
  }
)
