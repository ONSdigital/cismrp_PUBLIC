testthat::test_that(
  desc = "function returns a string",
  code = {
    test_data <- data.frame(
      region = rep("North East", 2),
      variant = rep("ctall", 2),
      comparison_period = c(7, 14),
      summary_current = c(
        "likely increased",
        "likely increased"
      ),
      summary_previous = c(
        "likely increased",
        "likely increased"
      )
    )

    test_value <- get_summary_statement(test_data, "North East", "ctall")

    testthat::expect_true(class(test_value) == "character")
  }
)

testthat::test_that(
  desc = "function returns the correct summary statement",
  code = {
    test_data <- data.frame(
      region = rep("North East", 2),
      variant = rep("ctall", 2),
      comparison_period = c(7, 14),
      summary_current = c(
        "likely increased",
        "likely increased"
      ),
      summary_previous = c(
        "likely increased",
        "likely increased"
      )
    )
    # certain outcome
    test_value <- get_summary_statement(test_data, "North East", "ctall")
    expected_value <- "The percentage of people testing positive in North East has likely increased in the most recent week."
    testthat::expect_true(test_value == expected_value)

    # constant at reference points
    test_data <- test_data %>%
      dplyr::mutate(summary_current = "likely constant at reference points")
    test_value <- get_summary_statement(test_data, "North East", "ctall")
    expected_value <- "The percentage of people testing positive in North East is likely similar to that in the previous week."
    testthat::expect_true(test_value == expected_value)
    # uncertain
    test_data <- test_data %>%
      dplyr::mutate(
        summary_current = "trend uncertain",
        summary_previous = "trend uncertain"
      )
    test_value <- get_summary_statement(test_data, "North East", "ctall")
    expected_value <- "The trend is uncertain in North East."
    testthat::expect_true(test_value == expected_value)
    # uncertain one week, certain over 2
    test_data <- test_data %>%
      dplyr::mutate(
        summary_current = "trend uncertain",
        summary_previous = "likely increased"
      )
    test_value <- get_summary_statement(test_data, "North East", "ctall")
    expected_value <- "The trend is uncertain in North Eastin the most recent week. However rates likely increased over two weeks."
    testthat::expect_true(test_value == expected_value)
  }
)
