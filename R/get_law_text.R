get_law_text <- function(law_type, law_id) {

  if (!is.character(law_type) || !is.character(law_id)) {
    stop("law_type and law_id must be character")
  }

  base_url <- "https://www.bclaws.gov.bc.ca/civix/document/id/complete"
  law_url <- paste(base_url, law_type, law_id, sep = "/")

  doc <- xml2::read_html(law_url)

  text <- xml2::xml_text(doc)
  text <- gsub("\\s+", " ", text)
  text <- trimws(text)

  text
}

