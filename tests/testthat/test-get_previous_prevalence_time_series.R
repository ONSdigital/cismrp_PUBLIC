testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    testthat::skip_on_ci()
    main_config <- list(
      run_settings = list(
        prev_data_run = "20221205"
      )
    )
    test_value <- get_previous_prevalence_time_series(
      main_config
    )
    testthat::expect_true(class(test_value) == "data.frame")
  }
)
