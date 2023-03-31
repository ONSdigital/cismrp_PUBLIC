testthat::test_that(
  desc = "Function returns a data frame",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    ) %>%
      join_raw_data()
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "Function returns the correct dimensions",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    ) %>%
      join_raw_data()
    testthat::expect_true(all(dim(test_data) == c(660, 10)))
  }
)

testthat::test_that(
  desc = "listed dataframes contain the correct colnames",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    ) %>%
      join_raw_data()
    expected_names <- c(
      "region",
      "time",
      "unweighted_percentage_household",
      "unweighted_percentage_participant",
      "total_household",
      "total_participant",
      "positives_household",
      "positives_participant",
      "most_positives_within_household",
      "most_positives_within_participant"
    )
    testthat::expect_true(
      all(colnames(test_data) %in% expected_names)
    )
  }
)

testthat::test_that(
  desc = "Function returns the correct column types",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    ) %>%
      join_raw_data()
    test_classes <- purrr::map(test_data, class)
    expected_types <- c(
      rep("character", 2),
      rep("numeric", 7),
      rep("character", 5)
    )
    testthat::expect_true(all(colnames(test_classes) %in% expected_types))
  }
)
