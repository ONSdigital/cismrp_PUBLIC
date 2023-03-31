#' @title Make Divergent Table
#'
#' @description This function creates a kable table listing the number of divergent transitions.
#'
#' @param country_configs a list object containing the configuration settings
#'
#' @param country a string containing the name of a country you want to filter by
#'
#' @param models a list object containing the model
#'
#' @param main_config a list object containing the main configuration settings for the system
#'
#' @return a kable table
#'
#' @export

make_divergent_table <- function(country_configs, country, models, main_config) {
  n_divergent_by_model <- lapply(country_configs[[country]]$run_settings$variants,
    FUN = function(X) {
      get_n_divergent(
        model = models,
        country = country,
        variant = as.character(X)
      )
    }
  )

  n_divergent_by_model <- data.frame(n_divergent_by_model)
  colnames(n_divergent_by_model) <- main_config$variant_labels

  table <- n_divergent_by_model %>%
    kableExtra::kbl(align = "c") %>%
    kableExtra::kable_styling(
      bootstrap_options = "striped",
      font_size = 18,
      position = "left",
      full_width = TRUE
    )

  return(table)
}
