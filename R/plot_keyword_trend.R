#' Plot keyword trend
#'
#' @param trend_data A data.frame returned by keyword_trend().
#' @param keyword Character. The keyword (for plot title).
#'
#' @return Invisibly returns NULL.
#' @export
plot_keyword_trend <- function(trend_data, keyword) {
  if (!all(c("year", "law_type", "count") %in% names(trend_data))) {
    stop("trend_data must have columns: year, law_type, count", call. = FALSE)
  }
  if (!is.character(keyword) || length(keyword) != 1L) {
    stop("keyword must be length-1 character", call. = FALSE)
  }
  if (nrow(trend_data) == 0L) {
    stop("trend_data is empty, nothing to plot", call. = FALSE)
  }

  agg <- aggregate(count ~ year, data = trend_data, sum)
  agg <- agg[order(agg$year), ]

  plot(
    x = agg$year,
    y = agg$count,
    type = "b",
    xlab = "Year",
    ylab = "Number of hits",
    main = paste("Keyword trend for:", keyword)
  )

  cat("Law types in trend_data:\n")
  print(table(trend_data$law_type))

  invisible(NULL)
}
