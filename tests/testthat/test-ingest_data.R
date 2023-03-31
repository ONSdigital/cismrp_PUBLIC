# Test function returns data frame
testthat::test_that("function returns a dataframe", {
  testthat::skip_on_ci()
  output <- ingest_data(
    dummy_config$paths$household_checks,
    dummy_config$run_settings$data_run
  )

  testthat::expect_true(is.data.frame(output))
})
