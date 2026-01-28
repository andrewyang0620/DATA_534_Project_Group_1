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
