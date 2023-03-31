testthat::test_that(
  desc = "function returns a string",
  code = {
    testthat::skip_on_ci()
    main_config <- list(
      run_settings = list(
        prev_data_run = "20221205"
      )
    )
    test_value <- find_previous_time_series_path(main_config)
    testthat::expect_type(
      object = test_value,
      type = "character"
    )
  }
)
