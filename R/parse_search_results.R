#' Parse BC Laws search results
#'
#' @param xml_doc An xml_document returned by search_laws().
#' @return A data.frame with one row per search hit.
#' @keywords internal
parse_search_results <- function(xml_doc) {
  if (!inherits(xml_doc, "xml_document")) {
    stop("xml_doc must be xml_document", call. = FALSE)
  }

  docs <- xml2::xml_find_all(xml_doc, "//doc")

  if (length(docs) == 0L) {
    return(data.frame(
      title    = character(),
      law_type = character(),
      law_id   = character(),
      loc      = character(),
      hits     = integer(),
      stringsAsFactors = FALSE
    ))
  }

  get_child_text <- function(node, name) {
    child <- xml2::xml_find_first(node, paste0("./", name))
    if (inherits(child, "xml_missing")) {
      return(NA_character_)
    }
    xml2::xml_text(child)
  }

  title <- vapply(
    docs,
    get_child_text,
    character(1),
    name = "CIVIX_DOCUMENT_TITLE"
  )

  law_id <- vapply(
    docs,
    get_child_text,
    character(1),
    name = "CIVIX_DOCUMENT_ID"
  )

  law_type <- vapply(
    docs,
    get_child_text,
    character(1),
    name = "CIVIX_INDEX_ID"
  )

  loc <- vapply(
    docs,
    get_child_text,
    character(1),
    name = "CIVIX_DOCUMENT_LOC"
  )

  hits <- as.integer(xml2::xml_attr(docs, "hits"))

  data.frame(
    title    = title,
    law_type = law_type,
    law_id   = law_id,
    loc      = loc,
    hits     = hits,
    stringsAsFactors = FALSE
  )
}
