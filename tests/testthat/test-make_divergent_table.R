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
test_models <- list(
  Scotland1 = output_try_catch_fit_all_models$Scotland1,
  Scotland2 = output_try_catch_fit_all_models$Scotland2
)


dummy_config$variant_labels$ct7 <- NULL
dummy_config$variant_labels$ctnot4not7 <- NULL

output <- make_divergent_table(dummy_country_configs_sample, "Scotland", test_models, dummy_config)

testthat::test_that(
  desc = "function returns a kableExtra",
  code = {
    testthat::expect_true("kableExtra" %in% class(output))
  }
)
