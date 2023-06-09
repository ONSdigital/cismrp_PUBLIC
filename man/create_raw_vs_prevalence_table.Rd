% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_raw_vs_prevalence_table.R
\name{create_raw_vs_prevalence_table}
\alias{create_raw_vs_prevalence_table}
\title{Create Raw vs Prevalence Table}
\usage{
create_raw_vs_prevalence_table(
  aggregated_sample,
  aggregated_HH,
  prevalence_time_series,
  COUNTRY,
  region_or_country
)
}
\arguments{
\item{aggregated_sample}{a dataframe containing the raw participant sample}

\item{aggregated_HH}{a dataframe containing the raw household sample}

\item{prevalence_time_series}{a dataframe containing the modelled prevalence
estimates}

\item{COUNTRY}{a string containing the name of the country you want to filter by}

\item{region_or_country}{a string containing either 'region' or 'country'}
}
\value{
a styled html table with raw and prevalence data
}
\description{
function to create raw vs prevalence table by region or country
}
