p <- create_variant_overlay(
  synthetic_prevalence_time_series,
  "England",
  dummy_config,
  "country"
)

testthat::test_that("Function exports ggplot plot", {
  testthat::expect_true(ggplot2::is.ggplot(p))
})

testthat::test_that("Title of plot is 'Prevalence by variant in England'", {
  suppressWarnings(testthat::expect_equal(p$labels$title, "Prevalence by variant in England"))
})

testthat::test_that("X axis title is 'Date'", {
  suppressWarnings(testthat::expect_equal(p$labels$x, "Date"))
})

testthat::test_that("Y axis title is 'Date'", {
  suppressWarnings(testthat::expect_equal(p$labels$y, "Prevalence"))
})

testthat::test_that("Ribbon max and min values are upper limit/100 (ul/100) and lower limit/100 (ll/100)", {
  suppressWarnings(testthat::expect_equal(p$labels$ymax, "ul/100"))
  suppressWarnings(testthat::expect_equal(p$labels$ymin, "ll/100"))
})
