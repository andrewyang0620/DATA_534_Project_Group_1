# bclaws

BC Laws Civix REST API wrapper for R.  
This package provides a small set of functions to **search BC laws**, **parse search results**, **compute simple keyword trends over time**, and **fetch plain-text law content**.

> Course project for **DATA 534** (R package wrapping a REST API).

---

## Features

- **Search** BC Laws using the Civix endpoint (`search_laws()`)
- **Parse** raw search XML into a tidy `data.frame` (`parse_search_results()`)
- **Keyword trend** summary by year / law type (`keyword_trend()`, `keyword_trend_paged()`)
- **Plot** keyword trends (`plot_keyword_trend()`)
- **Fetch full text** for a given law (`get_law_text()`)
- **AI summary generation** for a given law (`summarize_keyword_trend()`)

---

## Installation

Run from the folder that contains `DESCRIPTION`:

```r
install.packages("devtools")
devtools::install(".")
library(bclaws)
```


## Quick start

### 1. Search and parse results
```r
library(bclaws)

doc  <- search_laws("tax", start = 0, end = 20)
hits <- parse_search_results(doc)

head(hits, 5)
```

hits columns:
- title
- law_type
- law_id
- loc
- hits

### 2. Keyword trend + plot
```r
trend <- keyword_trend_paged(
  keyword   = "tax",
  from      = 1990,
  to        = 2025,
  type      = "all",
  pages     = 10,
  page_size = 20
)

head(trend, 10)

plot_keyword_trend(trend, keyword = "tax")
```

This produces a simple time-series plot of total hits per year (aggregated across law types unless you filter with type).

### 3. Fetch full text of a law
Pick a document from search hits:
```r
doc  <- search_laws("income tax", start = 0, end = 20)
hits <- parse_search_results(doc)

law_type <- hits$law_type[1]
law_id   <- hits$law_id[1]

txt <- get_law_text(law_type, law_id)
substr(txt, 1, 600)
```

