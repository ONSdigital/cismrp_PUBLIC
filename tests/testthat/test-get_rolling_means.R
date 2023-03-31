dummy_output <- get_rolling_means(
  data = synthetic_aggregated_HH,
  country_filter = "England",
  region_or_country = "country",
  country_configs = dummy_country_configs
)

test_that("function returns correct length of columns", {
  expect_equal(ncol(dummy_output), 7)
})

test_that("function returns expected column names", {
  expect_named(
    dummy_output,
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
  expect_true(is.data.frame(dummy_output))
})


test_that("function return data for only England", {
  expect_equal(
    unique(dummy_output$region),
    "England"
  )
})
