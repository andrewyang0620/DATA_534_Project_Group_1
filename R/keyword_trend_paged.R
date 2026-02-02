#' Keyword trend for multiple pages
#'
#' @param keyword Character. Search keyword.
#' @param from Integer. Start year
#' @param to Integer. End year
#' @param type Character
#' @param pages Integer. How many pages to try
#' @param page_size Integer.
#'
#' @return
#' @export
keyword_trend_paged <- function(keyword, from, to, type = c("all"), pages = 2L, page_size = 20L) {

  type  <- match.arg(type)
  pages <- as.integer(pages)
  page_size <- as.integer(page_size)

  if (!is.character(keyword) || length(keyword) != 1L) {
    stop("keyword error", call. = FALSE)
  }
  if (!is.numeric(from) || !is.numeric(to) || length(from) != 1L || length(to) != 1L) {
    stop("from/to error", call. = FALSE)
  }

  from <- as.integer(from)
  to   <- as.integer(to)

  if (from > to) {
    stop("from must be <= to", call. = FALSE)
  }

  if (pages < 1L) {
    stop("pages must be >= 1", call. = FALSE)
  }
  if (page_size < 1L) {
    stop("page_size must be >= 1", call. = FALSE)
  }

  all_hits <- list()

  for (i in seq_len(pages)) {
    start <- (i - 1L) * page_size
    end   <- i * page_size

    message("Fetching page ", i, " (s = ", start, ", e = ", end, ") ...")

    doc <- tryCatch(
      search_laws(keyword, start = start, end = end),
      error = function(e) {
        message("  Page ", i, " failed: ", conditionMessage(e))
        return(NULL)
      }
    )

    if (is.null(doc)) {
      message("Stop, error.")
      break
    }

    hits_i <- parse_search_results(doc)

    if (nrow(hits_i) == 0L) {
      message("  Page ", i, " has 0 hits, STOP!!")
      break
    }

    all_hits[[length(all_hits) + 1L]] <- hits_i
  }

  if (length(all_hits) == 0L) {
    return(data.frame(year = integer(), law_type = character(), count = integer(), stringsAsFactors = FALSE))
  }

  hits <- do.call(rbind, all_hits)

  extract_year <- function(x) {
    m <- regexpr("\\[(RSBC|SBC) ([0-9]{4})\\]", x)
    if (m == -1L) return(NA_integer_)
    match_str <- regmatches(x, list(m))[[1]]
    as.integer(sub(".* (\\d{4})\\]", "\\1", match_str))
  }

  years <- vapply(hits$loc, extract_year, integer(1))

  trend <- data.frame(year = years, law_type = hits$law_type, stringsAsFactors = FALSE)

  if (type != "all") {
    trend <- trend[trend$law_type == type, , drop = FALSE]
  }

  trend <- trend[!is.na(trend$year) &
                   trend$year >= from &
                   trend$year <= to,
                 , drop = FALSE]

  if (nrow(trend) == 0L) {
    return(data.frame(year = integer(), law_type = character(), count = integer(), stringsAsFactors = FALSE))
  }

  agg <- aggregate(
    list(count = rep(1L, nrow(trend))),
    by = list(year = trend$year, law_type = trend$law_type),
    FUN = sum
  )

  agg <- agg[order(agg$year, agg$law_type), ]
  rownames(agg) <- NULL
  agg
}
