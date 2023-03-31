test_that("magrittr is attached to the namespace", {
  attach_external_libraries()
  expect_true(isNamespaceLoaded("magrittr"))
})

test_that("ggplot2 is attached to the namespace", {
  attach_external_libraries()
  expect_true(isNamespaceLoaded("ggplot2"))
})
