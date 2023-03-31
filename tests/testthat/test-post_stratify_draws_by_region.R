countries <- list("Scotland")
dummy_country_configs_sample <- dummy_country_configs[names(dummy_country_configs) %in% countries]

dummy_country_configs_sample$Scotland$run_settings$variants <- c(1, 2)

country_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$country

variant_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$variant

synthetic_filtered_aggregates_Scotland1 <- data.frame(synthetic_filtered_aggregates$Scotland1)
synthetic_filtered_aggregates_Scotland2 <- data.frame(synthetic_filtered_aggregates$Scotland2)
test_data <- list(
  Scotland1 = synthetic_filtered_aggregates_Scotland1,
  Scotland2 = synthetic_filtered_aggregates_Scotland2
)

output_try_catch_fit_all_models <- try_catch_fit_all_models(dummy_country_configs_sample, country_list, variant_list, test_data, cores = 1)

filtered_pop_tables <- cismrp::filter_pop_table(
  synthetic_cleaned_population_counts,
  dummy_config,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

output_try_catch_fit_all_models <- try_catch_fit_all_models(dummy_country_configs_sample, country_list, variant_list, test_data, cores = 1)

extracted_posterior_probabilities <- extract_posterior_probabilities(output_try_catch_fit_all_models$Scotland1, filtered_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)

output_post_stratify_draws_by_region <- post_stratify_draws_by_region(extracted_posterior_probabilities, filtered_pop_tables$Scotland1)

testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(output_post_stratify_draws_by_region) == "list")
  }
)

# For this case - region should = All so expect named all
testthat::test_that("Named all as Scotland has no regional breakdown", {
  expect_named(output_post_stratify_draws_by_region, "All")
})
