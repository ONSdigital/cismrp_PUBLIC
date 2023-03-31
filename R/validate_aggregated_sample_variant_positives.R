#' @title validate_aggregated_sample_variant_positives
#'
#' @description basic checks on the input data and stops the script if the input data is incorrect.
#'
#' @param data the aggregated sample data
#'
#' @export

validate_aggregated_sample_variant_positives <- function(data) {
  if (!all(data$n_pos - data$n_ctpattern4 - data$n_ctpattern7 - data$n_ctpattern5 - data$n_ctpattern6 >= 0)) {
    stop("Invalid data - the number of positive tests is smaller than the combined number of positive variant tests.")
  }
}
