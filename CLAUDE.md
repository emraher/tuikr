# CLAUDE.md


This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`tuikR` is an R package for accessing Turkish Statistical Institute (TUIK) data. It provides functions to:
- Extract data file and database URLs from https://data.tuik.gov.tr/
- Download geographic statistical data from https://cip.tuik.gov.tr/
- Retrieve geographic map data at different NUTS levels (2, 3, 4) and settlement points (level 9)

## Key Architecture

### Data Access Pattern
The package uses two distinct data portals:
1. **Main TUIK Portal** (`data.tuik.gov.tr`): Statistical themes, tables, and databases
2. **Geographic Portal** (`cip.tuik.gov.tr`): Spatial data and maps

### Core Function Groups

**Statistical Data Functions** (web scraping based):
- `statistical_themes()`: Scrapes main page for theme list
- `statistical_tables(theme)`: Scrapes tables for a theme using POST requests
- `statistical_databases(theme)`: Scrapes database URLs for a theme

**Geographic Data Functions** (JSON API based):
- `geo_data()`: Downloads variable metadata or specific data series
  - Without parameters: Returns all available variables with metadata
  - With parameters: Downloads specific variable data for a NUTS level
- `geo_map(level)`: Downloads sf (simple features) objects for mapping
  - Levels: 2 (NUTS-2), 3 (NUTS-3), 4 (LAU-1), 9 (settlement points)

### Helper Functions
- `make_request(url)`: HTTP POST wrapper using `crul` package
- `check_theme_id(theme)`: Validates theme IDs and provides user feedback

### Key Dependencies
- **V8**: JavaScript engine (moved to Suggests - optional dependency)
- **sf**: Spatial features for geographic data
- **rvest/xml2**: Web scraping
- **jsonlite/rjson**: JSON parsing (both used in different functions)
- **tidyverse ecosystem**: dplyr, tidyr, purrr, stringr, tibble

## Development Commands

### Package Development
```r
# Load package in development
devtools::load_all()

# Document package (generates man files and NAMESPACE)
devtools::document()

# Run tests
devtools::test()

# Check package
devtools::check()

# Install package locally
devtools::install()

# Build pkgdown website
pkgdown::build_site()
```

### Running R CMD check
```bash
R CMD build .
R CMD check tuikR_*.tar.gz
```

### Testing
The package uses testthat edition 3:
```r
# Run all tests
devtools::test()

# Run specific test file
testthat::test_file("tests/testthat/test-statistical-themes.R")
```

Tests that require network access use `skip_on_cran()` and `skip_if_offline()`.

### CI/CD
GitHub Actions runs:
- **R-CMD-check**: Multi-platform testing (Ubuntu devel/release/oldrel-1, macOS release, Windows release)
- **test-coverage**: Code coverage tracking with codecov
- **pkgdown**: Automatic website deployment to gh-pages branch

Dependabot keeps GitHub Actions up to date automatically.

## Important Patterns and Quirks

### Theme Validation
Functions that accept a `theme` parameter use `check_theme_id()` which:
- Only accepts a single theme ID (not vectors)
- Validates against the current list from TUIK website
- Provides colored terminal feedback using `crayon` package

### Geographic Data Levels
- NUTS-2 (level 2): Regional level
- NUTS-3 (level 3): Provincial level
- LAU-1 (level 4): District level
- Level 9: Settlement points (returns POINT geometry instead of MULTIPOLYGON)

### Locale Handling
`statistical_tables()` includes locale detection for date parsing:
- Windows: "Turkish_Turkey.utf8"
- Unix/macOS: "tr_TR"
This is necessary because TUIK returns dates in Turkish.

### Data Cleaning Pattern
Geographic data functions use a consistent pattern:
1. Fetch JSON from TUIK API
2. Parse with jsonlite
3. Handle date formats (YYYYMM vs YYYY)
4. Use tidyr to reshape from wide to long format
5. Apply janitor::clean_names() for consistent column names
6. Convert code columns to character for joining

### API Endpoints Structure
Geographic data API: `https://cip.tuik.gov.tr/Home/GetMapData?kaynak={source}&duzey={level}&gostergeNo={var_no}&kayitSayisi={recnum}&period={period}`

Map geometry API: `https://cip.tuik.gov.tr/assets/geometri/{nuts2|nuts3|nuts4|yerlesim_noktalari}.json`

## Known Issues

### Issue #2 Referenced in README
The README mentions "If you are having problems at this stage, please see this issue on GitHub" (issue #2). When debugging connection or download problems, check this issue.

### TUIK Website Changes
Comment in README states: "All DB Links NOT WORKING AT THIS TIME. TUIK CHANGED THE PAGE"
The package is sensitive to TUIK website structure changes since it relies on web scraping.

### Messy Excel Files
Comment in README warns: "TUIK xls files are messy!!!"
Downloaded XLS files often have:
- Multiple header rows
- Mixed languages (Turkish/English)
- Source/metadata rows at the bottom
- Require manual cleaning after download

### V8 Dependency
The package Depends on V8 in DESCRIPTION, but the current code in `geo_map.R` uses direct JSON endpoints instead of JavaScript execution. The commented code (lines 24-41) shows the previous V8-based approach.

## Package Documentation

### pkgdown Website
The package uses the **eerdown** theme (custom theme by package author):
- Configuration in `_pkgdown.yml`
- Functions organized into "Statistical Data Functions" and "Geographic Data Functions"
- Automatic deployment via GitHub Actions to gh-pages branch
- Website URL: https://eremrah.com/tuikR/

### Citation
Standard citation metadata in `CITATION.cff` (CFF v1.2.0 format).

## Code Style

- Uses tidyverse conventions throughout
- Pipe operator %>% (exported from magrittr)
- Roxygen2 documentation with markdown enabled (RoxygenNote: 7.3.2)
- Uses dplyr::case_when() for conditional logic
- Prefers tibble over data.frame
- Uses .data pronoun for NSE columns (e.g., `.data$theme_id`)
- 2-space indentation standard
- Line length: 120 characters (as configured in .lintr)


# andrej-karpathy-skills

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.
