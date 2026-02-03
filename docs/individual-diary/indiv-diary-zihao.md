# Individual Diary — Zihao

## 2026-01-28
- Created an exploration script that can run from anywhere by auto-detecting the project root directory.
- Sourced core R functions: `utils_api.R`, `search_laws.R`, `get_law_text.R`, `keyword_trend.R`, and `plot_keyword_trend.R`.
- Ran an end-to-end exploration workflow for keyword `"climate"`:
  - called `search_laws(topic, type="statute")` and saved results to `laws_search_results.csv`
  - fetched one law’s text via `get_law_text(one$type_id, one$law_id)` and saved to `one_law_text_sections.csv`
  - computed keyword trend `keyword_trend(topic, from=2000, to=2024, type="statute")`
  - plotted trend and saved image `keyword_trend_plot.png` via `ggplot2::ggsave()`

## 2026-01-30
- Appended an automated run log section to the exploration script:
  - recorded `run_time`, `keyword`, `type`, number of laws returned, total hits, peak year, peak hits, and top law title
  - wrote/updated `run_log.md`, `run_summary.csv` (overwrite), and `session_info.txt` (overwrite)
- Made the exploration run reproducible by capturing session info and saving standardized outputs per run.

## 2026-02-01
- Explored how `start/end` parameters affect `search_laws()` result count and stability across multiple keywords (ad-hoc testing in R console, not saved in e1.R).
- Checked whether result ordering is consistent for repeated calls to support reproducible examples in README.

## 2026-02-02
- Drafted/updated README usage examples covering the package's main workflow:
  - search, parse results, inspect columns
  - keyword trend across pages via `keyword_trend_paged()` and plotting with `plot_keyword_trend()`
  - fetch full law text with `get_law_text()` using IDs from search hits
- Reviewed and refined documentation to ensure examples are clear and reproducible.
