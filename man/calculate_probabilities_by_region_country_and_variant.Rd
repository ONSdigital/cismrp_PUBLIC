% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_probabilities_comparing_dates.R
\name{calculate_probabilities_by_region_country_and_variant}
\alias{calculate_probabilities_by_region_country_and_variant}
\title{calculate_probabilities_by_region_country_and_variant}
\usage{
calculate_probabilities_by_region_country_and_variant(
  region,
  country,
  variant,
  post_stratified_draws,
  country_configs
)
}
\arguments{
\item{region}{a string containing the name of the region you want to filter by}

\item{country}{a string containing the name of the country you want to filter by}

\item{variant}{a string containing the name of the variant you want to filter by}

\item{post_stratified_draws}{a list object containing the post-stratified draws from the model}

\item{country_configs}{a list object containing the configuration settings for each country}
}
\value{
a matrix containing the predicted draws for the specific region, country and variant
}
\description{
function to filter post_stratified_draws by region, country and variant to keep only one type.
}
