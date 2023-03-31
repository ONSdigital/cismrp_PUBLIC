create_day_draws <- function(day_mean, variant_difference, n = 25, sd = 0.002) {
  day_draws <- rnorm(n = n, mean = day_mean + variant_difference, sd = sd)
  return(day_draws)
}

create_day_mean <- function(n_days, max = 0.04, min = 0.01) {
  difference <- max - min
  day_mean <- seq(min, max, difference / (n_days - 1))
  return(day_mean)
}


create_country_variant_matrix <- function(country_n_days, variant_difference) {
  variant_difference <- rep(variant_difference, country_n_days)

  random_day_mean <- create_day_mean(country_n_days)

  predictions <- purrr::map2(
    .x = random_day_mean,
    .y = variant_difference,
    .f = create_day_draws
  )

  do.call(what = cbind, args = predictions)
}

create_country_variant_draws <- function(country, variant) {
  days_by_country <- c(
    "England" = 49,
    "Scotland" = 56
  )
  random_variant_difference <- c("1" = 0, "2" = 0.01, "4" = 0.02, "5" = 0.03)
  days <- days_by_country[country]
  variant_difference <- random_variant_difference[variant]

  create_country_variant_matrix(days, variant_difference)
}

country_list <- c(rep("England", 40), rep("Scotland", 4))

region_list <- list(
  "England" = list(c("All", gcptools::england_regions)),
  "Scotland" = list("All")
)

variant_list <- c(sort(rep(c("1", "2", "4", "5"), 10)), "1", "2", "4", "5")

country_variant <- paste0(country_list, variant_list)

dummy_post_stratified_draws <- list()

for (i in unique(country_variant)) {
  country <- gsub(pattern = "[1-5]", replacement = "", x = i)
  variant <- gsub(pattern = "[A-z]*", replacement = "", x = i)
  short_region_list <- region_list[[country]][[1]]
  dummy_post_stratified_draws[[i]] <- list()

  for (k in short_region_list) {
    print(k)
    dummy_post_stratified_draws[[i]][[k]] <- create_country_variant_draws(country, variant)
  }
}

usethis::use_data(dummy_post_stratified_draws, overwrite = TRUE)


dummy_reference_day_vs_weeks_before_probabilities <- cismrp::calculate_probabilities_comparing_dates(
  dummy_post_stratified_draws,
  dummy_country_configs,
  region_list,
  country_list,
  variant_list
)

usethis::use_data(dummy_reference_day_vs_weeks_before_probabilities, overwrite = TRUE)
