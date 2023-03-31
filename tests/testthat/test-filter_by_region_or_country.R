testthat::test_that(
  desc = "function filters by region or country correctly",
  code = {
    test_data <- data.frame(region = c(
      gcptools::england_regions,
      gcptools::uk_countries
    ))

    # test for selecting regions
    test_value <- filter_by_region_or_country(
      test_data, "England", "region"
    ) %>%
      dplyr::pull(region)

    expected_value <- gcptools::england_regions

    testthat::expect_true(all(test_value == expected_value))

    # test for selecting specific country
    test_value <- filter_by_region_or_country(
      test_data, "England", "country"
    ) %>%
      dplyr::pull(region)

    expected_value <- "England"

    testthat::expect_true(all(test_value == expected_value))
  }
)

testthat::test_that(
  desc = "function returns a dataframe",
  code = {
    test_data <- data.frame(region = c(
      gcptools::england_regions,
      gcptools::uk_countries
    ))

    test_value <- filter_by_region_or_country(
      test_data, "England", "region"
    )

    testthat::expect_true(class(test_value) == "data.frame")
  }
)
