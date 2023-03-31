dummy_data <- structure(
  list(
    visit_date = rep(c("26apr2020"), 12),
    n_pos = rep(c(0, 1, 2, 3), 3),
    n_neg = rep(c(0, 1, 2, 3), 3),
    n_void = rep(c(0, 1, 2, 3), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
)

output <- filter_days_with_no_returns(dummy_data)

# Test function returns data frame
testthat::test_that("function returns a dataframe", {
  expect_true(is.data.frame(output))
})

# Test Function returns 3 less rows as removes no returns days

testthat::test_that("Function creates output with 9 rows by removing no returns days", {
  testthat::expect_vector(output, ptype = NULL, size = 9)
})
