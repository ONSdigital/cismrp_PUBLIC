library(cismrp)
library(synthpop)

gcptools::authenticate_gcp()

aggregated_sample <- cismrp::ingest_data(
  file_reference = dummy_config$paths$sample_aggregates,
  data_run = dummy_config$run_settings$data_run
)

aggregated_sample_methods <- c("", "", "", "", "", "", "", "", "cart", "cart", "cart", "", "", "", "", "", "", "", "", "cart", "cart", "cart", "cart", "cart", "cart", "") # "" means do not generate synthetic data for these columns, "cart" is the method used for synthesising
aggregated_sample_smoothing <- list(n_pos = "density", n_neg = "density", n_void = "density", ab_pos = "density", ab_neg = "spline", n_ctpattern4 = "density", n_ctpattern7 = "spline", n_ctpattern5 = "spline", n_ctpattern6 = "spline") # apply smoothing to continuous variables to adjust their values slightly

end_date <- as.Date(max(unlist(dummy_config$run_settings$end_date)), format = "%Y%m%d")
start_date <- end_date - 59
dates_to_select <- seq(start_date, end_date, by = 1)
dates_to_select_as_string <- tolower(format(dates_to_select, "%d%b%Y"))

aggregated_sample_60_days <- aggregated_sample %>%
  dplyr::filter(
    visit_date %in% dates_to_select_as_string,
    !gor9d %in% c("W99999999", "N99999999")
  )

synthetic_aggregated_sample_object <- synthpop::syn(aggregated_sample_60_days,
  method = aggregated_sample_methods,
  smoothing = aggregated_sample_smoothing,
  seed = 2
)

synthetic_aggregated_sample <- synthetic_aggregated_sample_object$syn %>%
  dplyr::mutate(dplyr::across(dplyr::starts_with("ab"), ~NA),
    ct_mean = NA
  ) # %>%
# dplyr::mutate(data_run_date = max(visit_date) + 1)

assertthat::assert_that(!identical(synthetic_aggregated_sample, aggregated_sample_60_days))

usethis::use_data(synthetic_aggregated_sample, overwrite = TRUE)

### CLEANED AGGREGATED SAMPLE

cleaned_aggregated_sample <- cismrp::clean_aggregated(aggregated_sample_60_days)
synthetic_cleaned_aggregated_sample <- cismrp::clean_aggregated(synthetic_aggregated_sample)

assertthat::assert_that(!identical(cleaned_aggregated_sample, synthetic_cleaned_aggregated_sample))

usethis::use_data(synthetic_cleaned_aggregated_sample, overwrite = TRUE)

### FILTERED AGGREGATED SAMPLE

countries <- list("Scotland", "England")

dummy_country_configs <- cismrp::dummy_country_configs

dummy_country_configs_sample <- dummy_country_configs[names(dummy_country_configs) %in% countries]

country_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$country
variant_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$variant

filtered_aggregates <- cismrp::filter_aggregated_samp(
  cleaned_aggregated_sample,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

synthetic_filtered_aggregates <- cismrp::filter_aggregated_samp(
  synthetic_cleaned_aggregated_sample,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

assertthat::assert_that(!identical(filtered_aggregates, synthetic_filtered_aggregates))

usethis::use_data(synthetic_filtered_aggregates, overwrite = TRUE)

### MODELS

# models <- cismrp::try_catch_fit_all_models(
#   dummy_country_configs_sample,
#   country_list,
#   variant_list,
#   filtered_aggregates
# )

# synthetic_models <- cismrp::try_catch_fit_all_models(
#   dummy_country_configs_sample,
#   country_list,
#   variant_list,
#   filtered_aggregates
# )

# assertthat::assert_that(!identical(models, synthetic_models))

# usethis::use_data(synthetic_models, overwrite = TRUE)
