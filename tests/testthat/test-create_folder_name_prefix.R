testthat::test_that(
  desc = "function returns a string",
  code = {
    test_data <- cismrp::dummy_config
    test_value <- get_folder_name_prefix(test_data)
    testthat::expect_true(class(test_value) == "character")
  }
)

testthat::test_that(
  desc = "function returns a specific string if test_configs_short == true",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- TRUE
    test_data$run_settings$test <- FALSE
    test_value <- get_folder_name_prefix(test_data)
    testthat::expect_true(test_value == "test_configs_short_")
  }
)

testthat::test_that(
  desc = "function returns a specific string if test == true",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- FALSE
    test_data$run_settings$test <- TRUE
    test_value <- get_folder_name_prefix(test_data)
    testthat::expect_true(test_value == "test_")
  }
)

testthat::test_that(
  desc = "function returns a '_' if test and test_configs_short == false",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- FALSE
    test_data$run_settings$test <- FALSE
    test_value <- get_folder_name_prefix(test_data)
    testthat::expect_true(test_value == "_")
  }
)
