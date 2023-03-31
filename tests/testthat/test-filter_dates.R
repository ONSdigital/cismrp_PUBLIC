countries <- list("Northern Ireland", "Wales", "Scotland", "England")

country_dummy_configs <- list(
  "Northern Ireland" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  ),
  "Wales" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  ),
  "Scotland" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  ),
  "England" = list(
    run_settings = list(
      variants = c(1, 2, 4, 5),
      n_days_to_model = 56,
      end_date = as.Date("20230413", format = "%Y%m%d")
    ),
    model_settings = list(
      by_region = as.logical("F"),
      knots = 6,
      seed = 42,
      adapt_delta = 0.59,
      cores = 4,
      chains = 4,
      iterations = 250,
      refresh = 0,
      prior = list(
        location = 0,
        scale = 0.5
      ),
      prior_smooth = list(
        location = 2
      ),
      prior_covariance = list(
        shape = 1,
        scale = 1
      )
    ),
    probability_output_settings = list(
      ref_days_from_end = 3,
      comparison_period = c(7, 14),
      percent_change_threshold = 15
    )
  )
)

dummy_data <- data.frame(visit_date = country_dummy_configs$Scotland$run_settings$end_date - 0:99, col2 = 1:100)

output <- filter_dates(dummy_data, country_dummy_configs, "Scotland")

expected_values <- country_dummy_configs$Scotland$run_settings$end_date - 0:55

# Test function filters older dates out
test_that("older dates are filtered out", {
  expect_equal(output$visit_date, expected_values)
})
