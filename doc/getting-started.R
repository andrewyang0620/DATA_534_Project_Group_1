## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE,
  error = TRUE
)

## -----------------------------------------------------------------------------
library(bclaws)

## -----------------------------------------------------------------------------
doc <- search_laws("tax", 0, 20)
hits <- parse_search_results(doc)
head(hits, 5)

## -----------------------------------------------------------------------------
trend <- keyword_trend_paged(
  keyword   = "tax",
  from      = 1990,
  to        = 2025,
  type      = "all",
  pages     = 30,
  page_size = 20
)
utils::head(trend, 10)

## -----------------------------------------------------------------------------
if (is.data.frame(trend) && nrow(trend) > 0) {
  plot_keyword_trend(trend, "tax")
} else {
  cat("Trend empty.\n")
}

## -----------------------------------------------------------------------------
if (is.data.frame(hits) && nrow(hits) > 0) {
  first <- hits[1, ]
  txt <- get_law_text(first$law_type, first$law_id)
  substr(txt, 1, 500)
} else {
  cat("No hits; skip full-text fetch.\n")
}

## ----eval=FALSE---------------------------------------------------------------
# # # requires OPENAI_API_KEY:
# # summary_txt <- summarize_keyword_trend(trend, "tax", from=1990, to=2025, type="all")
# # cat(summary_txt)

