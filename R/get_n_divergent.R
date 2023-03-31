#' @title get_n_divergent
#' @description for a given stan model return the number of divergent transistions
#' @param model list of model objects
#' @param country country to extract from list
#' @param variant variant to extract from list
#' @return number of divergent transitions
#' @export

get_n_divergent <- function(model,
                            country = c("England", "Wales", "Scotland", "Northern Ireland"),
                            variant = c("1", "2", "4", "5")) {
  country <- match.arg(country)
  variant <- match.arg(variant)

  model <- model[[paste0(country, variant)]]$stanfit

  iter_divergent_T_or_F <- rstan::get_divergent_iterations(model)

  n_divergent <- sum(iter_divergent_T_or_F)

  return(n_divergent)
}
