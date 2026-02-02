#' Get full text of a BC law
#'
#' @param law_type Character
#' @param law_id Character
#' @return Character scalar containing the plain text of the law
#' @param collapse_whitespace Logical. If TRUE, collapse whitespace to single spaces.
#' @export    
get_law_text <- function(law_type, law_id, collapse_whitespace = TRUE) {
  if (!is.character(law_type) || length(law_type) != 1L) {
    stop("law_type error", call. = FALSE)
  }
  if (!is.character(law_id) || length(law_id) != 1L) {
    stop("law_id error", call. = FALSE)
  }

  path <- paste("document/id/complete", law_type, law_id, sep = "/")

  resp <- bc_get(path = path)

  html <- httr2::resp_body_string(resp)
  doc  <- xml2::read_html(html)

  full_text <- xml2::xml_text(doc)
  if (grepl("404 error", full_text, ignore.case = TRUE)) {
    stop(
      "404 page for this law_type / law_id. ",
      "Please check that the identifier exists on BC Laws.",
      call. = FALSE
    )
  }

  main_node <- xml2::xml_find_first(doc, "//*[@id='contentsscroll']")
  if (inherits(main_node, "xml_missing")) {
    main_node <- doc
  }

  text <- xml2::xml_text(main_node)

  if (isTRUE(collapse_whitespace)) {
    text <- gsub("\\s+", " ", text)
    text <- trimws(text)
  }

  text
}
