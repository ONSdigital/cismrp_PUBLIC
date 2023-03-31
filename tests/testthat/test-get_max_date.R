testthat::test_that(
  desc = "function returns a string",
  code = {
    test_data <- "end_date"
    test_value <- get_max_date(cismrp::dummy_config, test_data)
    testthat::expect_true(class(test_value) == "character")
  }
)

testthat::test_that(
  desc = "function returns a string length 8",
  code = {
    test_data <- "end_date"
    test_value <- get_max_date(cismrp::dummy_config, test_data)
    testthat::expect_true(nchar(test_value) == 8)
  }
)

testthat::test_that(
  desc = "function returns the most recent date",
  code = {
    test_data <- "end_date"
    test_value <- get_max_date(cismrp::dummy_config, test_data)
    testthat::expect_true(test_value == "20221126")
  }
)
