#### GET POSTERIOR PROBABILITIES ####
#
# 1 get_posterior_probabilities
#
#   1.1 extract_posterior_probabilities
#
#### End of contents ####

#' @title get_posterior_probabilities
#' @description gets the posterior probabilities from the models
#' @param models list of models produced by fit_models (country x variant)
#' @param filtered_pop_tables list of filtered pop tables for the countries
#' @param filtered_aggregates list of filtered aggregates i.e. country by variant sample datasets
#' @param country_list list of countries
#' @param variant_list list of variants
#' @return list  list of posterior probablilities
#' @export
get_posterior_probabilities <- function(models,
                                        filtered_pop_tables,
                                        filtered_aggregates,
                                        country_list,
                                        variant_list) {
  posterior_probabilities <- Map(function(model, pop_counts_per_day, filtered_aggregates) {
    return(extract_posterior_probabilities(model, pop_counts_per_day, filtered_aggregates))
  }, models, filtered_pop_tables, filtered_aggregates)

  names(posterior_probabilities) <- paste0(country_list, variant_list)
  return(posterior_probabilities)
}

#' @title Extract probabilities from an MRP model, per region if needed
#' @description  applies rstanarm::posterior_epred
#'              and produces a list of  posterior draws of the predictor.
#'              IMPORTANT - for this to work, the workspace must contain two variables
#'              containing the oucome variable. this is an inssue with the
#'              rstanarm ::posterior_epred function rather than this function.
#'              these two necessary variables can be extracted from the model
#'              object like so:
#'              - n_pos <- model$model$`cbind(n_pos, n_neg)`[,1]
#               - n_neg <- model$model$`cbind(n_pos, n_neg)`[,2]
#' @param model GAMM4 model fit object
#' @param post_strat_table post_strat_table, replicated as many times as there
#'       are days in the model. n rows should equal the full factorial product of
#'       the n levels in all the factors in the model design n levels region x
#'       n levels var 2, x n levels var 3 etc
#' @param aggregated_data aggregated sample data
#'
#' @return  list of matrices (numeric) where one matrix contains all the posterior
#'         probabilities (i.e. for the whole country) and the other matrices contain
#'         the posterior probabilities for each of the level of the region variable
#'         in the model:
#'         - rows =  n draws sampled during modelling
#'         - for the averge of a factor, n col = the full factorial design product
#'           (i.e. n levels region x n levels var 2, x n levels var 3 etc - this equates
#'           to the n rows in the poststrat table).
#'         - for the single factor level matrices, n columns is equal to the
#'           product of number of levels in all factors besides the region variable
#'           (i.e. n levels var 2, x n levels var 3 etc)
#'
#' @export

extract_posterior_probabilities <- function(model, post_strat_table, aggregated_data) {
  if (!"stanreg" %in% class(model)) {
    stop("model must be a stanreg object")
  }

  n_days_in_model <- length(unique(model$model$study_day))
  n_days_in_poststrat <- length(unique(post_strat_table$study_day))

  if (!is.data.frame(post_strat_table)) {
    stop("post_strat_table must be a data.frame")
  }
  if (!"study_day" %in% colnames(post_strat_table)) {
    stop("post_strat_table must have a study_day column")
  }
  if (!"region" %in% colnames(post_strat_table)) {
    stop("post_strat_table must have a region column")
  }

  if (!"age_group" %in% colnames(post_strat_table)) {
    stop("post_strat_table must have an age_group column")
  }

  # result and n_neg need to be global variables for the posterior_linpred and posterior_epred to run
  assign("result", aggregated_data$result, envir = .GlobalEnv)
  assign("n_neg", aggregated_data$n_neg, envir = .GlobalEnv)

  output <- list()

  if (length(unique(model$model$region)) > 1) {
    output <- list(All = rstanarm::posterior_epred(model,
      newdata = post_strat_table
    ))
    for (regions in unique(model$model$region)) {
      output[[regions]] <- rstanarm::posterior_epred(model,
        newdata = dplyr::filter(
          post_strat_table,
          .data$region == regions
        )
      )
    }
  } else {
    output <- list(All = rstanarm::posterior_epred(model,
      newdata = post_strat_table
    ))
  }

  names(output) <- gsub("_0", "", names(output))

  return(output)
}
