library(cismrp)
library(synthpop)

gcptools::authenticate_gcp()

population_counts <- suppressMessages(
  gcptools::gcp_read_csv(
    dummy_config$paths$population_totals,
    bucket = "data_bucket"
  )
) %>% dplyr::select(-"...1")

population_counts_sequence <- c(1, 2, 3, 4, 5, 6) # synthesise date in this order of columns
population_counts_methods <- c("", "", "", "", "", "cart") # "" means do not generate synthetic data for these columns, "cart" is the method used for synthesising
population_counts_smoothing <- list(N = "density") # apply smoothing to continuous variables to adjust their values slightly

synthetic_population_counts <- synthpop::syn(
  population_counts,
  visit.sequence = population_counts_sequence,
  method = population_counts_methods,
  smoothing = population_counts_smoothing,
  seed = 2
)

synthetic_population_counts <- synthetic_population_counts$syn

assertthat::assert_that(!identical(population_counts, synthetic_population_counts),
  msg = "You are trying to save data identical to the disclosive data, please check the file you are saving"
)

usethis::use_data(synthetic_population_counts, overwrite = TRUE)

### CLEANED POPULATION COUNTS

cleaned_population_counts <- cismrp::clean_population_counts(population_counts)
synthetic_cleaned_population_counts <- cismrp::clean_population_counts(synthetic_population_counts)

assertthat::assert_that(!identical(cleaned_population_counts, synthetic_cleaned_population_counts))

usethis::use_data(synthetic_cleaned_population_counts, overwrite = TRUE)

### FILTERED POP TABLES

countries <- list("Scotland", "England")

dummy_country_configs_sample <- dummy_country_configs[names(dummy_country_configs) %in% countries]

country_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$country
variant_list <- cismrp::get_map_lists(countries, dummy_country_configs_sample)$variant

filtered_pop_tables <- cismrp::filter_pop_table(
  cleaned_population_counts,
  dummy_config,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

synthetic_filtered_pop_tables <- cismrp::filter_pop_table(
  synthetic_cleaned_population_counts,
  dummy_config,
  dummy_country_configs_sample,
  country_list,
  variant_list
)

assertthat::assert_that(!identical(filtered_pop_tables, synthetic_filtered_pop_tables))

usethis::use_data(synthetic_filtered_pop_tables, overwrite = TRUE)
