library(cismrp)
library(synthpop)

gcptools::authenticate_gcp()

aggregated_HH <- cismrp::ingest_data(
  file_reference = dummy_config$paths$household_checks,
  data_run = dummy_config$run_settings$data_run
)

aggregated_HH_methods <- c(
  "",
  "",
  "",
  "",
  "",
  "cart",
  "",
  "",
  "cart",
  "cart",
  "cart"
) # "" means do not generate synthetic data for these columns, "cart" is the method used for synthesising
aggregated_HH_smoothing <- list(
  n_hh_for_ab_pos = "",
  n_hh_for_pos = "density",
  n_hh_ever_ab = "",
  n_hh_ever_ab_pos = "",
  n_hh_with_first_hh_pos = "density",
  n_hh_with_pos = "spline",
  max_pos_hh = "spline"
) # apply smoothing to continuous variables to adjust their values slightly

end_date <- as.Date(max(unlist(dummy_config$run_settings$end_date)), format = "%Y%m%d")
start_date <- end_date - 59
dates_to_select <- seq(start_date, end_date, by = 1)
dates_to_select_as_string <- tolower(format(dates_to_select, "%d%b%Y"))

aggregated_HH_60_days <- aggregated_HH %>%
  dplyr::filter(
    visit_date %in% dates_to_select_as_string,
    !gor_name %in% c("12_WAL", "10_NI")
  )

synthetic_aggregated_HH <- synthpop::syn(aggregated_HH_60_days,
  method = aggregated_HH_methods,
  smoothing = aggregated_HH_smoothing,
  seed = 2
)$syn

assertthat::assert_that(!identical(synthetic_aggregated_HH, aggregated_HH_60_days))

usethis::use_data(synthetic_aggregated_HH, overwrite = TRUE)
