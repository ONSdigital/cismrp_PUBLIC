testthat::test_that(
  desc = "function formats visit_date into Date class",
  code = {
    test_data <- data.frame(visit_date = rep("01022022", 3))
    test_value <- purrr::map(
      .x = format_visit_dates(test_data),
      .f = class
    )
    testthat::expect_true(test_value == "Date")
  }
)

testthat::test_that(
  desc = "function formats visit_date column into Date class",
  code = {
    test_data <- data.frame(visit_date = rep("01022022", 3))
    test_value <- format_visit_dates(test_data)
    testthat::expect_true(class(test_value) == "data.frame")
  }
)
