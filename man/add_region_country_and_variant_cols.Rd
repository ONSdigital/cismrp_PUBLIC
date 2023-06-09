% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_region_country_and_variant_cols.R
\name{add_region_country_and_variant_cols}
\alias{add_region_country_and_variant_cols}
\title{add_country_and_variant_cols}
\usage{
add_region_country_and_variant_cols(data, region, country, variant)
}
\arguments{
\item{data}{a dataframe containing the data you want to add columns to}

\item{region}{a string contiaining the name of a region you want to set the region column to}

\item{country}{a string contiaining the name of a country you want to set the country column to}

\item{variant}{a string contiaining the name of a variant you want to set the variant column to}
}
\value{
a dataframe with the region, variant and country columns appended
}
\description{
function to add function and variant columns
}
