testthat::test_that(
  desc = "Function returns a list object",
  code = {
    test_data <- synthetic_aggregated_HH %>%
      transform_gor_name_to_full_name() %>%
      dplyr::mutate(time = as.character(lubridate::dmy(visit_date))) %>%
      aggregate_england_from_regions_and_date()
    testthat::expect_s3_class(test_data, "data.frame")
  }
)

testthat::test_that(
  desc = "Function returns the correct dimensions",
  code = {
    test_data <- synthetic_aggregated_HH %>%
      transform_gor_name_to_full_name() %>%
      dplyr::mutate(time = as.character(lubridate::dmy(visit_date))) %>%
      aggregate_england_from_regions_and_date()
    testthat::expect_true(all(dim(test_data) == c(2050, 14)))
  }
)

testthat::test_that(
  desc = "listed dataframes contain the correct colnames",
  code = {
    test_data <- synthetic_aggregated_HH %>%
      transform_gor_name_to_full_name() %>%
      dplyr::mutate(time = as.character(lubridate::dmy(visit_date))) %>%
      aggregate_england_from_regions_and_date()
    expected_names <- c(
      "time",
      "region",
      "n_hh_for_ab_pos",
      "n_hh_for_pos",
      "n_hh_ever_ab",
      "n_hh_ever_ab_pos",
      "n_hh_with_first_hh_pos",
      "n_hh_with_pos",
      "max_pos_hh",
      "visit_date",
      "gor_name",
      "lab_id",
      "data_run_date",
      "country"
    )
    testthat::expect_true(
      all(colnames(test_data) %in% expected_names)
    )
  }
)

testthat::test_that(
  desc = "Function returns the correct column types",
  code = {
    test_data <- synthetic_aggregated_HH %>%
      transform_gor_name_to_full_name() %>%
      dplyr::mutate(time = as.character(lubridate::dmy(visit_date))) %>%
      aggregate_england_from_regions_and_date()
    test_classes <- purrr::map(test_data, class)
    expected_types <- c(
      rep("character", 2),
      rep("numeric", 7),
      rep("character", 5)
    )
    testthat::expect_true(all(colnames(test_classes) %in% expected_types))
  }
)
