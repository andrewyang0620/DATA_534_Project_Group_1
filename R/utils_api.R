#' @keywords internal
bc_base_url <- function() {
  "https://www.bclaws.ca/civix"
}

#' @keywords internal
bc_get <- function(path, query = list()) {
  stopifnot(is.character(path), length(path) == 1)

  path <- sub("^/+", "", path)

  req <- httr2::request(bc_base_url()) |>
    httr2::req_url_path_append(path) |>
    httr2::req_url_query(!!!query)

  resp <- httr2::req_perform(req)
  httr2::resp_check_status(resp)
  resp
}