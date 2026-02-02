get_script_path <- function() {
  cmd <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd, value = TRUE)
  if (length(file_arg) > 0) return(normalizePath(sub("^--file=", "", file_arg)))
  NA_character_
}

script_path <- get_script_path()

if (!is.na(script_path)) {
  root_dir <- normalizePath(file.path(dirname(script_path), "../.."))
} else {
  root_dir <- normalizePath(getwd())
}

source(file.path(root_dir, "R", "utils_api.R"))
source(file.path(root_dir, "R", "search_laws.R"))
source(file.path(root_dir, "R", "get_law_text.R"))
source(file.path(root_dir, "R", "keyword_trend.R"))
source(file.path(root_dir, "R", "plot_keyword_trend.R"))

out_dir <- file.path(root_dir, "exploration", "explore_z", "outputs")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

topic <- "climate"

laws <- search_laws(topic, type = "statute")
print(head(laws, 10))
write.csv(laws, file.path(out_dir, "laws_search_results.csv"), row.names = FALSE)

if (nrow(laws) > 0) {
  one <- laws[1, ]
  txt <- get_law_text(one$type_id, one$law_id)
  print(head(txt, 10))
  write.csv(txt, file.path(out_dir, "one_law_text_sections.csv"), row.names = FALSE)
}

trend <- keyword_trend(topic, from = 2000, to = 2024, type = "statute")
print(head(trend, 10))
write.csv(trend, file.path(out_dir, "keyword_trend_2000_2024.csv"), row.names = FALSE)

p <- plot_keyword_trend(trend, topic)

ggplot2::ggsave(
  filename = file.path(out_dir, "keyword_trend_plot.png"),
  plot = p,
  width = 8,
  height = 4.5
)

p

#########################################
# run log (append)
run_time <- format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")

n_laws <- nrow(laws)
one_title <- if (n_laws > 0) laws$title[1] else ""
one_year <- if (n_laws > 0) laws$year[1] else NA
total_hits <- if (nrow(trend) > 0) sum(trend$hits, na.rm = TRUE) else 0L
peak_year <- if (nrow(trend) > 0) trend$year[which.max(trend$hits)] else NA
peak_hits <- if (nrow(trend) > 0) max(trend$hits, na.rm = TRUE) else 0L

log_path <- file.path(out_dir, "run_log.md")
log_line <- paste0(
  "- ", run_time,
  " | keyword=", topic,
  " | type=statute",
  " | laws=", n_laws,
  " | total_hits=", total_hits,
  " | peak_year=", peak_year,
  " | peak_hits=", peak_hits,
  if (nzchar(one_title)) paste0(" | top_title=\"", gsub("\"", "'", one_title), "\"") else ""
)

if (!file.exists(log_path)) {
  writeLines("# explore_z run log\n", con = log_path)
}
write(log_line, file = log_path, append = TRUE)

# run summary (overwrite)
summary_df <- data.frame(
  run_time = run_time,
  keyword = topic,
  type = "statute",
  n_laws = n_laws,
  total_hits = total_hits,
  peak_year = peak_year,
  peak_hits = peak_hits,
  top_title = one_title,
  top_year = one_year,
  stringsAsFactors = FALSE
)

write.csv(summary_df, file.path(out_dir, "run_summary.csv"), row.names = FALSE)

# session info (overwrite)
sink(file.path(out_dir, "session_info.txt"))
print(sessionInfo())
sink()
