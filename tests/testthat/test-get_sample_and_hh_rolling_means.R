dummy_output <- get_sample_and_hh_rolling_means(
  sample_data = synthetic_aggregated_sample,
  household_data = synthetic_aggregated_HH,
  country_filter = "England",
  country_configs = dummy_country_configs,
  region_or_country = "country"
)

test_that("function returns correct length of columns", {
  expect_equal(ncol(dummy_output$household_data), 7)
  expect_equal(ncol(dummy_output$sample_data), 7)
})

test_that("function returns expected column names", {
  expect_named(
    dummy_output$household_data,
    c(
      "region",
      "visit_date",
      "n_total",
      "n_pos",
      "n_pos_spread",
      "n_total_spread",
      "positivity_rate"
    )
  )
  expect_named(
    dummy_output$sample_data,
    c(
      "region",
      "visit_date",
      "n_total",
      "n_pos",
      "n_pos_spread",
      "n_total_spread",
      "positivity_rate"
    )
  )
})

test_that("function returns a data.frame", {
  expect_true(is.data.frame(dummy_output$household_data))
  expect_true(is.data.frame(dummy_output$sample_data))
})


test_that("function return data for only England", {
  expect_equal(
    unique(dummy_output$household_data$region),
    "England"
  )
  expect_equal(
    unique(dummy_output$sample_data$region),
    "England"
  )
})
