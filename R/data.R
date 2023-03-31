#' @name synthetic_overview
#'
#' @title Synthetic Data Overview
#'
#' @description Synthetic data is generated using the Synthpop library to synthesise population and sample columns so data is non-disclosive but attempts to capture trends present in the original dataset. Columns have been synthesised using the CART method. Guassian kernel density smoothing is applied after synthesis.
#'
#' @family Synthetic Data
NULL

### Configs ------------------------------------------------------------------

#' @title Dummy Config
#'
#' @description A dummy configuration file to run unit tests on automated file disclosure control checking functions.
#'
#' @source created by data-raw/make_dummy_config.R
"dummy_config"



#' @title Dummy Country Configs
#'
#' @description A dummy country specific configuration file to run unit tests on automated file disclosure control checking functions.
#'
#' @source created by data-raw/make_dummy_country_configs.R
"dummy_country_configs"

### Aggregated HH -----------------------------------------------------------

#' @title Synthetic Aggregated Housholds
#'
#' @description A synthetic  aggregated household version of the data which is after it is first loaded in
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_aggregated_hh.R
"synthetic_aggregated_HH"



### Aggregated Sample -----------------------------------------------------------

#' @title Synthetic Aggregated Sample
#'
#' @description A synthetic  aggregated sample version of the data which is after it is first loaded in
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_aggregated_sample.R
"synthetic_aggregated_sample"


#' @title Synthetic Cleaned Aggregated Sample
#'
#' @description A synthetic dataset used for examples and/or testing. Represents what aggregated sample should look like after ingest and cleaning applied. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_cleaned_aggregated_sample"


#' @title Synthetic Filtered Aggregates
#'
#' @description A synthetic dataset used for examples and/or testing. Represents what aggregated sample should look like after ingest, cleaning and filtering applied. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_filtered_aggregates"



### Population Counts ------------------------------------------------------------

#' @title Synthetic Cleaned Population Counts
#'
#' @description A synthetic dataset used for examples and/or testing. Represents what population counts should look like after initial cleaning. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_cleaned_population_counts"



#' @title Synthetic Population Counts
#'
#' @description A synthetic dataset used for examples and/or testing. Represents what population counts should look like after ingest. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_population_counts"

#' @title Synthetic Filtered Population Counts
#'
#' @description A synthetic dataset used for examples and/or testing. Represents what population counts should look like after ingest, cleaning and filtered. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_filtered_pop_tables"

### Prevalence Time Series ------------------------------------------------------------

#' @title Synthetic Prevalence Time Series
#'
#' @description A synthetic dataset used for examples and/or testing. Represents what the pravelance time series should look like after model fitting and posterior draws have been taken. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_prevalence_time_series"



#' @title Synthetic Previous Prevalence Time Series
#'
#' @description A synthetic dataset used for examples and/or testing. This is the same as the synthetic prevalence time series but with the final week of data removed to simulate a previous run. This synthetic data represents the England and Scotland data.
#'
#' @family Synthetic Data
#'
#' @source created by data-raw/make_synthetic_data.R
"synthetic_previous_prevalence_time_series"


### Post Stratified Draws ------------------------------------------------------------

#' @title Dummy Post Stratified Draws
#'
#' @description A dummy dataset used for examples and/or testing. Represents what post-stratified draws should look like after they have been produced. This dummy data represents the England and Scotland data.
#'
#'
#' @source created by data-raw/make_dummy_post_stratified_draws.R
"dummy_post_stratified_draws"


#' @title Dummy Reference Day vs Weeks before Probabilities
#'
#' @description A dummy dataset used for examples and/or testing. Represents what post-stratified Reference Day vs Weeks before Probabilities should look like after they have been produced. This dummy data represents the England and Scotland data.
#'
#'
#' @source created by data-raw/make_dummy_post_stratified_draws.R
"dummy_reference_day_vs_weeks_before_probabilities"
