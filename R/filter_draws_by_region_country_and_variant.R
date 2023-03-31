#' @title filter_draws_by_region_country_and_variant
#'
#' @description function to filter post_stratified_draws by region, country and variant to keep only one type.
#'
#' @param post_stratified_draws a list object containing the post-stratified draws from the model
#' @param region a string containing the name of the region you want to filter by
#' @param country a string containing the name of the country you want to filter by
#' @param variant a string containing the name of the variant you want to filter by
#'
#' @return a matrix containing the predicted draws for the specific region, country and variant
#'
#' @export

filter_draws_by_region_country_and_variant <- function(post_stratified_draws,
                                                       region,
                                                       country,
                                                       variant) {
  filter_pattern <- paste0(country, variant)

  filtered_draws <- post_stratified_draws[[filter_pattern]][[region]]

  return(filtered_draws)
}
