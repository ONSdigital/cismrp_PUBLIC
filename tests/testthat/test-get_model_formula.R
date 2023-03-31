set.seed(1)

dummy_country <- "England"
dummy_variant <- "variant_Main"

dummy_config <- list(model_settings = list(
  knots = 6,
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

dummy_model_list <- list(England1 = dummy_fit_model)


testthat::test_that("it throws an error when country variable is not one of the eligible ones.", {
  replace <- "Panama"
  dummy_country <- replace
  testthat::expect_error(get_model_formula(model = dummy_model_list, country = dummy_country, variant = dummy_variant),
    info = "'arg' should be one of the following 'England', 'Wales', 'Scotland', 'Northern Ireland'"
  )
})

testthat::test_that("it throws an error when variant variable is not one of the eligible ones.", {
  replace <- "variant_Main"
  dummy_variant <- replace
  testthat::expect_error(get_model_formula(dummy_model_list, dummy_country, dummy_variant),
    info = "'arg' should be one of the following '1', '2', '4', '5'"
  )
})

testthat::test_that("a character string is returned when a valid model list is supplied", {
  testthat::expect_type(
    get_model_formula(dummy_model_list, "England", "1"),
    "character"
  )
})

testthat::test_that("the character string returned when a valid model list is supplied is coercible to vaid formula", {
  testthat::expect_s3_class(
    as.formula(get_model_formula(dummy_model_list, "England", "1")),
    "formula"
  )
})
