#' Keyword trend of BC laws
#'
#' Count how many search hits a keyword has per year and law type.
#'
#' @param keyword Character. Search keyword.
#' @param from Integer. Start year (e.g. 1990).
#' @param to Integer. End year (e.g. 2025).
#' @param type Character. One of "all", "statute", "statreg".
#'
#' @return A data.frame with columns: year, law_type, count.
#' @export
keyword_trend <- function(keyword,
                          from,
                          to,
                          type = c("all", "statute", "statreg")) {

  type <- match.arg(type)

  if (!is.character(keyword) || length(keyword) != 1L) {
    stop("keyword must be length-1 character", call. = FALSE)
  }
  if (!is.numeric(from) || !is.numeric(to) || length(from) != 1L || length(to) != 1L) {
    stop("from/to must be length-1 numeric", call. = FALSE)
  }

  from <- as.integer(from)
  to   <- as.integer(to)

  if (from > to) {
    stop("from must be <= to", call. = FALSE)
  }

  xml  <- search_laws(keyword, start = 0, end = 200)
  hits <- parse_search_results(xml)

  if (nrow(hits) == 0L) {
    return(data.frame(
      year     = integer(),
      law_type = character(),
      count    = integer(),
      stringsAsFactors = FALSE
    ))
  }

  extract_year <- function(x) {
    m <- regexpr("(19|20)[0-9]{2}", x)
    if (m == -1L) return(NA_integer_)
    as.integer(substr(x, m, m + attr(m, "match.length") - 1L))
  }

  years <- vapply(hits$loc, extract_year, integer(1))

  trend <- data.frame(
    year     = years,
    law_type = hits$law_type,
    stringsAsFactors = FALSE
  )

  if (type != "all") {
    trend <- trend[trend$law_type == type, , drop = FALSE]
  }

  trend <- trend[!is.na(trend$year) & trend$year >= from & trend$year <= to, , drop = FALSE]

  if (nrow(trend) == 0L) {
    return(data.frame(
      year     = integer(),
      law_type = character(),
      count    = integer(),
      stringsAsFactors = FALSE
    ))
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
