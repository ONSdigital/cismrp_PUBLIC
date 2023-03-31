#' @title Theme CIS
#'
#' @description a pre-set theme for all CIS ggplots (aligned with government dissemination team)
#'
#' @return silent
#'
#' @export

theme_CIS <- function() {
  ggplot2::theme(
    legend.text = ggplot2::element_text(size = 15),
    legend.title = ggplot2::element_text(size = 17),
    plot.title = ggplot2::element_text(size = 15),
    axis.text = ggplot2::element_text(size = 15),
    axis.title = ggplot2::element_text(size = 15),
    axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5, b = 10)),
    axis.line.y = ggplot2::element_blank(),
    axis.line.x = ggplot2::element_line(colour = "black"),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb"),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.background = ggplot2::element_blank(),
    strip.background = ggplot2::element_rect(fill = "white"),
    strip.text = ggplot2::element_text(size = 12)
  )
}
