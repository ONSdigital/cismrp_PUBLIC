testthat::test_that(
  desc = "function returns a string",
  code = {
    test_data <- list(
      file_id = "test",
      end_date = "20220201",
      file_type = "csv"
    )
    test_value <- create_file_name(
      file_id = test_data$file_id,
      end_date = test_data$end_date,
      file_type = test_data$file_type
    )
    testthat::expect_true(class(test_value) == "character")
  }
)

testthat::test_that(
  desc = "function returns the expected file name",
  code = {
    test_data <- list(
      file_id = "test",
      end_date = "20220201",
      file_type = "csv"
    )
    test_value <- create_file_name(
      file_id = test_data$file_id,
      end_date = test_data$end_date,
      file_type = test_data$file_type
    )
    testthat::expect_true(
      grepl(
        x = test_value,
        pattern = "test_mrp_20220201_DTS[0-9]{6}_[0-9]{4}UTC\\.csv"
      )
    )
  }
)
