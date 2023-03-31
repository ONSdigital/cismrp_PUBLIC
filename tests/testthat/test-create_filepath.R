testthat::test_that(
  desc = "function returns a string",
  code = {
    test_data <- list(
      file_id = "test",
      end_date = "20220201",
      file_type = "csv"
    )
    test_value <- create_filepath(
      file_id = test_data$file_id,
      end_date = test_data$end_date,
      file_type = test_data$file_type,
      cismrp::dummy_config
    )
    testthat::expect_true(class(test_value) == "character")
  }
)

testthat::test_that(
  desc = "function returns the expected filepath",
  code = {
    test_data <- list(
      file_id = "test",
      end_date = "20220201",
      file_type = "csv"
    )

    test_config <- cismrp::dummy_config
    test_config$run_settings$test_configs_short <- TRUE

    test_value <- create_filepath(
      file_id = test_data$file_id,
      end_date = test_data$end_date,
      file_type = test_data$file_type,
      test_config
    )
    expected_pattern <- paste0(
      "20221205_mrp/",
      "test_mrp_20220201_DTS[0-9]{6}_[0-9]{4}UTC\\.csv"
    )

    testthat::expect_true(grepl(
      x = test_value,
      pattern = expected_pattern
    ))
  }
)
