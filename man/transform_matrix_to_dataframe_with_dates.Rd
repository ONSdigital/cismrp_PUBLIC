% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transform_matrix_to_dataframe_with_dates.R
\name{transform_matrix_to_dataframe_with_dates}
\alias{transform_matrix_to_dataframe_with_dates}
\title{transform_matrix_to_dataframe_with_dates}
\usage{
transform_matrix_to_dataframe_with_dates(draw, country_configs, country)
}
\arguments{
\item{draw}{a matrix containing the draws filtered by region, country and variant (so only one of each)}

\item{country_configs}{a list object containing the configuration settings for all of the countries}

\item{country}{a string containing the name of the country you want to filter by}
}
\value{
a dataframe with the added columns
}
\description{
function to transform the draws matrix to a dataframe with each column representing a different date
}
