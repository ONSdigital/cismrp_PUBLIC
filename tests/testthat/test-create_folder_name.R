testthat::test_that(
  desc = "function returns a string",
  code = {
    test_data <- cismrp::dummy_config
    test_value <- create_folder_name(test_data)
    testthat::expect_true(class(test_value) == "character")
  }
)

# base_condition
testthat::test_that(
  desc = "function returns a basic folder name without special prefix or suffix",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- FALSE
    test_value <- create_folder_name(test_data)

    testthat::expect_true(test_value == "20221205_mrp/")
  }
)

# prefix condition
testthat::test_that(
  desc = "function returns a folder name with a prefix e.g <prefix>_yyyymmdd_mrp",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- TRUE
    test_value <- create_folder_name(test_data)
    testthat::expect_true(test_value == "test_configs_short_20221205_mrp/")
  }
)
# suffix condition
testthat::test_that(
  desc = "function returns a folder name with a suffix e.g yyyymmdd_mrp_<suffix>",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- FALSE
    test_data$run_settings$rerun <- TRUE
    test_value <- create_folder_name(test_data)
    testthat::expect_true(test_value == "20221205_mrp_rerun/")
  }
)
