set.seed(1)

dummy_country <- "England"
dummy_variant <- "1"

dummy_config <- list(model_settings = list(
  knots = 5,
  seed = 12345,
  adapt_delta = 0.5,
  cores = 1,
  chains = 1,
  iterations = 250,
  refresh = 0,
  prior = list(
    location = .5,
    scale = .01
  ),
  prior_smooth = list(location = 2),
  prior_covariance = list(shape = 1, scale = 1),
  by_region = TRUE
))

data <- data.frame(
  sex = c("Male", "Female"),
  age_group = c("Young", "Old"),
  region = c("England", "Scotland"),
  study_day = 1:42
)

data <- data %>%
  tidyr::expand(.data$sex, .data$age_group, .data$region, .data$study_day) %>%
  dplyr::mutate(
    result = round(
      1000 * boot::inv.logit(
        ifelse(sex == "Male", 2, 0) +
          ifelse(age_group ==
            "Young", -2, 1) +
          ifelse(region == "England", 0, 0) +
          0.1 * study_day
      ),
      0
    ),
    n_neg = 10000 - result
  )

suppressWarnings(dummy_fit_model <- fit_model(
  data,
  dummy_config
))

dummy_model_list <- list("England1" = dummy_fit_model)

output <- get_n_divergent(dummy_model_list, dummy_country, dummy_variant)

testthat::test_that("a numeric variable is returned", {
  expect_true(is.numeric(output))
})

testthat::test_that("length equals to 1", {
  expect_true(length(output) == 1)
})

testthat::test_that("it throws an error when country variable is not one of the eligible ones.", {
  replace <- "Panama"
  dummy_country <- replace
  testthat::expect_error(get_n_divergent(dummy_model_list, dummy_country, dummy_variant),
    info = "'arg' should be one of the following 'England', 'Wales', 'Scotland', 'Northern Ireland'"
  )
})

testthat::test_that("it throws an error when variant variable is not one of the eligible ones.", {
  replace <- "variant"
  dummy_variant <- replace
  testthat::expect_error(get_n_divergent(dummy_model_list, dummy_country, dummy_variant),
    info = "'arg' should be one of the following 'variant_Main', 'variant__CTnot7not4', 'variant__CT4', 'variant__CT7'"
  )
})

testthat::test_that("divergent transitions value stays always the same for seed equals 1", {
  testthat::skip_on_ci()
  expect_true(output == 4)
})
