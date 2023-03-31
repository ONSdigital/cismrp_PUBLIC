dummy_data <- structure(
  list(
    region = rep(c("Scotland", "Wales", "Northern Ireland", "South West"), 3),
    n_pos = rep(c(0, 1, 2, 3), 3)
  ),
  row.names = c(NA, -12L), class = "data.frame"
)

# Test function returns dataframe
testthat::test_that("function returns a dataframe", {
  expect_true(is.data.frame(filter_by_country(dummy_data, "Scotland")))
})


# Test function filters selected country correctly
testthat::test_that(
  "correct country is returned",
  {
    output <- filter_by_country(dummy_data, "Scotland")
    expect_true(unique(output$region == "Scotland"))
  }
)

testthat::test_that(
  "correct country is returned",
  {
    output <- filter_by_country(dummy_data, "Northern Ireland")
    expect_true(unique(output$region == "Northern Ireland"))
  }
)

testthat::test_that(
  "correct country is returned",
  {
    output <- filter_by_country(dummy_data, "Wales")
    expect_true(unique(output$region == "Wales"))
  }
)
