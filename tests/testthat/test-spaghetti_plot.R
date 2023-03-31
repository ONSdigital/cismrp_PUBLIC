p <- spaghetti_plot(
  synthetic_prevalence_time_series,
  dummy_post_stratified_draws,
  "England",
  "ctall",
  "country",
  format_config_end_dates(dummy_config)
)

testthat::test_that("Function exports ggplot plot", {
  testthat::expect_true(ggplot2::is.ggplot(p))
})

testthat::test_that("Title of plot is 'Spaghetti plot of posterior draws in England'", {
  testthat::expect_equal(p$labels$title, "Spaghetti plot of posterior draws in England")
})

testthat::test_that("X axis title is 'Date'", {
  testthat::expect_equal(p$labels$x, "Date")
})

testthat::test_that("Y axis title is 'Date'", {
  testthat::expect_equal(p$labels$y, "Prevalence")
})

testthat::test_that("Ribbon max and min values are upper limit/100 (ul/100) and lower limit (ll/100)", {
  testthat::expect_equal(p$labels$ymax, "ul/100")
  testthat::expect_equal(p$labels$ymin, "ll/100")
})
