# tuikr Package Development

This file provides guidance to Claude Code when working on the tuikr package.

## Package Overview

**tuikr** - R package for downloading data files and database URLs from TUIK (Turkish Statistical Institute).

**Core functionality:**
- Extract statistical tables from TUIK web portal
- Access database endpoints
- Download geographic data from statistics portal

**Key dependencies:** tidyverse ecosystem (dplyr, purrr, tidyr), web scraping (rvest, xml2, crul), spatial (sf)

## Mandatory Code Standards (r/anti-slop)

### Namespacing - Always Explicit
```r
# CORRECT - Always use ::
filtered_data <- dplyr::filter(data, condition)
processed <- purrr::map(list, rvest::html_text)

# WRONG - Never rely on imports
filtered_data <- filter(data, condition)  # ❌
processed <- map(list, html_text)  # ❌
```

### Returns - Always Explicit
```r
# CORRECT
get_tuik_data <- function(url) {
  response <- crul::HttpClient$new(url)$get()
  return(response$parse("UTF-8"))
}

# WRONG
get_tuik_data <- function(url) {
  response <- crul::HttpClient$new(url)$get()
  response$parse("UTF-8")  # ❌ implicit return
}
```

### Naming - Descriptive snake_case
```r
# CORRECT - Domain-specific, descriptive names
survey_data <- download_survey(url)
geographic_boundaries <- extract_boundaries(response)
table_metadata <- parse_metadata(html_content)

# WRONG - Generic, vague names
df <- download_survey(url)  # ❌
data <- extract_boundaries(response)  # ❌
result <- parse_metadata(html_content)  # ❌
temp <- process_response(x)  # ❌
final <- cleanup(temp)  # ❌
```

**Forbidden variable names:**
- `df`, `data`, `result`, `output`
- `temp`, `tmp`, `final`
- `x`, `y` (except in mathematical contexts)
- `obj`, `item`, `thing`

**Good naming patterns for tuikr:**
- `*_data` for data frames (e.g., `survey_data`, `population_data`)
- `*_urls` for URL vectors
- `*_response` for HTTP responses
- `*_metadata` for extracted metadata
- `*_boundaries` for geographic data

### Pipes - Native and Manageable
```r
# CORRECT - Native pipe, reasonable length
survey_urls <- html_response |>
  rvest::html_elements(".table-link") |>
  rvest::html_attr("href") |>
  purrr::map_chr(build_full_url) |>
  return()

# If pipe exceeds 8 operations, break into steps
raw_response <- fetch_tuik_page(url)
table_elements <- extract_table_elements(raw_response)
cleaned_data <- process_table_data(table_elements)
return(cleaned_data)

# WRONG - magrittr pipe
survey_urls <- html_response %>%  # ❌
  html_elements(".table-link")
```

### Package Structure
- No `library()` calls in R/ code - only `::` for dependencies
- All imports declared in DESCRIPTION
- Use `@importFrom` sparingly in roxygen2 (prefer `::`)

## Documentation Standards (text/anti-slop + elements-of-style)

### Roxygen2 - Direct and Concrete

**Function descriptions:**
```r
# CORRECT - Active voice, starts with verb
#' Downloads survey data from TUIK web portal
#'
#' Fetches statistical tables by survey ID and returns structured data.
#'
#' @param survey_id Character string. TUIK survey identifier.
#' @param year Integer. Survey year (1990-2024).
#' @return Data frame with survey responses and metadata.

# WRONG - Passive voice, circular, vague
#' Function to download survey data
#'
#' This function can be used to download data from TUIK. It will allow you
#' to easily access various statistical tables.
#'
#' @param survey_id A character string that contains the survey ID
#' @param year A numeric value representing the year
#' @return Returns a data frame with the data
```

**Parameter documentation:**
```r
# CORRECT - Specific, direct
#' @param url Character vector. Full TUIK database URLs.
#' @param encoding Character string. Default "UTF-8".

# WRONG - Verbose, hedging
#' @param url A character vector that contains the URLs you want to download
#' @param encoding Optional encoding parameter (typically UTF-8)
```

### README and Vignettes - Concrete and Active

**Principles (Strunk's Elements of Style):**
- **Rule 10**: Active voice ("extracts data" not "data is extracted")
- **Rule 11**: Positive form ("use X" not "avoid Y")
- **Rule 12**: Concrete language (specific examples, no abstractions)
- **Rule 13**: Omit needless words

**Opening sections:**
```r
# CORRECT - Shows what it does
## Installation
install.packages("tuikr")

## Usage
library(tuikr)

# Download population statistics
population_data <- get_tuik_table(survey_id = "1602")

# WRONG - Meta-commentary and filler
## Getting Started
This package allows you to easily work with TUIK data. In this guide,
we'll explore how to navigate the various features...
```

**Remove these patterns:**
- "This vignette will show you..."
- "In order to download data..."
- "It's important to note that..."
- "Let's explore how to..."
- "delve into", "navigate", "dive deep"

**Vignette structure:**
```markdown
# Working with Geographic Data

Download administrative boundaries from TUIK's geo portal:

(code example)

## Boundary Types

TUIK provides three levels...

(specific examples for each)
```

NOT:
```markdown
# Introduction

This vignette explores the geographic data functionality...

## Getting Started

Before we delve into the details, it's important to note...
```

## Testing Standards

### Test naming and structure
```r
# CORRECT - Descriptive test names
test_that("get_tuik_table() returns data frame with required columns", {
  survey_data <- get_tuik_table("1602")
  expect_s3_class(survey_data, "data.frame")
  expect_true("year" %in% colnames(survey_data))
})

# WRONG - Generic names
test_that("function works", {  # ❌
  df <- get_tuik_table("1602")  # ❌
  expect_true(is.data.frame(df))
})
```

## Quality Checks Before Committing

### Run detection scripts
```bash
# Check R code for slop patterns
Rscript ~/Workspace/eer-skills/toolkit/scripts/detect_slop.R R/ --verbose

# Check documentation for slop patterns
python ~/Workspace/eer-skills/toolkit/scripts/detect_slop.py README.md --verbose
python ~/Workspace/eer-skills/toolkit/scripts/detect_slop.py vignettes/*.Rmd --verbose
```

**Target score:** < 20 (low slop)

### Before submitting PR or release
1. Run `devtools::check()` - must pass with 0 errors, 0 warnings
2. Run slop detection on all modified files
3. Check that documentation follows text/anti-slop standards
4. Verify all examples run successfully
5. Confirm test coverage is maintained

## Common Workflows

### Adding a new function
1. Write function in R/ following r/anti-slop standards
2. Add roxygen2 documentation (apply text/anti-slop)
3. Run `devtools::document()`
4. Write tests in tests/testthat/
5. Run `Rscript ~/Workspace/eer-skills/toolkit/scripts/detect_slop.R R/new_file.R --verbose`
6. Fix any issues if score > 20
7. Run `devtools::test()`

### Updating README or vignettes
1. Draft content
2. Apply text/anti-slop manually:
   - Remove filler phrases and transitions
   - Remove meta-commentary
   - Use active voice
3. Apply elements-of-style principles:
   - Concrete, specific language
   - Omit needless words
   - Positive form
4. Run `python ~/Workspace/eer-skills/toolkit/scripts/detect_slop.py <file.md> --verbose`
5. If score > 20: `python ~/Workspace/eer-skills/toolkit/scripts/clean_slop.py <file.md> --save`
6. Review cleaned output and refine

### Refactoring existing code
1. Read current implementation
2. Identify r/anti-slop violations:
   - Missing `::`
   - Implicit returns
   - Generic names (df, data, result)
3. Refactor incrementally
4. Run tests after each change
5. Verify with detection script

## Package-Specific Context

### TUIK terminology
Use consistent, domain-appropriate terms:
- "survey" not "questionnaire" or "form"
- "statistical table" not "data table" or "results"
- "geographic boundaries" not "shapes" or "polygons"
- "metadata" not "info" or "details"

### Common operations naming
- `get_*()` for download/fetch operations
- `extract_*()` for parsing operations
- `parse_*()` for transformation operations
- `build_*()` for URL/path construction

### Error messages
Be specific about what failed and why:
```r
# CORRECT
stop("Survey ID '", survey_id, "' not found in TUIK database")

# WRONG
stop("Invalid input")  # ❌
stop("Error occurred")  # ❌
```

## Notes for Claude

When working on tuikr:
- This is a web scraping package - expect brittle code that may break with TUIK website changes
- Geographic data handling requires sf package - use sf:: explicitly
- HTTP operations use crul - always handle timeouts and errors
- Apply r/anti-slop standards automatically, not just when asked
- For documentation, apply both text/anti-slop and elements-of-style principles
- Run detection scripts proactively before marking work complete
