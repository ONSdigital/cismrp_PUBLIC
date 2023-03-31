#' @title Add region facet to plots
#'
#' @description Add facets of regions when specified by region_or_country
#'
#' @param plot plot already made
#'
#' @param region_or_country specify "country" for one ggplot object of data from an individial country, specify "region" for ggplot object of England regions
#'
#' @return a ggplot object
#'
#' @export

add_region_or_country_layer <- function(plot, region_or_country) {
  if (region_or_country == "region") {
    plot_by_region <- plot +
      ggplot2::facet_wrap(~region, scales = "fixed") +
      ggplot2::theme(axis.text = ggplot2::element_text(size = 10))
    return(plot_by_region)
  } else {
    return(plot)
  }
}
