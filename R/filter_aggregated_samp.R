#### FILTER AGGREGATED SAMP ####
#
#  1 filter_aggregated_samp
#
#    1.1 filter_sample_by_country_region_variant_date
#
#      1.1.1 create_result_by_variant
#
#      1.1.2 filter_days_with_no_returns
#
#### End of contents ####

#' @title filter_aggregated_sample
#'
#' @description filters and cleans the whole uk aggregated sample into DAs and England samples
#'
#' @param aggregated_sample cleaned aggregated_sample to be filtered for the country x variant models to be fitted
#' @param country_configs a list of country configs
#' @param country_list A list of the four UK countries, England, Scotland, Wales and Northern_Ireland
#' @param variant_list a list of the variant 1,2,4,5
#'
#' @export

# this function reads cal study day, so only needs to be amended if we change the name of the calc study day function
filter_aggregated_samp <- function(aggregated_sample,
                                   country_configs,
                                   country_list,
                                   variant_list) {
  filtered_aggregates_list <- purrr::map2(
    .x = country_list,
    .y = variant_list,
    .f = filter_sample_by_country_region_variant_date,
    aggregated_sample,
    country_configs
  )

  names(filtered_aggregates_list) <- paste0(country_list, variant_list)

  return(filtered_aggregates_list)
}

#' @title filter_sample_by_country_and_region
#'
#' @description filters and cleans by country, by dates, by variants and filters days with no returns
#'
#' @param country a string containing the name of a country you want to filter by
#' @param variant a numeric containing the variant you want to filter by
#' @param aggregated_sample cleaned aggregated_sample to be filtered for the country x variant models to be fitted
#' @param country_configs a list of country configs

filter_sample_by_country_region_variant_date <- function(country,
                                                         variant,
                                                         aggregated_sample,
                                                         country_configs) {
  aggregated_sample %>%
    filter_by_country(country) %>%
    filter_dates(country_configs, country) %>%
    create_result_by_variant(variant) %>%
    filter_days_with_no_returns() %>%
    dplyr::select(study_day, region, sex, lab_id, age_group, n_neg, result) %>%
    dplyr::arrange(study_day, region, sex, age_group, lab_id)
}

#' @title create result by variant
#'
#' @description create result column by variant type
#'
#' @param data a dataframe containing variant_type, n_pos, n_ctpattern[4,5,6,7]
#' @param variant_type integer should be 1, 2, 4 or 5
#'
#' @return data frame

create_result_by_variant <- function(data, variant_type) {
  assertthat::assert_that(
    variant_type %in% c(1, 2, 4, 5),
    msg = "unexpected input - variant type should be 1, 2, 4 or 5"
  )

  data %>%
    dplyr::mutate(
      result = dplyr::case_when(
        variant_type == 1 ~ n_pos,
        variant_type == 2 ~ n_ctpattern4,
        variant_type == 4 ~ n_ctpattern7 + n_ctpattern5 + n_ctpattern6,
        variant_type == 5 ~ n_pos - n_ctpattern4 - n_ctpattern7 - n_ctpattern5 - n_ctpattern6
      )
    )
}

#' @title filter days with no returns
#'
#' @description filter test results to remove those with no returns
#'
#' @param data a dataframe which could contain days with no returns

filter_days_with_no_returns <- function(data) {
  data %>%
    dplyr::filter((n_pos + n_neg) != 0)
}
