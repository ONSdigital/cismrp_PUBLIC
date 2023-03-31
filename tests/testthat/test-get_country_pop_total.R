test_data <- get_country_pop_total(synthetic_filtered_pop_tables, "England")

testthat::test_that(
  desc = "function returns a numeric",
  code = {
    testthat::expect_true(class(test_data) == "numeric")
  }
)
