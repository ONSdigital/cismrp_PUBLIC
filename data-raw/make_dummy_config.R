dummy_config <- list()

dummy_config$run_settings$environment <- "GCP"
dummy_config$run_settings$test <- FALSE
dummy_config$run_settings$test_configs_short <- FALSE
dummy_config$run_settings$rerun <- FALSE
dummy_config$run_settings$data_run <- "20221205"

dummy_config$run_settings$end_date$England <- "20221126"
dummy_config$run_settings$end_date$`Northern Ireland` <- "20221123"
dummy_config$run_settings$end_date$Scotland <- "20221124"
dummy_config$run_settings$end_date$Wales <- "20221124"

dummy_config$run_settings$prev_data_run <- "20221128"

dummy_config$run_settings$prev_end_date$England <- "20221121"
dummy_config$run_settings$prev_end_date$`Northern Ireland` <- "20221121"
dummy_config$run_settings$prev_end_date$Scotland <- "20221121"
dummy_config$run_settings$prev_end_date$Wales <- "20221121"

dummy_config$run_settings$analyst <- "Aquaman"
dummy_config$run_settings$qa_report_filename_suffix <- NULL
dummy_config$run_settings$days_to_check <- 60.0

dummy_config$run_settings$countries <- c("England", "Scotland")

dummy_config$paths$population_totals <- "poststrat_updated_census_2021_aggregated.csv"
dummy_config$paths$sample_aggregates <- "_main_aggregates"
dummy_config$paths$household_checks <- "_hh_checks_aggregates"

dummy_config$GCP$wip_bucket <- "ons-psplus-analysis-prod-cis-wip"
dummy_config$GCP$data_bucket <- "ons-psplus-data-prod-psplus-cis-data"
dummy_config$GCP$review_bucket <- "ons-psplus-analysis-prod-cis-review"

dummy_config$variant_labels$ctall <- "All"
dummy_config$variant_labels$ct4 <- "ct4, S Neg; BA.5*/BQ.1*"
dummy_config$variant_labels$ct7 <- "ct7, S Pos; BA.2.75*/XBB*"
dummy_config$variant_labels$ctnot4not7 <- "Variant Unidentifiable"

usethis::use_data(dummy_config, overwrite = TRUE)
