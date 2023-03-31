set.seed(1)

output_England <- suppressWarnings(fit_model(
  synthetic_filtered_aggregates$England1,
  dummy_country_configs$England
))

output_Scotland <- suppressWarnings(fit_model(
  synthetic_filtered_aggregates$Scotland1,
  dummy_country_configs$Scotland
))

test_that("number of model residuals is equal to number of rows of input data", {
  expect_equal(
    object = length(output_England$residuals),
    expected = nrow(synthetic_filtered_aggregates$England1)
  )
  expect_equal(
    object = length(output_Scotland$residuals),
    expected = nrow(synthetic_filtered_aggregates$Scotland1)
  )
})

test_that("model family is binomial", {
  expect_equal(output_England$stanfit@model_name, "binomial")

  expect_equal(output_Scotland$stanfit@model_name, "binomial")
})

test_that("number of chains ran = chains requested", {
  expect_equal(output_England$stanfit@sim$chains, dummy_country_configs$England$model_settings$chains)

  expect_equal(output_Scotland$stanfit@sim$chains, dummy_country_configs$Scotland$model_settings$chains)
})

test_that("number of iterations ran = iterations requested", {
  expect_equal(output_England$stanfit@sim$iter, dummy_country_configs$England$model_settings$iterations)
  expect_equal(output_Scotland$stanfit@sim$iter, dummy_country_configs$Scotland$model_settings$iterations)
})

test_that("output stanfit is conformable to an mcmclist", {
  expect_equal(class(rstan::As.mcmc.list(output_England$stanfit)), "mcmc.list")
  expect_equal(class(rstan::As.mcmc.list(output_Scotland$stanfit)), "mcmc.list")
})

test_that("all fitted values are returned between 0 and 1", {
  expect_true(all(output_England$fittedvalues >= 0))
  expect_true(all(output_Scotland$fitted.values <= 1))
})
