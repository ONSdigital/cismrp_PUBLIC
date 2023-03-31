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


dummy_data <- structure(
  list(
    visit_date = country_dummy_configs$Scotland$run_settings$end_date - 0:11,
    sex = c(
      "Male", "Female", "Male", "Female", "Male",
      "Female", "Male", "Female", "Male",
      "Female", "Male", "Female"
    ),
    ageg_7 = c(
      "2-11", "12-16", "17-24", "25-34",
      "35-49", "50-69", "70+", "2-11",
      "17-24", "25-34", "35-49", "50-69"
    ),
    gor9d = c(
      "E12000001", "E12000002", "E12000003", "E12000004",
      "E12000005", "E12000006", "E12000007", "E12000008",
      "E12000009", "N99999999", "W99999999", "S99999999"
    ),
    gor_name = c(
      "1_NE", "2_NW", "3_YH", "4_EM",
      "5_WM", "6_EE", "7_LD", "8_SE",
      "9_SW", "10_NI", "12_WAL", "11_SCO"
    ),
    ethnicityg = c(
      "White", "Mixed", "Asian", "Other", "Black", "White",
      "Mixed", "Asian", "Other", "Black", "White", "Mixed"
    ),
    lab_id = c(
      "MK", "GLS", "z-exception", "LML", "BB", "MK",
      "GLS", "z-exception", "LML", "BB", "MK", "GLS"
    ),
    data_run_date = rep(c("05dec2022"), 12),
    n_pos = rep(c(0, 1, 2, 3), 3),
    n_neg = rep(c(0, 1, 2, 3), 3),
    n_void = rep(c(0, 1, 2, 3), 3),
    ab_pos = rep(c(0, 1, 2, 3), 3),
    ab_pos42 = rep(c(0, 1, 2, 3), 3),
    ab_pos179 = rep(c(0, 1, 2, 3), 3),
    ab_pos800 = rep(c(0, 1, 2, 3), 3),
    ab_neg = rep(c(0, 1, 2, 3), 3),
    ab_neg42 = rep(c(0, 1, 2, 3), 3),
    ab_neg179 = rep(c(0, 1, 2, 3), 3),
    ab_neg800 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern1 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern2 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern4 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern5 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern6 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern7 = rep(c(0, 1, 2, 3), 3),
    ct_mean = rep(c(29.952606, 35.316589, 27.758017, 32.070358), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
)

dummy_data <- clean_aggregated(dummy_data)

country_list <- get_map_lists(countries, country_dummy_configs)$country

variant_list <- get_map_lists(countries, country_dummy_configs)$variant

output <- filter_aggregated_samp(
  dummy_data,
  country_dummy_configs,
  country_list,
  variant_list
)

output

# Test function creates 16 dataframes, 1 for each variant for each country
testthat::test_that("Function creates output with 16 dataframes (1 for each country and each variant)", {
  testthat::expect_vector(output, ptype = NULL, size = 16)
})


# Test column names created
expected_col_names <- c("Northern Ireland1", "Northern Ireland2", "Northern Ireland4", "Northern Ireland5", "Wales1", "Wales2", "Wales4", "Wales5", "Scotland1", "Scotland2", "Scotland4", "Scotland5", "England1", "England2", "England4", "England5")

testthat::test_that("Dataframes for each variant for each country are created", {
  expect_named(output, expected_col_names)
})
