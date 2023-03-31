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

filtered_pop_tables <- cismrp::filter_pop_table(
  synthetic_cleaned_population_counts,
  dummy_config,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

model_Scotland1 <- output_try_catch_fit_all_models$Scotland1


output <- extract_posterior_probabilities(model_Scotland1, filtered_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)


testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(output) == "list")
  }
)

class(output)
testthat::test_that(
  desc = "function returns a matrix",
  code = {
    expect_true(is.matrix(output$All))
  }
)


test_that("function returns matrix content in format of double ", {
  expect_type(output$All, "double")
})


testthat::test_that("", {
  expect_named(colnames(output$All), rownames(filtered_pop_tables$Scotland))
})

failing_model_structure <- as.list(model_Scotland1$All)

testthat::test_that("function throws an error as model is not a stanreg object", {
  testthat::expect_error(
    cismrp::extract_posterior_probabilities(failing_model_structure, filtered_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)
  )
})

failing_test_pop_tables <- as.list(filtered_pop_tables$Scotland1)

testthat::test_that("function throws an error as poststrat table is not a data.frame", {
  testthat::expect_error(
    cismrp::extract_posterior_probabilities(model_Scotland1, failing_test_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)
  )
})

no_study_day_test_pop_tables <- dplyr::select(filtered_pop_tables$Scotland1, -"study_day")


testthat::test_that("function throws an error as postrat table missing study day", {
  testthat::expect_error(
    cismrp::extract_posterior_probabilities(model_Scotland1, no_study_day_test_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)
  )
})

no_region_test_pop_tables <- dplyr::select(filtered_pop_tables$Scotland1, -"region")

testthat::test_that("function throws an error as postrat table missing region", {
  testthat::expect_error(
    cismrp::extract_posterior_probabilities(model_Scotland1, no_region_test_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)
  )
})

no_age_group_test_pop_tables <- dplyr::select(filtered_pop_tables$Scotland1, -"age_group")

testthat::test_that("function throws an error as postrat table missing age group", {
  testthat::expect_error(
    cismrp::extract_posterior_probabilities(model_Scotland1, no_age_group_test_pop_tables$Scotland1, synthetic_filtered_aggregates$Scotland1)
  )
})
