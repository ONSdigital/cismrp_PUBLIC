passable_dummy_data <- structure(
  list(
    visit_date = rep(c("26apr2020"), 12),
    sex = c(
      "Male", "Female", "Male", "Female", "Male",
      "Female", "Male", "Female", "Male",
      "Female", "Male", "Female"
    ),
    ageg_7 = c(
      "2-11", "12-16", "17-24", "25-34",
      "35-49", "50-69", "70+", "2-11",
      "17-24", "25-34", "35-49", "50-69"
    ),
    gor9d = c(
      "E12000001", "E12000002", "E12000003", "E12000004",
      "E12000005", "E12000006", "E12000007", "E12000008",
      "E12000009", "N99999999", "W99999999", "S99999999"
    ),
    gor_name = c(
      "1_NE", "2_NW", "3_YH", "4_EM",
      "5_WM", "6_EE", "7_LD", "8_SE",
      "9_SW", "10_NI", "12_WAL", "11_SCO"
    ),
    ethnicityg = c(
      "White", "Mixed", "Asian", "Other", "Black", "White",
      "Mixed", "Asian", "Other", "Black", "White", "Mixed"
    ),
    lab_id = c(
      "MK", "GLS", "z-exception", "LML", "BB", "MK",
      "GLS", "z-exception", "LML", "BB", "MK", "GLS"
    ),
    data_run_date = rep(c("05dec2022"), 12),
    n_pos = rep(c(0, 1, 2, 3), 3),
    n_neg = rep(c(0, 1, 2, 3), 3),
    n_void = rep(c(0, 1, 2, 3), 3),
    ab_pos = rep(c(0, 1, 2, 3), 3),
    ab_pos42 = rep(c(0, 1, 2, 3), 3),
    ab_pos179 = rep(c(0, 1, 2, 3), 3),
    ab_pos800 = rep(c(0, 1, 2, 3), 3),
    ab_neg = rep(c(0, 1, 2, 3), 3),
    ab_neg42 = rep(c(0, 1, 2, 3), 3),
    ab_neg179 = rep(c(0, 1, 2, 3), 3),
    ab_neg800 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern1 = rep(c(0), 12),
    n_ctpattern2 = rep(c(0), 12),
    n_ctpattern4 = rep(c(0), 12),
    n_ctpattern5 = rep(c(0), 12),
    n_ctpattern6 = rep(c(0), 12),
    n_ctpattern7 = rep(c(0), 12),
    ct_mean = rep(c(29.952606, 35.316589, 27.758017, 32.070358), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
)


passable_cleaned_dummy_data <- clean_aggregated(passable_dummy_data)

output <- validate_aggregated_sample_variant_positives(passable_cleaned_dummy_data)

# Test validate_aggregated_sample returns invisible on data when the number of positive tests is greater than some of postive variant tests
testthat::test_that("validate_aggregated_sample returns invisible on data when the number of positive tests it not fewer than some of postive variant tests", {
  expect_invisible(validate_aggregated_sample_variant_positives(passable_cleaned_dummy_data))
})


failing_dummy_data <- structure(
  list(
    visit_date = rep(c("26apr2020"), 12),
    sex = c(
      "Male", "Female", "Male", "Female", "Male",
      "Female", "Male", "Female", "Male",
      "Female", "Male", "Female"
    ),
    ageg_7 = c(
      "2-11", "12-16", "17-24", "25-34",
      "35-49", "50-69", "70+", "2-11",
      "17-24", "25-34", "35-49", "50-69"
    ),
    gor9d = c(
      "E12000001", "E12000002", "E12000003", "E12000004",
      "E12000005", "E12000006", "E12000007", "E12000008",
      "E12000009", "N99999999", "W99999999", "S99999999"
    ),
    gor_name = c(
      "1_NE", "2_NW", "3_YH", "4_EM",
      "5_WM", "6_EE", "7_LD", "8_SE",
      "9_SW", "10_NI", "12_WAL", "11_SCO"
    ),
    ethnicityg = c(
      "White", "Mixed", "Asian", "Other", "Black", "White",
      "Mixed", "Asian", "Other", "Black", "White", "Mixed"
    ),
    lab_id = c(
      "MK", "GLS", "z-exception", "LML", "BB", "MK",
      "GLS", "z-exception", "LML", "BB", "MK", "GLS"
    ),
    data_run_date = rep(c("05dec2022"), 12),
    n_pos = rep(c(0, 1, 2, 3), 3),
    n_neg = rep(c(0, 1, 2, 3), 3),
    n_void = rep(c(0, 1, 2, 3), 3),
    ab_pos = rep(c(0, 1, 2, 3), 3),
    ab_pos42 = rep(c(0, 1, 2, 3), 3),
    ab_pos179 = rep(c(0, 1, 2, 3), 3),
    ab_pos800 = rep(c(0, 1, 2, 3), 3),
    ab_neg = rep(c(0, 1, 2, 3), 3),
    ab_neg42 = rep(c(0, 1, 2, 3), 3),
    ab_neg179 = rep(c(0, 1, 2, 3), 3),
    ab_neg800 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern1 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern2 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern4 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern5 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern6 = rep(c(0, 1, 2, 3), 3),
    n_ctpattern7 = rep(c(0, 1, 2, 3), 3),
    ct_mean = rep(c(29.952606, 35.316589, 27.758017, 32.070358), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
)

failing_cleaned_dummy_data <- clean_aggregated(failing_dummy_data)


# test validate_aggregated_sample returns error and stops when the number of positive tests is fewer than some of postive variant tests
testthat::test_that("validate_aggregated_sample returns invisible on data when the number of positive tests it not fewer than some of postive variant tests", {
  expect_error(validate_aggregated_sample_variant_positives(failing_cleaned_dummy_data))
})
