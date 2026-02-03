# Individual Diary - Jingtao

## 2026-01-19
- Initialized repository for the project.
- Added a `.gitignore` to prevent committing local/temporary artifacts 
- Added project license file to establish redistribution terms early.
- Created an initial `README.md` as the project entry point (basic description + intent).

## 2026-01-22
- Added the project proposal document to the repository (`docs/`), aligning the repo with the DATA 534 deliverable requirements.
- Defined the project goal: build an installable R package that wraps a REST API (BC Laws Civix), focusing on a small but complete workflow.
- Clarified scope and core user stories from the proposal:
  - Search BC laws by keyword via the Civix search endpoint.
  - Parse search results into a tidy structure for downstream analysis.
  - Provide a simple keyword trend over time analysis (by year / law type).
  - Fetch plain-text law content for a given document ID.
- Set expectations for evaluation: prioritize correctness, reproducibility, and clean package mechanics over extra features.

## 2026-01-26
- Initialized the core R package structure for the project, set up the main folders/files
- Added `utils_api.R`, implementing the low-level API helper layer to standardize how the package talks to the BC Laws Civix REST API:
  - Centralized base URL handling and request construction.
  - Prepared reusable request logic to support later search fetch law text, keyword trend.
- Confirmed the package skeleton supports the planned pipeline from the proposal
- Goal: make future feature work incremental so new endpoints can be added without duplicating request code

## 2026-01-27
- Added `exploration/` to store early-stage experiments and scratch work for validating the project idea.
- Used exploration outputs to fine tune the implementation plan from the proposal.
- Goal: prove feasibility before writing more package-facing functions.

## 2026-01-28
- Implemented the low-level API helper layer in `utils_api.R` to support the whole package.
- Added `bc_base_url()` to centralize the base endpoint
- Implemented `bc_get(path, query = list())` as the core request wrapper:
  - Normalized/cleaned the `path` argument (avoid leading `/` issues).
  - Built requests using `httr2::request()` and appended path/query parameters in a consistent way.
  - Executed requests with `httr2::req_perform()` and validated responses with status checks.
- Opened PRs to integrate the helper functions into the main branch
- Result: established a reusable, consistent HTTP request pipeline that later functions (`search_laws()`, `get_law_text()`, keyword trend) can build on.

## 2026-01-29
- Finished the first version of the keyword trend pipeline (`keyword_trend()`), enabling year-based counting of search hits for a given keyword.
- Implemented the search-result parsing logic (`parse_search_results()`):
  - Parsed BC Laws Civix XML search responses into a tidy `data.frame`.
  - Extracted core metadata fields per hit
  - Added safe handling for empty results, return empty structured `data.frame` instead of failing
- Merged the parsing feature branch into main via PR (`feature_parseresult`), ensuring the parser is integrated with the project main workflow.
- Result: established a workflow that later visualization and paging functions can build on.

## 2026-01-31
- Completed the end-to-end law keyword trend workflow:
  - Finalized the “trend collection” step to compute keyword hit counts over time (by year and/or law type).
  - Added the visualization step to display the trend results as a time-series style plot (trend over years).
- Validated the full pipeline works in sequence:
  - search, parse, aggregate trend table, generate plot.
- Result: project now produces a usable analytical output (trend table + visualization) instead of only raw API responses.

## 2026-02-01
- Added an optional AI summary feature:
  - Implemented `ai_summary` functionality to generate short natural-language summaries from fetched law text / trend outputs
  - Integrated it so it can be called as an optional step
- Implemented multi-page keyword search support:
  - Finished `keyword_trend_paged()` to fetch multiple pages of search results instead of only the first page.
  - Aggregated results across pages to produce a more complete and stable keyword trend table.
- Quick check:
  - Verified paged search returns more hits than single-page search for common keywords.
  - Confirmed the new paged trend output still works with the existing plotting / reporting functions.


## 2026-02-02
- Finalized package DESCRIPTION, license:
  - Filled in `DESCRIPTION` fields (Package, Title, Version, Authors@R, Imports/Suggests).
  - Added MIT + file LICENSE setup
  - Ran `devtools::document()` / `devtools::check()` iteratively and fixed DESCRIPTION formatting issues until package build/check succeeded.

- Added vignettes for complete user-facing documentation:
  - Created a getting-started vignette showing an end-to-end workflow:
    - search, parse results, keyword trend, plot, fetch law text
  - Ensured vignette code blocks run cleanly under package context

- Set up CI pipeline:
  - Added a workflow to automatically run R CMD check / tests on pushes and pull requests.
  - Verified the workflow runs successfully on the `dev` branch
  - This ensures the package remains installable and checkable across environments as development continues.
