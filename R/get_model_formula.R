#' @title get_model_formula
#'
#' @description for a given stan model return the model formula
#' @param model list of model objects
#'
#' @param country character string of country to extract from list
#'
#' @param variant character string of variant to extract from list
#'
#' @export
#'

get_model_formula <- function(model,
                              country = c("England", "Wales", "Scotland", "Northern Ireland"),
                              variant = c("1", "2", "4", "5")) {
  country <- match.arg(country)
  variant <- match.arg(variant)
  formula <- model[[paste0(country, variant)]]$formula
  formula <- base::Reduce(paste, deparse(formula))
  return(formula)
}
