# test_that("age groups are returned in the correct order", {
#   testthat::skip("Need to fix")
#   dummy_data <- data.frame(ageg_7_categories = c(
#     "2_11",
#     "12_16",
#     "17_24",
#     "25_34",
#     "35_49",
#     "50_69",
#     "70+",
#     "other"
#   ))
#   output <- recode_age_groups(dummy_data)

#   test_that("age groups are recoded correctly and incorrect age groups are returned as missing", {
#     expect_true(all(dummy_data$age_group == c(
#       "2-11",
#       "12-16",
#       "17-24",
#       "25-34",
#       "35-49",
#       "50-69",
#       "70+",
#       NA
#     )))
#   })
#   expect_true(all(levels(output$age_group) == c("2-11", "12-16", "17-24", "25-34", "35-49", "50-69", "70+")))
#  })
