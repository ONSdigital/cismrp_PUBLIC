testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    test_data <- data.frame(
      region = c(rep(c("England", "Wales"), 10)),
      visit_date = sort(rep(seq(20220101, 20220110, 1), 2)),
      n_total = seq(11, 30, 1),
      n_pos = seq(1, 20, 1)
    )
    test_value <- positivity_rolling_mean(test_data)
    testthat::expect_true("data.frame" %in% class(test_value))
  }
)

testthat::test_that(
  desc = "function returns an object with 7 columns",
  code = {
    test_data <- data.frame(
      region = c(rep(c("England", "Wales"), 10)),
      visit_date = sort(rep(seq(20220101, 20220110, 1), 2)),
      n_total = seq(11, 30, 1),
      n_pos = seq(1, 20, 1)
    )
    test_value <- positivity_rolling_mean(test_data)
    testthat::expect_true(ncol(test_value) == 7)
  }
)

testthat::test_that(
  desc = "function returns correct column names",
  code = {
    test_data <- data.frame(
      region = c(rep(c("England", "Wales"), 10)),
      visit_date = sort(rep(seq(20220101, 20220110, 1), 2)),
      n_total = seq(11, 30, 1),
      n_pos = seq(1, 20, 1)
    )
    test_value <- positivity_rolling_mean(test_data)
    expected_names <- c(
      "region",
      "visit_date",
      "n_total",
      "n_pos",
      "n_pos_spread",
      "n_total_spread",
      "positivity_rate"
    )
    testthat::expect_true(all(names(test_value) == expected_names))
  }
)

testthat::test_that(
  desc = "function returns correct column types",
  code = {
    test_data <- data.frame(
      region = c(rep(c("England", "Wales"), 10)),
      visit_date = sort(rep(seq(20220101, 20220110, 1), 2)),
      n_total = seq(11, 30, 1),
      n_pos = seq(1, 20, 1)
    )
    test_value <- purrr::map(
      .x = positivity_rolling_mean(test_data),
      .f = class
    )
    expected_value <- c("character", rep("numeric", 6))
    testthat::expect_true(object = all(test_value == expected_value))
  }
)
