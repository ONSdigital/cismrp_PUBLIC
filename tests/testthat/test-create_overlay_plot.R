previous_prevalence_time_series <- synthetic_previous_prevalence_time_series

p <- create_overlay_plot(
  synthetic_prevalence_time_series,
  synthetic_previous_prevalence_time_series,
  "England",
  "ctall",
  "country"
)

testthat::test_that("Function exports ggplot plot", {
  testthat::expect_true(ggplot2::is.ggplot(p))
})

testthat::test_that("Title of plot is 'Percentage of people testing positive for COVID-19 in England'", {
  testthat::expect_equal(p$labels$title, "Percentage of people testing positive for COVID-19 in England")
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
