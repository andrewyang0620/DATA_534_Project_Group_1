# Individual Diary — Yiran

## 2026-01-27
- Explored BC Laws document page structure to see how section titles, section numbers, and body text could be parsed reliably.
- Compared full-page text extraction vs DOM-based section extraction approaches.

## 2026-01-28
- Implemented `get_law_text(law_type, law_id)` in R.
- Added input validation for `law_type` and `law_id` (must be character).
- Built BC Laws document URL (`.../civix/document/id/complete/{law_type}/{law_id}`).
- Fetched and parsed the page with `xml2::read_html()`.
- Extracted text with `xml2::xml_text()`, normalized whitespace, and trimmed.

## 2026-01-30
- Wrote an exploration markdown clarifying:
  - project goal and user-facing workflow
  - scope and limitations (what the package will / will not support)
  - key design priorities (simplicity, reproducibility, stable API wrapping)
- Outcome: aligned implementation decisions with DATA 534 rubric expectations

## 2026-01-31
- Explored testing strategy for web-dependent functions (unit tests for parsing logic vs integration tests for live requests).
- Identified a plan to use cached HTML fixtures for stable parsing tests.

## 2026-02-01
- Added a Conceptual Workflow Exploration markdown section.
- Drafted a conceptual R usage example (not implemented/executed) for a tidy workflow.

## 2026-02-02
- Creating testcases for the package.
- Include `test-parse_search_results.R` to test the XML parsing function with various scenarios.
- Include `test-utils.R` to test the API utility functions for correct request construction and error handling.
- Using `testthat` framework for structured testing.
- Goal: ensure core functions behave as expected and handle edge cases gracefully.