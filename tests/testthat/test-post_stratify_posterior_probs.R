countries <- list("Scotland")
dummy_country_configs_sample <- dummy_country_configs[names(dummy_country_configs) %in% countries]

dummy_country_configs_sample$Scotland$run_settings$variants <- c(1, 2)

country_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$country

variant_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$variant
filtered_pop_tables <- cismrp::filter_pop_table(
  synthetic_cleaned_population_counts,
  dummy_config,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

test_pop_tables <- list(
  Scotland1 = filtered_pop_tables$Scotland1,
  Scotland2 = filtered_pop_tables$Scotland2
)

synthetic_filtered_aggregates_Scotland1 <- data.frame(synthetic_filtered_aggregates$Scotland1)
synthetic_filtered_aggregates_Scotland2 <- data.frame(synthetic_filtered_aggregates$Scotland2)
test_data <- list(
  Scotland1 = synthetic_filtered_aggregates_Scotland1,
  Scotland2 = synthetic_filtered_aggregates_Scotland2
)

output_try_catch_fit_all_models <- try_catch_fit_all_models(dummy_country_configs_sample, country_list, variant_list, test_data, cores = 1)

test_models <- list(
  Scotland1 = output_try_catch_fit_all_models$Scotland1,
  Scotland2 = output_try_catch_fit_all_models$Scotland2
)


posterior_probabilities <- cismrp::get_posterior_probabilities(
  test_models,
  test_pop_tables,
  test_data,
  variant_list = variant_list,
  country_list = country_list
)

output_post_stratify_posterior_probs <- post_stratify_posterior_probs(test_pop_tables, posterior_probabilities, country_list, variant_list)

testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(output_post_stratify_posterior_probs) == "list")
  }
)
testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(output_post_stratify_posterior_probs$Scotland1) == "list")
  }
)
testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(output_post_stratify_posterior_probs$Scotland2) == "list")
  }
)


testthat::test_that(
  desc = "function returns a matrix",
  code = {
    expect_true(is.matrix(output_post_stratify_posterior_probs$Scotland1$All))
  }
)

testthat::test_that(
  desc = "function returns a matrix",
  code = {
    expect_true(is.matrix(output_post_stratify_posterior_probs$Scotland2$All))
  }
)

test_that("function returns matrix content in format of double ", {
  expect_type(output_post_stratify_posterior_probs$Scotland1$All, "double")
})

test_that("function returns matrix content in format of double ", {
  expect_type(output_post_stratify_posterior_probs$Scotland2$All, "double")
})
