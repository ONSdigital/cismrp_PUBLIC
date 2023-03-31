countries <- list("Scotland")
dummy_country_configs_sample <- dummy_country_configs[names(dummy_country_configs) %in% countries]

country_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$country

variant_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$variant

dummy_country_configs_sample$Scotland$run_settings$variants <- c(1, 2)

synthetic_filtered_aggregates_Scotland1 <- data.frame(synthetic_filtered_aggregates$Scotland1)
synthetic_filtered_aggregates_Scotland2 <- data.frame(synthetic_filtered_aggregates$Scotland2)
test_data <- list(
  Scotland1 = synthetic_filtered_aggregates_Scotland1,
  Scotland2 = synthetic_filtered_aggregates_Scotland2
)

output_try_catch_fit_all_models <- try_catch_fit_all_models(dummy_country_configs_sample, country_list, variant_list, test_data, cores = 1)

output_try_catch_fit_all_models

model_Scotland1 <- output_try_catch_fit_all_models$Scotland1
model_Scotland2 <- output_try_catch_fit_all_models$Scotland2

test_that("model family is binomial", {
  expect_equal(model_Scotland1$stanfit@model_name, "binomial")

  expect_equal(model_Scotland2$stanfit@model_name, "binomial")
})

test_that("number of model residuals is equal to number of rows of input data", {
  expect_equal(
    object = length(model_Scotland1$residuals),
    expected = nrow(synthetic_filtered_aggregates$Scotland1)
  )
  expect_equal(
    object = length(model_Scotland2$residuals),
    expected = nrow(synthetic_filtered_aggregates$Scotland2)
  )
})

test_that("number of chains ran = chains requested", {
  expect_equal(model_Scotland1$stanfit@sim$chains, dummy_country_configs$Scotland$model_settings$chains)

  expect_equal(model_Scotland2$stanfit@sim$chains, dummy_country_configs$Scotland$model_settings$chains)
})

test_that("number of iterations ran = iterations requested", {
  expect_equal(model_Scotland1$stanfit@sim$iter, dummy_country_configs$Scotland$model_settings$iterations)
  expect_equal(model_Scotland2$stanfit@sim$iter, dummy_country_configs$Scotland$model_settings$iterations)
})

test_that("output stanfit is conformable to an mcmclist", {
  expect_equal(class(rstan::As.mcmc.list(model_Scotland1$stanfit)), "mcmc.list")
  expect_equal(class(rstan::As.mcmc.list(model_Scotland2$stanfit)), "mcmc.list")
})

test_that("all fitted values are returned between 0 and 1", {
  expect_true(all(model_Scotland1$fittedvalues >= 0))
  expect_true(all(model_Scotland2$fitted.values <= 1))
})
