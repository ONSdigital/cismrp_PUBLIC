% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_overlay_plot.R
\name{create_overlay_plot}
\alias{create_overlay_plot}
\title{Create Overlay Plot}
\usage{
create_overlay_plot(
  prevalence_time_series,
  previous_prevalence_time_series,
  COUNTRY,
  VARIANT,
  region_or_country
)
}
\arguments{
\item{prevalence_time_series}{a dataframe containing the prevalence time series}

\item{previous_prevalence_time_series}{a dataframe containing the previous prevalence time series}

\item{COUNTRY}{a string containing the name of a country you want to filter by}

\item{VARIANT}{a string containing the name of the variant you want to filter by}

\item{region_or_country}{specify "country" for one ggplot object of data from an individial country, specify "region" for ggplot object of England regions}
}
\value{
a ggplot object containing the current and previous prevalence time series layered on top of the same chart
}
\description{
creates overlay plot which overlays current prevalence estimates with previous estimates
}
