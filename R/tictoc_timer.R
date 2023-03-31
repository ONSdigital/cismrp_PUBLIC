#' @title tictoc_timer
#' @description records the amount of time in minutes from the first tic of the monitored R code to a given toc in the log
#' @param n_toc the toc number you wish to measure the time until
#' @param digits n_digits of precision
#' @param log an unformatted tictoc log
#  @return time taken in minutes from first tic to user input toc
#' @export

tictoc_timer <- function(n_toc = 8, digits = 2, log) {
  if (!all(names(log[[1]]) == c("tic", "toc", "msg"))) {
    stop("log does not appear to be an object returned from `tic.log(format = FALSE)`")
  }

  time_taken <- round(((log[[n_toc]]$toc - log[[1]]$tic) / 60),
    digits = digits
  )
  return(time_taken)
}
