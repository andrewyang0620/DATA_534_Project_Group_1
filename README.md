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

