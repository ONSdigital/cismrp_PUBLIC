testthat::test_that(
  desc = "function returns a list",
  code = {
    test_value <- get_bucket_list(cismrp::dummy_config)
    testthat::expect_true(class(test_value) == "list")
  }
)

testthat::test_that(
  desc = "function returns a list length 1 if either test options == TRUE",
  code = {
    test_data <- cismrp::dummy_config
    test_data$run_settings$test_configs_short <- TRUE
    test_value <- get_bucket_list(test_data)
    testthat::expect_true(length(test_value) == 1)
  }
)

testthat::test_that(
  desc = "function returns a list length 2 if both test options == FALSE",
  code = {
    test_value <- get_bucket_list(cismrp::dummy_config)
    testthat::expect_true(length(test_value) == 2)
  }
)
