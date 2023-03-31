#' @title attach_external_libraries
#' @description This function attaches magittr, ggplot2 and patchwork to the namespace
#' @return None
#' @export

attach_external_libraries <- function() {
  requireNamespace("magrittr",
    mask.ok = list(testthat = c(
      "equals",
      "is_less_than",
      "not"
    ))
  )
  requireNamespace("ggplot2")
}
