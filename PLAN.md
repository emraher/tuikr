# tuikR Package Improvement Plan

## Overview
Comprehensive plan to improve documentation, update version, create better pkgdown website, and update Zenodo.

---

## Phase 1: Critical Fixes (Do First)

### 1.1 Fix Installation Commands
**Priority:** CRITICAL
**Files:** README.md, README.Rmd
- [ ] Update `devtools::install_github("emraher/tuik")` → `"emraher/tuikR"`
- [ ] Regenerate README.md from README.Rmd

### 1.2 Fix Parameter Name Inconsistency
**Priority:** HIGH
**Files:** R/tuikR-geo-data.R
- [ ] Fix example: change `geo_data(level = 2)` → `geo_data(variable_level = 2)`
- [ ] Run `devtools::document()` to regenerate .Rd files

---

## Phase 2: Documentation Improvements

### 2.1 Enhance Function Documentation
**Priority:** HIGH

#### statistical_themes.R
- [ ] Improve @return: "A tibble with columns: `theme_name` (character) and `theme_id` (character)"
- [ ] Add details about what themes are available

#### statistical_tables.R
- [ ] Improve @return: "A tibble with columns: `theme_name`, `theme_id`, `data_name`, `data_date`, `datafile_url`"
- [ ] Add note about theme validation
- [ ] Add example of how to filter results

#### statistical_databases.R
- [ ] Improve @return: "A tibble with columns: `theme_name`, `theme_id`, `db_name`, `db_url`"
- [ ] Add note about current API limitations

#### geo_data.R
- [ ] Improve @return to describe two modes:
  - Without parameters: returns metadata tibble with columns `var_name`, `var_num`, `var_levels`, `var_period`, `var_source`, `var_recordnum`
  - With parameters: returns data tibble with columns `code`, `date`, and variable-specific column
- [ ] Better document parameter validation rules
- [ ] Add examples showing both usage modes

#### geo_map.R
- [ ] Add @return details: "An sf object with WGS 84 CRS (EPSG:4326)"
- [ ] Document columns for each level:
  - Level 2: `code`, `bolgeKodu`, `nutsKodu`, `name`, `ad`, `geometry`
  - Level 3: `code`, `bolgeKodu`, `nutsKodu`, `name`, `ad`, `geometry`
  - Level 4: `code`, `bolgeKodu`, `nutsKodu`, `name`, `ad`, `geometry`
  - Level 9: `ad`, `tp`, `bs`, `bm`, `geometry` (POINT)
- [ ] Add note about geometry types (MULTIPOLYGON vs POINT)

### 2.2 Clean Up Code
**Priority:** MEDIUM
- [ ] Remove commented V8 code block in geo_map.R (lines 24-41) or add explanatory comment about why it's kept
- [ ] Remove commented regex parsing code in geo_data.R (lines 76-84)
- [ ] Add brief code comment explaining why JSON approach replaced V8

---

## Phase 3: Create Vignettes

### 3.1 Getting Started Vignette
**Priority:** HIGH
**File:** vignettes/getting-started.Rmd

Content:
- Introduction to TUIK data
- Installing the package
- Basic workflow: themes → tables → data
- Troubleshooting common issues

### 3.2 Geographic Mapping Vignette
**Priority:** HIGH
**File:** vignettes/geographic-mapping.Rmd

Content:
- Introduction to NUTS levels
- Downloading geo data
- Creating choropleth maps
- Advanced examples (hex maps, dorling cartograms from README)
- Joining data with maps

### 3.3 Known Issues & Limitations
**Priority:** MEDIUM
**File:** vignettes/known-issues.Rmd

Content:
- TUIK website structure changes
- API limitations
- Messy Excel file formats
- Network dependency handling
- Issue #2 explanation

---

## Phase 4: Enhanced pkgdown Website

### 4.1 Expand _pkgdown.yml Configuration
**Priority:** HIGH

```yaml
template:
  package: eerdown
  bootstrap: 5

url: https://eremrah.com/tuikR

development:
  mode: auto
  version_label: default

authors:
  Emrah Er:
    href: https://eremrah.com

home:
  title: tuikR - Access Turkish Statistical Institute Data
  description: R package for downloading data from TUIK statistical and geographic portals
  links:
  - text: TUIK Data Portal
    href: https://data.tuik.gov.tr/
  - text: TUIK Geographic Portal
    href: https://cip.tuik.gov.tr/

navbar:
  structure:
    left: [intro, reference, articles, news]
    right: [github, twitter]
  components:
    articles:
      text: Articles
      menu:
      - text: Getting Started
        href: articles/getting-started.html
      - text: Geographic Mapping
        href: articles/geographic-mapping.html
      - text: Known Issues & Limitations
        href: articles/known-issues.html
    twitter:
      icon: fab fa-bluesky fa-lg
      href: https://bsky.app/profile/eremrah.com
      aria-label: Bluesky

reference:
- title: Statistical Data Functions
  desc: Functions for accessing TUIK statistical data portal (data.tuik.gov.tr)
  contents:
  - statistical_themes
  - statistical_tables
  - statistical_databases

- title: Geographic Data Functions
  desc: Functions for accessing TUIK geographic statistics portal (cip.tuik.gov.tr)
  contents:
  - geo_data
  - geo_map

- title: Internal Functions
  desc: Helper functions (not exported)
  contents:
  - has_keyword("internal")

footer:
  structure:
    left: developed_by
    right: built_with
  components:
    built_with: "Built with ❤️ + ☕ + 🤖 using [pkgdown](https://pkgdown.r-lib.org/) and [eerdown](https://eremrah.com/eerdown/)"
```

### 4.2 Create pkgdown/extra.css (Optional)
**Priority:** LOW
- Custom CSS for TUIK-themed colors if desired

---

## Phase 5: Version Update & Release

### 5.1 Update Version Number
**Priority:** HIGH
**File:** DESCRIPTION

Decision needed:
- Current: 0.0.2
- Options:
  - 0.1.0 (minor - new features: vignettes, improved docs, pkgdown)
  - 0.0.3 (patch - bug fixes only)
  - 1.0.0 (major - first stable release)

**Recommendation:** 0.1.0
- Significant improvements (vignettes, better docs)
- Not breaking changes
- Signals progress toward stability

### 5.2 Update NEWS.md
**Priority:** HIGH

```markdown
# tuikR 0.1.0

## New Features
* Added three vignettes: Getting Started, Geographic Mapping, Known Issues
* Enhanced pkgdown website with custom navigation and footer
* Improved function documentation with detailed return value descriptions

## Bug Fixes
* Fixed installation command in README (emraher/tuik → emraher/tuikR)
* Fixed parameter name in geo_data() example documentation
* Corrected geo_map() documentation to include CRS and column details

## Documentation
* Added comprehensive @return descriptions for all functions
* Documented NUTS level differences and geometry types
* Added troubleshooting guide for common issues
* Improved parameter descriptions with valid value examples

## Internal
* Cleaned up commented-out V8 code
* Updated all package references from tuik to tuikR

# tuikR 0.0.2

* Renamed package from tuik to tuikR
* Updated package infrastructure with modern R package development tools
* Added GitHub Actions workflows for CI/CD
* Added testthat edition 3 testing infrastructure
* Added pkgdown website with eerdown theme
* Moved V8 from Depends to Suggests (optional dependency)
* Improved package documentation

# tuikR 0.0.1

* Initial release
* Functions for accessing TUIK statistical data portal
* Functions for accessing TUIK geographic statistics portal
* Support for NUTS levels 2, 3, 4 and settlement points
```

### 5.3 Update CITATION.cff
**Priority:** MEDIUM
**File:** CITATION.cff
- [ ] Update version to 0.1.0
- [ ] Update date-released

---

## Phase 6: Zenodo Integration

### 6.1 Update Zenodo Badge
**Priority:** HIGH

Steps:
1. Go to https://zenodo.org/
2. Create new release or update existing (DOI: 313863336)
3. Link GitHub repository emraher/tuikR
4. Enable automatic versioning
5. Create GitHub release v0.1.0
6. Zenodo will automatically archive

### 6.2 Update README with New Badge
**Priority:** HIGH
- [ ] Verify Zenodo DOI badge still works with renamed repo
- [ ] Update badge if needed
- [ ] Add version badge if desired: `![](https://img.shields.io/github/r-package/v/emraher/tuikR)`

---

## Phase 7: GitHub Repository Updates

### 7.1 Update Repository Name
**Priority:** CRITICAL
**Location:** GitHub Settings

Steps:
1. Go to https://github.com/emraher/tuik/settings
2. Repository name: tuik → tuikR
3. Update description
4. Add topics: r, rstats, tuik, turkey, statistics, geographic-data

### 7.2 Update Repository Description
**Suggested:** "R package for accessing Turkish Statistical Institute (TUIK) data - statistical tables, databases, and geographic data"

### 7.3 Create Release
**Priority:** HIGH

Steps:
1. Tag: v0.1.0
2. Title: "tuikR 0.1.0"
3. Description: Copy from NEWS.md
4. Attach: Source code (auto)

---

## Phase 8: Testing & Validation

### 8.1 Local Testing
**Priority:** CRITICAL

```r
# Run before committing
devtools::document()
devtools::test()
devtools::check()
pkgdown::build_site()
```

### 8.2 Check Examples
**Priority:** HIGH
- [ ] Verify all examples run (even in \dontrun{})
- [ ] Test network-dependent functions
- [ ] Verify maps render correctly

### 8.3 Visual Inspection
**Priority:** MEDIUM
- [ ] Review pkgdown site locally
- [ ] Check all links work
- [ ] Verify vignette rendering
- [ ] Test mobile responsiveness

---

## Phase 9: Deployment

### 9.1 Commit Changes
```bash
git add -A
git commit -m "Release v0.1.0: Enhanced documentation and pkgdown site"
```

### 9.2 Push to GitHub
```bash
git push origin master
```

### 9.3 Create GitHub Release
- Triggers pkgdown deployment
- Triggers Zenodo archival

### 9.4 Verify Deployment
- [ ] Check GitHub Pages site live
- [ ] Verify Zenodo archive created
- [ ] Test installation from GitHub

---

## Optional Enhancements (Future)

### Additional Vignettes
- [ ] Advanced filtering and data manipulation
- [ ] Time series analysis with TUIK data
- [ ] Integrating multiple data sources

### Website Improvements
- [ ] Add custom logo
- [ ] Create favicon
- [ ] Add Google Analytics (if desired)

### Package Features
- [ ] Caching layer for API responses
- [ ] Progress bars for long downloads
- [ ] Retry logic for network failures
- [ ] Data validation helpers

### Community
- [ ] Add CRAN submission preparation
- [ ] Create pkgdown blog/news page
- [ ] Add examples gallery

---

## Timeline Estimate

**Phase 1 (Critical Fixes):** 30 minutes
**Phase 2 (Documentation):** 2-3 hours
**Phase 3 (Vignettes):** 4-6 hours
**Phase 4 (pkgdown):** 1-2 hours
**Phase 5 (Versioning):** 30 minutes
**Phase 6 (Zenodo):** 30 minutes
**Phase 7 (GitHub):** 30 minutes
**Phase 8 (Testing):** 1-2 hours
**Phase 9 (Deployment):** 30 minutes

**Total:** 10-15 hours of focused work

---

## Checklist Summary

**Must Do:**
- [ ] Fix README installation command
- [ ] Fix geo_data() example parameter
- [ ] Enhance all @return documentation
- [ ] Create 3 vignettes
- [ ] Expand pkgdown configuration
- [ ] Update version to 0.1.0
- [ ] Update NEWS.md
- [ ] Rename GitHub repository
- [ ] Create GitHub release
- [ ] Update Zenodo

**Should Do:**
- [ ] Clean up commented code
- [ ] Add troubleshooting guide
- [ ] Test all examples
- [ ] Visual site inspection

**Nice to Have:**
- [ ] Custom logo
- [ ] Additional vignettes
- [ ] Caching layer
