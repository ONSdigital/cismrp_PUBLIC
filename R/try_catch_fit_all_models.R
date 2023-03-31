#### TRY CATCH FIT ALL MODELS ####
#
#  1 try_catch_fit_all_models
#
#    1.2 fit_all_models
#
#    1.3 par_Map
#
#    1.4 fit_model
#
#### End of contents ####

#' @title try_catch_fit_all_models
#' @description  fits GAMM for each country x variant combination provided
#' @param country_configs a list of country configs
#' @param country_list A list of the four UK countries, England, Scotland, Wales and Northern_Ireland
#' @param variant_list a list of the variants 1, 2, 4, 5
#' @param filtered_aggregates list of filtered aggregates i.e. country by variant sample datasets
#' @param cores the number of cores used by par_Map (defaults to 16)
#' @export

try_catch_fit_all_models <- function(country_configs,
                                     country_list,
                                     variant_list,
                                     filtered_aggregates,
                                     cores = 16) {
  tryCatchLog::tryCatchLog(
    expr = {
      models <- fit_all_models(
        country_configs,
        country_list,
        variant_list,
        filtered_aggregates,
        cores = cores
      )
    },
    silent.warnings = TRUE,
    logged.conditions = c("WARN", "ERROR"),
    include.full.call.stack = FALSE
  )
  return(models)
}

#' @title fit_all_models
#' @description  fits GAMM for each country x variant combination provided
#' @param country_configs a list of country configs
#' @param country_list A list of the four UK countries, England, Scotland, Wales and Northern_Ireland
#' @param variant_list a list of the variants 1, 2, 4, 5
#' @param filtered_aggregates list of filtered aggregates i.e. country by variant sample datasets
#' @param cores the number of cores used by par_Map (defaults to 16)

fit_all_models <- function(country_configs,
                           country_list,
                           variant_list,
                           filtered_aggregates,
                           cores = 16) {
  models <- par_Map(
    f = function(data, country, cores) {
      config <- country_configs[[country]]

      model <- fit_model(data, config)

      return(model)
    },
    cores = cores,
    filtered_aggregates,
    country_list
  )

  names(models) <- paste0(country_list, variant_list)

  return(models)
}

#' @title par_Map
#' @description parrallelise over a function
#'
#' @param f a function to parallelise over
#' @param cores number of cores (defaults to 16)
#' @param ... further arguments to f
#'
#' @return NA (depends on function)

par_Map <- function(f, cores = 16, ...) {
  f <- match.fun(f)
  parallel::mcmapply(FUN = f, ..., SIMPLIFY = FALSE, mc.cores = cores)
}

#' @title fits MRP model
#'
#' @description Takes various parameters and fits a general additive mixed model. The model fits a spline to study day.
#'
#' @param data dataframe
#' @param config config list
#'
#' @return stanreg object containing the estimated prevalences.
#' See http://127.0.0.1:35089/help/library/rstanarm/help/stanreg-objects for more info on the returned object.

fit_model <- function(data, config) {
  model_settings <- config$model_settings

  by_region <- model_settings$by_region

  n_days_to_model <- config$run_settings$n_days_to_model

  # this prior for sex needed as limited influence, and with e.g. normal(0,1) you get divergence issues
  prior <- rstanarm::normal(model_settings$prior$location, model_settings$prior$scale)

  if (is.null(model_settings$prior_smooth$location)) {
    prior_smooth <- rstanarm::normal(location = max(
      2,
      round((n_days_to_model - 25.5) / 30)
    ))
  } else {
    prior_smooth <- rstanarm::normal(location = model_settings$prior_smooth$location)
  }

  prior_covariance <- rstanarm::decov(shape = model_settings$prior_covariance$shape, scale = model_settings$prior_covariance$scale)
  refresh <- model_settings$refresh

  # if model_settings$knots is null choose knots based on days to model (Incidence doesn't set knots explicitly)
  if (is.null(model_settings$knots)) {
    knots <- (round((n_days_to_model / 7) - 1))
  } else {
    knots <- model_settings$knots
  }

  if (by_region) {
    model_formula <- paste0("cbind(result, n_neg) ~ s(study_day, by = region, k = ", knots, ") + sex")
    data <- data[c("study_day", "region", "sex", "age_group", "n_neg", "result")]

    #   # MODEL FORMULA FOR LABID FIXED EFFECT USED HERE, SEE LINE BELOW (HASHED OUT) FOR SPLINE EFFECT MODEL USED FOR COMPARISON TESTING
    # model_formula = paste0("cbind(result, n_neg) ~ s(study_day, by = region, k = ", knots, ") + lab_id + sex")
    # # model_formula = paste0("cbind(result, n_neg) ~ s(study_day, by = region, k = ", knots, ") + s(study_day, bs = "tp", by = lab_id) + lab_id + sex")
    # data <- data[c("study_day", "region", "sex", "age_group", "n_neg", "lab_id", "result")]

    fitted_MRP <- rstanarm::stan_gamm4(
      formula = stats::as.formula(model_formula),
      random = ~ (1 | age_group) + (1 | region),
      family = stats::binomial(link = "cloglog"), # use cloglog function to line up with other work
      data = data,
      iter = model_settings$iterations,
      chains = model_settings$chains,
      cores = model_settings$cores,
      prior = prior,
      prior_covariance = prior_covariance,
      adapt_delta = model_settings$adapt_delta,
      seed = model_settings$seed,
      prior_smooth = prior_smooth,
      refresh = refresh
    )
  } else {
    model_formula <- paste0("cbind(result, n_neg) ~ s(study_day, k = ", knots, ") + sex")
    data <- data[c("study_day", "sex", "age_group", "n_neg", "result")]
    #    # MODEL FORMULA FOR LABID FIXED EFFECT USED HERE, SEE LINE BELOW (HASHED OUT) FOR SPLINE EFFECT MODEL USED FOR COMPARISON TESTING
    # model_formula = paste0("cbind(result, n_neg) ~ s(study_day, k = ", knots, ") +  lab_id + sex")
    # #model_formula = paste0("cbind(result, n_neg) ~ s(study_day, k = ", knots, ") + s(study_day, bs = "tp", by = lab_id) + lab_id + sex")
    # data <- data[c("study_day", "sex", "age_group", "n_neg", "lab_id", "result")]
    fitted_MRP <- rstanarm::stan_gamm4(
      formula = stats::as.formula(model_formula),
      random = ~ (1 | age_group),
      family = stats::binomial(link = "cloglog"), # use cloglog function to line up with other work
      data = data,
      iter = model_settings$iterations,
      chains = model_settings$chains,
      cores = model_settings$cores,
      prior = prior,
      prior_covariance = prior_covariance,
      adapt_delta = model_settings$adapt_delta,
      seed = model_settings$seed,
      prior_smooth = prior_smooth,
      refresh = refresh
    )
  }
}
