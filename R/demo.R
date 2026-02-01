#' Demo
#' @param keyword Character. Search keyword.
#' @param from Integer. Start year.
#' @param to Integer. End year.
#' @param type Character. all, statute, statreg.
#' @param use_ai t/f
#'
#' @return Invisibly returns the trend data frame.
#' @export
demo_keyword_trend <- function(keyword, from = 1990, to = 2025, type = c("all", "statute", "statreg"), use_ai = FALSE) {

  type <- match.arg(type)

  cat("Keyword:", keyword, "\n")
  cat("Years:", from, "to", to, "\n")
  cat("Type:", type, "\n\n")

  cat("Getting keyword trend...\n")
  trend <- keyword_trend(keyword, from = from, to = to, type = type)

  if (nrow(trend) == 0L) {
    cat("No results\n")
    return(invisible(trend))
  }

  cat("Trend data (first rows):\n")
  print(head(trend))
  cat("\n")

  cat("Plotting keyword trend...\n")
  plot_keyword_trend(trend, keyword)

#   if (isTRUE(use_ai)) {
#     cat("[3/3] Getting AI summary...\n")
#     summary_txt <- summarize_keyword_trend(trend, keyword)
#     cat("\n=== AI summary ===\n")
#     cat(summary_txt, "\n")
#   } else {
#     cat("[3/3] Skipping AI summary (use_ai = FALSE).\n")
#   }

  invisible(trend)
}
