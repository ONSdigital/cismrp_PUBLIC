test_that("tictoc_timer rounds to correct precision", {
  test_log <- list(
    list(
      tic = 100,
      toc = 100,
      msg = "start"
    ),
    list(
      tic = 160.526,
      toc = 160.526,
      msg = "toc 2"
    )
  )
  expect_equal(tictoc_timer(log = test_log, n_toc = 2, digits = 0), 1)
  expect_equal(tictoc_timer(log = test_log, n_toc = 2, digits = 2), 1.01)
  expect_equal(tictoc_timer(log = test_log, n_toc = 2, digits = 3), 1.009)
})

test_that("tictoc_timer errors if not given a list returned from `tic.log(format = FALSE)", {
  test_log <- list(list("a" = 1))
  expect_error(
    tictoc_timer(log = test_log, n_toc = 2, digits = 0),
    "log does not appear to be an object returned from"
  )
})

test_that("tictoc_timer returns time elapsed to the requested n_toc", {
  test_log <- list(
    list(
      tic = 100,
      toc = 100,
      msg = "start"
    ),
    list(
      tic = 160.526,
      toc = 160.526,
      msg = "toc 2"
    ),
    list(
      tic = 180.526,
      toc = 190.526,
      msg = "toc 3"
    )
  )
  expect_equal(tictoc_timer(log = test_log, n_toc = 2, digits = 2), 1.01)
  expect_equal(tictoc_timer(log = test_log, n_toc = 3, digits = 2), 1.51)
})
