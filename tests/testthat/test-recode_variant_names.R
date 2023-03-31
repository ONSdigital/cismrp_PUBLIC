testthat::test_that("Dataframe is returned", {
  test_data <- data.frame("variant" = c("1", "2", "4", "5"))
  output <- recode_variant_names(test_data)
  testthat::expect_s3_class(output, "data.frame")
})

testthat::test_that("function returns the correct variant names", {
  test_data <- data.frame("variant" = c("1", "2", "4", "5"))
  output <- recode_variant_names(test_data)
  testthat::expect_equal(output$variant, c("ctall", "ct4", "ct7", "ctnot4not7"))
})
