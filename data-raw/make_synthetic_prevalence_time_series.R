library(cismrp)
library(synthpop)

gcptools::authenticate_gcp()

### SETUP

countries <- list("Scotland", "England")

dummy_country_configs_sample <- dummy_country_configs[names(dummy_country_configs) %in% countries]

country_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$country
variant_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$variant
region_list <- list("All", gcptools::england_regions)

population_counts <- suppressMessages(
  gcptools::gcp_read_csv(
    dummy_config$paths$population_totals,
    bucket = "data_bucket"
  )
)

aggregated_sample <- cismrp::ingest_data(
  file_reference = dummy_config$paths$sample_aggregates,
  data_run = dummy_config$run_settings$data_run
)

aggregated_HH <- cismrp::ingest_data(
  file_reference = dummy_config$paths$household_checks,
  data_run = dummy_config$run_settings$data_run
)

cleaned_population_counts <- cismrp::clean_population_counts(population_counts)
cleaned_aggregated_sample <- cismrp::clean_aggregated(aggregated_sample)

filtered_aggregates <- cismrp::filter_aggregated_samp(
  cleaned_aggregated_sample,
  dummy_country_configs,
  country_list,
  variant_list
)

filtered_pop_tables <- cismrp::filter_pop_table(
  cleaned_population_counts,
  dummy_config,
  dummy_country_configs,
  country_list,
  variant_list
)

models <- cismrp::try_catch_fit_all_models(
  dummy_country_configs,
  country_list,
  variant_list,
  filtered_aggregates
)

posterior_probabilities <- cismrp::get_posterior_probabilities(
  models,
  filtered_pop_tables,
  filtered_aggregates,
  variant_list = variant_list,
  country_list = country_list
)

post_stratified_draws <- cismrp::post_stratify_posterior_probs(
  filtered_pop_tables,
  posterior_probabilities,
  variant_list = variant_list,
  country_list = country_list
)

prevalence_time_series <- cismrp::create_prevalence_series(
  dummy_country_configs,
  post_stratified_draws,
  region_list,
  country_list,
  variant_list
)

prevalence_time_series_sequence <- c(2, 1, 6, 7, 3, 4, 5) # synthesise date in this order of columns
prevalence_time_series_methods <- c("", "", "cart", "cart", "cart", "", "") # "" means do not generate synthetic data for these columns, "cart" is the method used for synthesising
prevalence_time_series_smoothing <- list(mean = "density", ll = "density", ul = "density") # apply smoothing to continuous variables to adjust their values slightly

synthetic_prevalence_time_series_object <- synthpop::syn(
  prevalence_time_series,
  visit.sequence = prevalence_time_series_sequence,
  method = prevalence_time_series_methods,
  smoothing = prevalence_time_series_smoothing,
  seed = 2
)

assertthat::assert_that(!identical(prevalence_time_series, synthetic_prevalence_time_series))

synthetic_prevalence_time_series <- synthetic_prevalence_time_series_object$syn %>%
  dplyr::mutate(
    mean = mean + runif(dplyr::n()),
    ll = ll - runif(dplyr::n()),
    ul = ul + 1 + runif(dplyr::n())
  )

assertthat::assert_that(!identical(prevalence_time_series, synthetic_prevalence_time_series))

usethis::use_data(synthetic_prevalence_time_series, overwrite = TRUE)

end_date <- as.Date(synthetic_prevalence_time_series %>% dplyr::pull(time) %>% max(), format = "%Y-%m-%d")
week_lag <- end_date - 7

synthetic_previous_prevalence_time_series <- synthetic_prevalence_time_series %>%
  dplyr::filter(
    time <= week_lag,
  )

usethis::use_data(synthetic_previous_prevalence_time_series, overwrite = TRUE)
