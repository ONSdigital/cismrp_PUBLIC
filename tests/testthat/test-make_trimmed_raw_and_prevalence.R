test_data <- prepare_sample_and_household_for_joining(
  synthetic_aggregated_sample, synthetic_aggregated_HH
) %>%
  join_raw_data() %>%
  join_raw_with_prevalence(synthetic_prevalence_time_series)

output <- make_trimmed_raw_and_prevalence(test_data, "country")

testthat::test_that(
  desc = "function returns a kableExtra",
  code = {
    testthat::expect_true("kableExtra" %in% class(output))
  }
)
