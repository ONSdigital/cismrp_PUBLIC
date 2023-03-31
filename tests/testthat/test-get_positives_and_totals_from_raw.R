testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    test_data_sample <- data.frame(
      n_pos = seq(1, 10, 1),
      n_neg = seq(99, 90, -1)
    )
    test_value <- get_positives_and_totals_from_raw(test_data_sample)
    testthat::expect_true(class(test_value) == "data.frame")
  }
)

testthat::test_that(
  desc = "returns columns n_total and n_pos",
  code = {
    test_data_sample <- data.frame(
      n_pos = seq(1, 10, 1),
      n_neg = seq(99, 90, -1)
    )
    test_value <- get_positives_and_totals_from_raw(test_data_sample)
    testthat::expect_true(
      all(c("n_pos", "n_total") %in% names(test_value))
    )
  }
)
