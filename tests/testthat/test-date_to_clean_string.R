testthat::test_that(
  desc = "function transforms a date object to a character",
  {
    test_date <- as.Date("2020-03-23", "%Y-%m-%d")
    test_value <- date_to_clean_string(test_date)
    testthat::expect_type(
      object = test_value,
      type = "character"
    )
  }
)

testthat::test_that(
  desc = "function returns an string of length 8",
  {
    test_date <- as.Date("2020-03-23", "%Y-%m-%d")
    test_value <- date_to_clean_string(test_date)
    testthat::expect_true(nchar(test_value) == 8)
  }
)
