testthat::test_that(
  desc = "Function returns a dataframe",
  code = {
    test_data <- transform_gor_name_to_full_name(synthetic_aggregated_sample)
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "Function returns an object of the correct dimensions",
  code = {
    test_data <- transform_gor_name_to_full_name(synthetic_aggregated_sample)
    testthat::expect_true(all(dim(test_data) == c(28875, 28)))
  }
)

testthat::test_that(
  desc = "Function returns the correct column names",
  code = {
    test_data <- transform_gor_name_to_full_name(synthetic_aggregated_sample)
    expected_names <- c(
      "visit_date",
      "sex",
      "ageg_7",
      "gor9d",
      "gor_name",
      "ethnicityg",
      "lab_id",
      "data_run_date",
      "n_pos",
      "n_neg",
      "n_void",
      "ab_pos",
      "ab_pos42",
      "ab_pos179",
      "ab_pos800",
      "ab_neg",
      "ab_neg42",
      "ab_neg179",
      "ab_neg800",
      "n_ctpattern1",
      "n_ctpattern2",
      "n_ctpattern4",
      "n_ctpattern5",
      "n_ctpattern6",
      "n_ctpattern7",
      "ct_mean",
      "region",
      "country"
    )
    testthat::expect_true(all(colnames(test_data) %in% expected_names))
  }
)

testthat::test_that(
  desc = "Function returns the correct column types",
  code = {
    test_data <- purrr::map(
      transform_gor_name_to_full_name(synthetic_aggregated_sample), class
    )
    expected_types <- c(
      rep("character", 8),
      rep("numeric", 3),
      rep("logical", 8),
      rep("numeric", 6),
      "logical",
      rep("character", 2)
    )
    testthat::expect_true(all(colnames(test_data) %in% expected_types))
  }
)
