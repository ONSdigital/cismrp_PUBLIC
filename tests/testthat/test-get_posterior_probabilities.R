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


posterior_probabilities <- cismrp::get_posterior_probabilities(
  test_models,
  test_pop_tables,
  test_data,
  variant_list = variant_list,
  country_list = country_list
)

testthat::test_that("Scotland1 contains the posterior probabilities", {
  expect_named(colnames(posterior_probabilities$Scotland1$All), rownames(filtered_pop_tables$Scotland))
})

testthat::test_that("Scotland2 contains the posterior probabilities", {
  expect_named(colnames(posterior_probabilities$Scotland2$All), rownames(filtered_pop_tables$Scotland))
})

testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(posterior_probabilities) == "list")
  }
)
testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(posterior_probabilities$Scotland1) == "list")
  }
)
testthat::test_that(
  desc = "function returns a list",
  code = {
    testthat::expect_true(class(posterior_probabilities$Scotland2) == "list")
  }
)


testthat::test_that(
  desc = "function returns a matrix",
  code = {
    expect_true(is.matrix(posterior_probabilities$Scotland1$All))
  }
)

testthat::test_that(
  desc = "function returns a matrix",
  code = {
    expect_true(is.matrix(posterior_probabilities$Scotland2$All))
  }
)

test_that("function returns matrix content in format of double ", {
  expect_type(posterior_probabilities$Scotland1$All, "double")
})

test_that("function returns matrix content in format of double ", {
  expect_type(posterior_probabilities$Scotland2$All, "double")
})

failing_model_structure <- as.list(test_models$Scotland1)

testthat::test_that("function throws an error as model is not a stanreg object", {
  testthat::expect_error(
    cismrp::get_posterior_probabilities(
      failing_model_structure,
      test_pop_tables,
      test_data,
      variant_list = variant_list,
      country_list = country_list
    )
  )
})

testthat::test_that("function throws an error as poststrat table is not a data.frame", {
  failing_test_pop_tables <- list(as.list(test_pop_tables$Scotland1))

  testthat::expect_error(
    cismrp::get_posterior_probabilities(
      test_models,
      failing_test_pop_tables,
      test_data,
      variant_list = variant_list,
      country_list = country_list
    ),
    "post_strat_table must be a data.frame"
  )
})

testthat::test_that("function throws an error as postrat table missing study day", {
  no_study_day_test_pop_tables <- list(dplyr::select(test_pop_tables$Scotland1, -"study_day"))

  testthat::expect_error(
    cismrp::get_posterior_probabilities(
      test_models,
      no_study_day_test_pop_tables,
      test_data,
      variant_list = variant_list,
      country_list = country_list
    ),
    "post_strat_table must have a study_day column"
  )
})

testthat::test_that("function throws an error as postrat table missing region", {
  no_region_test_pop_tables <- list(dplyr::select(test_pop_tables$Scotland1, -"region"))

  testthat::expect_error(
    cismrp::get_posterior_probabilities(
      test_models,
      no_region_test_pop_tables,
      test_data,
      variant_list = variant_list,
      country_list = country_list
    ),
    "post_strat_table must have a region column"
  )
})

testthat::test_that("function throws an error as postrat table missing age group", {
  no_age_group_test_pop_tables <- list(dplyr::select(test_pop_tables$Scotland1, -"age_group"))

  testthat::expect_error(
    cismrp::get_posterior_probabilities(
      test_models,
      no_age_group_test_pop_tables,
      test_data,
      variant_list = variant_list,
      country_list = country_list
    ),
    "post_strat_table must have an age_group column"
  )
})
