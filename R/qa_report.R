#' @title QA Report
#'
#' @description Creates quality assurance report from the latest run of data
#'
#' @param local_location the local file path where you want to save the
#' qa_report
#' @param bucket the reference for the gcp bucket where you want to save this
#' to
#' @param main_config a list object containing the configuration settings
#' @param country_configs a list object containing the country specific
#' configuration settings
#' @param prevalence_time_series the main prevalence time series
#' @param previous_prevalence_time_series the previous prevalence time series
#' @param reference_day_vs_weeks_before_probabilities the week on week
#' probability comparisons
#' @param cleaned_aggregated_sample the cleaned aggregated sample
#' @param aggregated_HH the raw aggregated household data
#' @param aggregated_sample the raw aggregated sample data
#' @param post_stratified_draws the post-stratified draws from the model
#'
#' @return invisible, creates a qa_report file in the given location
#'
#' @export

qa_report <- function(
    local_location,
    bucket,
    main_config,
    country_configs,
    prevalence_time_series,
    previous_prevalence_time_series,
    reference_day_vs_weeks_before_probabilities,
    cleaned_aggregated_sample,
    aggregated_HH,
    aggregated_sample,
    post_stratified_draws) {
  date_stamp <- main_config$run_settings$data_run

  qa_report_name <- paste0("qa_report_mrp_", date_stamp)

  rmarkdown::render(
    input = "qa_report_template.Rmd",
    output_dir = local_location,
    output_file = qa_report_name,
    quiet = TRUE,
    params = list(
      main_config = main_config,
      country_configs = country_configs,
      prevalence_time_series = prevalence_time_series,
      previous_prevalence_time_series = previous_prevalence_time_series,
      reference_day_vs_weeks_before_probabilities = current_vs_previous_probabilities,
      cleaned_aggregated_sample = cleaned_aggregated_sample,
      aggregated_HH = aggregated_HH,
      aggregated_sample = aggregated_sample,
      post_stratified_draws = post_stratified_draws
    )
  )

  qa_report_file_path <- paste0(local_location, "/", qa_report_name, ".html")

  Sys.sleep(10)

  gcptools::save_qa_report(
    html_file_to_read = qa_report_file_path,
    bucket = bucket,
    config = main_config,
    filename = qa_report_name
  )
}
