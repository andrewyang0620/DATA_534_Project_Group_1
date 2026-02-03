test_that("parse_search_results returns empty df when no <doc>", {
  xml <- xml2::read_xml("<root></root>")
  out <- parse_search_results(xml)
  expect_s3_class(out, "data.frame")
  expect_true(all(c("title","law_type","law_id","loc","hits") %in% names(out)))
  expect_equal(nrow(out), 0)
})