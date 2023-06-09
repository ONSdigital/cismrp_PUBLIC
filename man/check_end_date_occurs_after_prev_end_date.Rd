% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_main_config.R
\name{check_end_date_occurs_after_prev_end_date}
\alias{check_end_date_occurs_after_prev_end_date}
\title{check_end_date_occurs_after_prev_end_date}
\usage{
check_end_date_occurs_after_prev_end_date(config)
}
\arguments{
\item{config}{- a list object containing the configurations for the system}
}
\value{
errors if any country end date occurs before the previous end date
}
\description{
checking end date occurs after the previous end date across all countries
}
