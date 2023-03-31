testthat::test_that(
  desc = "function returns a vector that has been lagged twice and summed",
  code = {
    test_data <- c(1, 1, 1, 1, 1, 1, 1)
    test_value <- lag_twice_and_sum(test_data)
    expected_outcome <- c(NA, NA, 3, 3, 3, 3, 3)
    testthat::expect_equal(
      object = test_value,
      expected = expected_outcome
    )
  }
)

testthat::test_that(
  desc = "function returns a vector",
  code = {
    test_data <- c(1, 1, 1, 1, 1, 1, 1)
    test_value <- lag_twice_and_sum(test_data)
    testthat::expect_vector(object = test_value)
  }
)

testthat::test_that(
  desc = "function returns an error if non-numeric",
  code = {
    test_data <- c(1, "c", 1, 1)
    testthat::expect_error(lag_twice_and_sum(test_data_error))
  }
)
