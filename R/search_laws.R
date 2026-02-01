#' Search BC laws
#'
#' @param query_string Character. Search keywords.
#' @param start Integer. Start index of results.
#' @param end Integer. End index of results.
#' @param n_frag Integer. Number of text fragments per hit.
#' @param l_frag Integer. Max length of each fragment.
#'
#' @return An xml_document (or html_document) with raw search results.
#' @export
search_laws <- function(query_string, start = 0, end = 20, n_frag = 5, l_frag = 100) {

  if (!is.character(query_string) || length(query_string) != 1L) {
    stop("query_string error", call. = FALSE)
  }
  if (!is.numeric(start) || length(start) != 1L) {
    stop("start error", call. = FALSE)
  }
  if (!is.numeric(end) || length(end) != 1L) {
    stop("end error", call. = FALSE)
  }

  resp <- bc_get(
    path  = "search/complete/fullsearch",
    query = list(
      q     = query_string,
      s     = as.integer(start),
      e     = as.integer(end),
      nFrag = as.integer(n_frag),
      lFrag = as.integer(l_frag)
    )
  )

  body <- httr2::resp_body_string(resp)
  doc <- tryCatch(
    xml2::read_xml(body),
    error = function(e) {
      xml2::read_html(body)
    }
  )

  doc
}
