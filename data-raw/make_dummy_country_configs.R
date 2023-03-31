dummy_country_configs <- list()

# Northern Ireland
dummy_country_configs$`Northern Ireland`$run_settings$variants <- c(1, 2, 4, 5)
dummy_country_configs$`Northern Ireland`$run_settings$n_days_to_model <- 56
dummy_country_configs$`Northern Ireland`$run_settings$end_date <- as.Date("20221123", format = "%Y%m%d")

dummy_country_configs$`Northern Ireland`$model_settings$by_region <- FALSE
dummy_country_configs$`Northern Ireland`$model_settings$knots <- 6
dummy_country_configs$`Northern Ireland`$model_settings$seed <- 42
dummy_country_configs$`Northern Ireland`$model_settings$adapt_delta <- 0.59
dummy_country_configs$`Northern Ireland`$model_settings$cores <- 4
dummy_country_configs$`Northern Ireland`$model_settings$chains <- 4
dummy_country_configs$`Northern Ireland`$model_settings$iterations <- 250
dummy_country_configs$`Northern Ireland`$model_settings$refresh <- 0

dummy_country_configs$`Northern Ireland`$model_settings$prior$location <- 0
dummy_country_configs$`Northern Ireland`$model_settings$prior$scale <- 0.5

dummy_country_configs$`Northern Ireland`$model_settings$prior_smooth$location <- 2

dummy_country_configs$`Northern Ireland`$model_settings$prior_covariance$shape <- 1
dummy_country_configs$`Northern Ireland`$model_settings$prior_covariance$scale <- 1

dummy_country_configs$`Northern Ireland`$probability_output_settings$ref_days_from_end <- 3
dummy_country_configs$`Northern Ireland`$probability_output_settings$comparison_period <- c(7, 14)
dummy_country_configs$`Northern Ireland`$probability_output_settings$percent_change_threshold <- 15

# England
dummy_country_configs$England$run_settings$variants <- c(1, 2, 4, 5)
dummy_country_configs$England$run_settings$n_days_to_model <- 49
dummy_country_configs$England$run_settings$end_date <- as.Date("20221126", format = "%Y%m%d")

dummy_country_configs$England$model_settings$by_region <- TRUE
dummy_country_configs$England$model_settings$knots <- 6
dummy_country_configs$England$model_settings$seed <- 42
dummy_country_configs$England$model_settings$adapt_delta <- 0.55
dummy_country_configs$England$model_settings$cores <- 4
dummy_country_configs$England$model_settings$chains <- 4
dummy_country_configs$England$model_settings$iterations <- 250
dummy_country_configs$England$model_settings$refresh <- 0

dummy_country_configs$England$model_settings$prior$location <- 0
dummy_country_configs$England$model_settings$prior$scale <- 0.5

dummy_country_configs$England$model_settings$prior_smooth$location <- 2

dummy_country_configs$England$model_settings$prior_covariance$shape <- 1
dummy_country_configs$England$model_settings$prior_covariance$scale <- 1

dummy_country_configs$England$probability_output_settings$ref_days_from_end <- 3
dummy_country_configs$England$probability_output_settings$comparison_period <- c(7, 14)
dummy_country_configs$England$probability_output_settings$percent_change_threshold <- 15

# Scotland
dummy_country_configs$Scotland$run_settings$variants <- c(1, 2, 4, 5)
dummy_country_configs$Scotland$run_settings$n_days_to_model <- 56
dummy_country_configs$Scotland$run_settings$end_date <- as.Date("20221124", format = "%Y%m%d")

dummy_country_configs$Scotland$model_settings$by_region <- FALSE
dummy_country_configs$Scotland$model_settings$knots <- 6
dummy_country_configs$Scotland$model_settings$seed <- 42
dummy_country_configs$Scotland$model_settings$adapt_delta <- 0.59
dummy_country_configs$Scotland$model_settings$cores <- 4
dummy_country_configs$Scotland$model_settings$chains <- 4
dummy_country_configs$Scotland$model_settings$iterations <- 250
dummy_country_configs$Scotland$model_settings$refresh <- 0

dummy_country_configs$Scotland$model_settings$prior$location <- 0
dummy_country_configs$Scotland$model_settings$prior$scale <- 0.5

dummy_country_configs$Scotland$model_settings$prior_smooth$location <- 2

dummy_country_configs$Scotland$model_settings$prior_covariance$shape <- 1
dummy_country_configs$Scotland$model_settings$prior_covariance$scale <- 1

dummy_country_configs$Scotland$probability_output_settings$ref_days_from_end <- 3
dummy_country_configs$Scotland$probability_output_settings$comparison_period <- c(7, 14)
dummy_country_configs$Scotland$probability_output_settings$percent_change_threshold <- 15

# Wales
dummy_country_configs$Wales$run_settings$variants <- c(1, 2, 4, 5)
dummy_country_configs$Wales$run_settings$n_days_to_model <- 56
dummy_country_configs$Wales$run_settings$end_date <- as.Date("20221124", format = "%Y%m%d")

dummy_country_configs$Wales$model_settings$by_region <- FALSE
dummy_country_configs$Wales$model_settings$knots <- 6
dummy_country_configs$Wales$model_settings$seed <- 42
dummy_country_configs$Wales$model_settings$adapt_delta <- 0.5
dummy_country_configs$Wales$model_settings$cores <- 4
dummy_country_configs$Wales$model_settings$chains <- 4
dummy_country_configs$Wales$model_settings$iterations <- 250
dummy_country_configs$Wales$model_settings$refresh <- 0

dummy_country_configs$Wales$model_settings$prior$location <- 0
dummy_country_configs$Wales$model_settings$prior$scale <- 0.5

dummy_country_configs$Wales$model_settings$prior_smooth$location <- 2

dummy_country_configs$Wales$model_settings$prior_covariance$shape <- 1
dummy_country_configs$Wales$model_settings$prior_covariance$scale <- 1

dummy_country_configs$Wales$probability_output_settings$ref_days_from_end <- 3
dummy_country_configs$Wales$probability_output_settings$comparison_period <- c(7, 14)
dummy_country_configs$Wales$probability_output_settings$percent_change_threshold <- 15

usethis::use_data(dummy_country_configs, overwrite = TRUE)
