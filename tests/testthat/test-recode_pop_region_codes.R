dummy_data <- structure(list(gor_code = c(
  "E12000001", "E12000002", "E12000003", "E12000004",
  "E12000005", "E12000006", "E12000007", "E12000008",
  "E12000009", "E12000001", "E12000001", "E12000001", "W99999999", "S99999999", "N99999999"
), sex = c(
  "Male",
  "Female", "Male", "Female", "Male", "Female", "Male", "Female", "Male",
  "Female", "Male", "Female", "Male", "Female", "Male"
), ageg_7_categories = c(
  "2_11",
  "12_16", "17_24", "25_34", "35_49", "50_69",
  "70+", "2_11", "17_24", "25_34", "35_49",
  "50_69", "2_11", "12_16", "17_24"
), region = c(
  "North_East_England_0", "North_West_England_0", "North_West_England_1", "North_West_England_2", "Yorkshire_0", "Yorkshire_1",
  "East_Midlands_0", "West_Midlands_0", "East_England_0", "London_0", "South_East_England_0", "South_West_England_0", "Northern_Ireland_0", "Scotland_0", "Wales_0"
), N = c(
  156095,
  76293, 127286, 171797, 226730, 336546, 147522, 72755, 119118, 127286, 226730, 127286, 226730, 226730, 169887
)), row.names = c(NA, -15L), class = "data.frame")


output <- recode_pop_region_codes(dummy_data)


# Function returns new clean region names
expected_region_names <- c("North East", "North West", "Yorkshire and The Humber", "East Midlands", "West Midlands", "East of England", "London", "South East", "South West", "North East", "North East", "North East", "Wales", "Scotland", "Northern Ireland")
actual_region_names <- output %>% dplyr::pull(region)

testthat::test_that("region names are correct", {
  expect_equal(actual_region_names, expected_region_names)
})
