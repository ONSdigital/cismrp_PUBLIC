testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    test_data <- data.frame(
      visit_date = rep(seq(20220301, 20220305, 1), 2),
      n_pos = seq(1, 10, 1),
      n_total = seq(21, 30, 1)
    )

    test_value <- aggregate_raw_england_region_stats(
      test_data, "England", "region"
    )

    testthat::expect_true(class(test_value) == "data.frame")
  }
)

testthat::test_that(
  desc = "function aggregates data when region_or_country == 'country' and country_filter == `England`",
  code = {
    test_data <- data.frame(
      visit_date = rep(seq(20220301, 20220305, 1), 2),
      n_pos = seq(1, 10, 1),
      n_total = seq(21, 30, 1)
    )

    test_value <- aggregate_raw_england_region_stats(
      test_data, "England", "country"
    )

    testthat::expect_true(nrow(test_value) < nrow(test_data))

    # negative test
    test_value <- aggregate_raw_england_region_stats(
      test_data, "Northern Ireland", "country"
    )

    testthat::expect_true(nrow(test_value) == nrow(test_data))
  }
)

testthat::test_that(
  desc = "function adds region column (region==England) when region_or_country == 'country' and country_filter == `England`",
  code = {
    test_data <- data.frame(
      visit_date = rep(seq(20220301, 20220305, 1), 2),
      n_pos = seq(1, 10, 1),
      n_total = seq(21, 30, 1)
    )

    test_value <- aggregate_raw_england_region_stats(
      test_data, "England", "country"
    ) %>%
      colnames()

    testthat::expect_true("region" %in% test_value)
  }
)
