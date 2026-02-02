#' @keywords internal
`%||%` <- function(a, b) if (!is.null(a)) a else b

#' @keywords internal
extract_responses_text <- function(out) {
  if (!is.null(out$output_text) && is.character(out$output_text) && nzchar(out$output_text)) {
    return(out$output_text)
  }

  if (!is.null(out$error)) {
    msg <- out$error$message %||% "OpenAI API error"
    stop(msg, call. = FALSE)
  }

  if (is.null(out$output) || !is.list(out$output)) {
    stop("No output in response JSON", call. = FALSE)
  }

  texts <- character(0)

  for (item in out$output) {
    if (!is.list(item)) next
    if (!identical(item$type, "message")) next
    if (is.null(item$content) || !is.list(item$content)) next

    for (citem in item$content) {
      if (!is.list(citem)) next
      if (identical(citem$type, "output_text") && is.character(citem$text) && nzchar(citem$text)) {
        texts <- c(texts, citem$text)
      }
    }
  }

  if (length(texts) > 0) return(paste(texts, collapse = "\n"))

  stop(
    "No assistant output_text found in output",
    call. = FALSE
  )
}

#' @keywords internal
call_openai_responses <- function(input, model = "gpt-5.2", timeout_sec = 60, debug = FALSE) {
  key <- Sys.getenv("OPENAI_API_KEY")
  if (identical(key, "")) stop("OPENAI_API_KEY is not set.", call. = FALSE)

  req <- httr2::request("https://api.openai.com/v1/responses") |>
    httr2::req_headers(
      Authorization = paste("Bearer", key),
      `Content-Type` = "application/json"
    ) |>
    httr2::req_body_json(list(
      model = model,
      input = input
    )) |>
    httr2::req_timeout(timeout_sec)

  resp <- httr2::req_perform(req)

  httr2::resp_check_status(resp)

  out <- httr2::resp_body_json(resp, simplifyVector = FALSE)

  if (isTRUE(debug)) {
    str(out, max.level = 4)
  }

  extract_responses_text(out)
}

#' OpenAI summary for keyword trend
#'
#' @param trend data.frame with columns year, law_type, count
#' @param keyword Character scalar
#' @param from Integer-ish scalar
#' @param to Integer-ish scalar
#' @param type Character scalar
#' @param model Character. OpenAI model name.
#' @param max_rows Integer. Max rows included in the prompt.
#' @return Character scalar summary text.
#' @export
summarize_keyword_trend <- function(
  trend,
  keyword,
  from = NA_integer_,
  to = NA_integer_,
  type = NA_character_,
  model = "gpt-5-mini",
  max_rows = 250L
) {
  if (!is.data.frame(trend)) stop("trend must be a data.frame", call. = FALSE)
  if (!all(c("year", "law_type", "count") %in% names(trend))) {
    stop("trend must have columns: year, law_type, count", call. = FALSE)
  }
  if (!is.character(keyword) || length(keyword) != 1L) stop("keyword error", call. = FALSE)
  if (nrow(trend) == 0L) return("No results.")

  trend <- trend[order(trend$year, trend$law_type), , drop = FALSE]
  max_rows <- as.integer(max_rows)
  if (nrow(trend) > max_rows) trend <- trend[seq_len(max_rows), , drop = FALSE]
  trend_txt <- paste(capture.output(print(trend, row.names = FALSE)), collapse = "\n")

  meta <- c(
    paste0("Keyword: ", keyword),
    if (!is.na(from) && !is.na(to)) paste0("Years: ", as.integer(from), "-", as.integer(to)) else NULL,
    if (!is.na(type) && nzchar(type)) paste0("Type filter: ", type) else NULL
  )

  prompt <- paste(
    "You are summarizing BC Laws keyword search trends.",
    "Input is a table with columns: year, law_type, count. law_type may include statute, statreg, psl, etc.",
    "",
    "Write in English. Requirements:",
    "- 6-10 bullet points summarizing trend (peaks, changes, gaps).",
    "- Briefly explain how law_type affects interpretation.",
    "- Give 2-3 plausible hypotheses using 'may/might' (do NOT invent specific events or bills).",
    "- Suggest next verification steps (more pages, split by law_type, sample original texts).",
    "- Keep total length 150-250 words.",
    "",
    paste(meta, collapse = "\n"),
    "",
    "Data:",
    trend_txt,
    sep = "\n"
  )

  call_openai_responses(prompt, model = model)
}