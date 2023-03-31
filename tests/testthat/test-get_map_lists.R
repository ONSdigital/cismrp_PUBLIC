countries <- list("Northern Ireland", "Wales", "Scotland", "England")

dummy_country_list <- cismrp::get_map_lists(countries, dummy_country_configs)$country
dummy_variant_list <- cismrp::get_map_lists(countries, dummy_country_configs)$variant

test_that("function returns a character", {
  expect_type(
    dummy_country_list,
    "character"
  )
  expect_type(
    dummy_variant_list,
    "double"
  )
})

test_that("function returns each country/variant repeated 4 times", {
  expect_equal(
    dummy_country_list,
    c(
      "Northern Ireland",
      "Northern Ireland",
      "Northern Ireland",
      "Northern Ireland",
      "Wales",
      "Wales",
      "Wales",
      "Wales",
      "Scotland",
      "Scotland",
      "Scotland",
      "Scotland",
      "England",
      "England",
      "England",
      "England"
    )
  )

  expect_equal(
    dummy_variant_list,
    c(1, 2, 4, 5, 1, 2, 4, 5, 1, 2, 4, 5, 1, 2, 4, 5)
  )
})
