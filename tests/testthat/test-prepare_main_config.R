# Test function returns list
testthat::test_that("Function outputs list", {
  skip_on_ci()
  yaml::write_yaml(cismrp::dummy_config, "dummy_config.yaml")
  output <- prepare_main_config("dummy_config.yaml")
  testthat::expect_type(output, "list")
})
