create_raw_vs_prevalence_table_output <- create_raw_vs_prevalence_table(synthetic_aggregated_sample, synthetic_aggregated_HH, synthetic_prevalence_time_series, "Scotland", "country")


testthat::test_that(
  desc = "function returns a kableExtra",
  code = {
    testthat::expect_true("kableExtra" %in% class(create_raw_vs_prevalence_table_output))
  }
)
