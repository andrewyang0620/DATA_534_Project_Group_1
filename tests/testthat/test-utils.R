test_that("%||% works", {
  expect_equal(`%||%`(NULL, 1), 1)
  expect_equal(`%||%`("a", "b"), "a")
})