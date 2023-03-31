p <- plot_raw_vs_modelled(
  sample_data = synthetic_aggregated_sample,
  household_data = synthetic_aggregated_HH,
  prevalence_time_series = synthetic_prevalence_time_series,
  COUNTRY = "England",
  country_configs = dummy_country_configs,
  region_or_country = "country"
)

test_that("Function exports ggplot plot", {
  testthat::expect_true(ggplot2::is.ggplot(p))
})

testthat::test_that("Title of plot is 'Model fit against raw data'", {
  testthat::expect_equal(p$labels$title, "Model fit against raw data")
})

testthat::test_that("X axis title is 'Date'", {
  testthat::expect_equal(p$labels$x, "Date")
})

testthat::test_that("Y axis title is 'Date'", {
  testthat::expect_equal(p$labels$y, "Prevalence")
})

testthat::test_that("Ribbon max and min values are upper limit (ul) and lower limit (ll)", {
  testthat::expect_equal(p$labels$ymax, "ul")
  testthat::expect_equal(p$labels$ymin, "ll")
})
