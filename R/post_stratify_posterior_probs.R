#### POST STRATIFY POSTERIOR PROBS ####
#
#  1 post_stratify_posterior_probs
#
#    1.1 post_stratify_draws_by_region
#
#      1.1.1 post_stratify_draws
#
#### End of contents ####

#' @title post_stratify_posterior_probs
#' @description post-stratified draws from the posterior probabilities
#' @param filtered_pop_tables list of filtered pop tables for the countries
#' @param posterior_probabilities list of posterior probablilities to apply post-stratification to
#' @param country_list list of countries
#' @param variant_list list of variants
#' @return list a list of poststratified draws (country x variant)
#' @export

post_stratify_posterior_probs <- function(filtered_pop_tables,
                                          posterior_probabilities,
                                          country_list,
                                          variant_list) {
  post_stratified_draws <- Map(function(posterior_probabilities, pop_counts_per_day) {
    return(post_stratify_draws_by_region(posterior_probabilities, pop_counts_per_day))
  }, posterior_probabilities, filtered_pop_tables)

  names(post_stratified_draws) <- paste0(country_list, variant_list)
  return(post_stratified_draws)
}

#' @title post stratify draws by region
#'
#' @description loop through all regions and post stratify draws
#'
#' @param posteriors_list list of matrices, returned from extract_posterior_probabilities
#' @param post_strat_table population counts for each group - see post_stratify_draws
#'
#' @returns list of post-stratified draws

post_stratify_draws_by_region <- function(posteriors_list, post_strat_table) {
  post_stratified_posteriors <- lapply(names(posteriors_list), function(region) {
    if (region == "All") {
      filtered_post_strat_table <- post_strat_table
    } else {
      filtered_post_strat_table <- post_strat_table[post_strat_table$region == region, ]
    }

    return(post_stratify_draws(filtered_post_strat_table, posteriors_list[[region]]))
  })

  names(post_stratified_posteriors) <- names(posteriors_list)

  return(post_stratified_posteriors)
}

#' @title post stratify draws
#'
#' @description
#' post-stratifies posterior draws that have been extracted from model fit using rstanarm::posterior_epred
#' or posterior_linpred and data = post_strat_table. For each day, draws are matrix multiplied
#' with the proportion that N corresponding to the factor level combination makes up.
#'
#' @return Dataframe containing posterior draws post-stratified according to population counts in each group combinations
#' n rows = number of draws samples in model. n columns = number of days modelled.
#'
#' @param post_strat_table population table with counts for every combination of conditions from each factor in model, with Ns.
#'                        MUST have the same conditions as the table used in rstanarm::postrior_epred / rstanarm::posterior_linpred. if
#'                        no argumant is passed to n_days_to_model, the table much be replicated for every day of the model
#'                        and day number must be indicated by study_day variable.
#' @param posterior_prob matrix of posterior draws outputted by posterior_epred / posterior_linpred.
#'                   n rows = number of draws sampled. n columns = the product of the number
#'                   of levels in each predictor x n days modelled. each column of posterior_probs
#'                   corresponds to each row in the post-stratification table assigned to new_data
#'                   during extraction with posterior_linpred
#' @param n_days_to_model optional argument (but not recommended). used if the user wants to use a
#'                   poststrat table that has not been replicated for every day of the model.
#'                   poststrat table must still have a study_day column.
#'                   best to use the same post_strat table that was used to extract data from model
#'                   fit object which would hhave been replicated, rather than this option.
#'
#' @return post-stratified draws

post_stratify_draws <- function(post_strat_table, posterior_prob, n_days_to_model) {
  if (!is.data.frame(post_strat_table)) {
    stop("Unexpected input: post_strat_table is not a data frame")
  }

  if (!is.matrix(posterior_prob) | typeof(posterior_prob) != "double") {
    stop("Unexpected input: posterior_prob is not a numeric matrix (double)")
  } else if (any(posterior_prob > 1 | posterior_prob < 0)) {
    stop("Unexpected input: posterior_prob values should be between 0 and 1")
  }

  if (missing(n_days_to_model)) {
    n_days_to_model <- length(unique(post_strat_table$study_day))
  } else {
    if (!is.numeric(n_days_to_model)) {
      stop("Unexpected input: n_days_to_model should be numeric")
    }
  }

  n_level_combos <- nrow(post_strat_table) / length(unique(post_strat_table$study_day))

  # Code breaks further downstream if column N is a factor
  ps_table_pops_one_day <- as.numeric(
    as.character(
      post_strat_table$N[post_strat_table$study_day == min(post_strat_table$study_day)]
    )
  )

  if ((n_level_combos * n_days_to_model) != ncol(posterior_prob)) {
    # create value to spit out in message
    n_days_implied_by_posterior_draws <- ncol(posterior_prob) / length(ps_table_pops_one_day)

    if (missing(n_days_to_model)) {
      stop(paste0(
        "Posterior probabilities matrix suggests ", n_days_implied_by_posterior_draws, " days were modelled ",
        "while the value passed n_days_to_model suggests ", n_days_to_model,
        ". Please check assign correct value to n_days_to_model"
      ))
    } else {
      stop(paste0(
        "Posterior probabilities matrix suggests ", n_days_implied_by_posterior_draws, " days were modelled ",
        "while the poststrat table suggests ", n_days_to_model,
        ". Please check the post_strat table (or assign correct value to n_days_to_model instead)."
      ))
    }
  }

  post_strat_probs <- sapply(1:n_days_to_model, function(day) {
    if (day == 1) {
      from <- 1
      to <- n_level_combos
    } else if (day != 1) {
      from <- (day - 1) * n_level_combos + 1
      to <- day * n_level_combos
    }

    post_strat_probs_temp <- posterior_prob[, from:to] %*% ps_table_pops_one_day /
      sum(ps_table_pops_one_day)

    return(post_strat_probs_temp)
  })

  return(post_strat_probs)
}
