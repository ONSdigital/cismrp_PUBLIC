testthat::test_that(
  desc = "Function returns a list object",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    )
    testthat::expect_type(test_data, "list")
  }
)

testthat::test_that(
  desc = "Function returns the correct named list objects",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    )
    expected_names <- c("clean_sample", "clean_hh")

    testthat::expect_true(all(names(test_data) %in% expected_names))
  }
)

testthat::test_that(
  desc = "listed dataframes contain the correct colnames",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    )
    expected_names <- c(
      "group",
      "region",
      "country",
      "time",
      "total",
      "positives",
      "most_positives_within"
    )
    testthat::expect_true(
      all(colnames(test_data$clean_sample) %in% expected_names)
    )
  }
)

testthat::test_that(
  desc = "Function returns the correct column types",
  code = {
    test_data <- prepare_sample_and_household_for_joining(
      synthetic_aggregated_sample, synthetic_aggregated_HH
    )
    test_classes <- purrr::map(test_data, class)
    expected_types <- c(
      rep("character", 4),
      rep("numeric", 2),
      rep("logical", 1)
    )
    testthat::expect_true(all(colnames(test_classes) %in% expected_types))
  }
)
