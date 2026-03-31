# Changelog

## tuikr 0.2.0

### Breaking changes

- [`statistical_data()`](https://eremrah.com/tuikr/reference/statistical_data.md)
  now returns cleaned long-form SDMX output with invariant dimensions
  removed and `*_label` columns added when code-list labels are
  available.
- The statistical portal helpers now center the SDMX-first workflow:
  [`statistical_tables()`](https://eremrah.com/tuikr/reference/statistical_tables.md)
  exposes `node_type`, `dataflow_id`, and `table_url`, while
  [`statistical_resources()`](https://eremrah.com/tuikr/reference/statistical_resources.md)
  exposes `resource_type` and `resource_url`.

### New features

- Added
  [`statistical_data()`](https://eremrah.com/tuikr/reference/statistical_data.md)
  support for localized SDMX labels through `lang = "en"` and
  `lang = "tr"`.
- Added a focused geographic mapping vignette and refreshed the
  getting-started guide to match the current statistical and geographic
  APIs.
- Added coverage for vignette accessibility so required figure alt text
  is exercised in tests.

### Fixes

- Tightened scalar argument validation in
  [`geo_data()`](https://eremrah.com/tuikr/reference/geo_data.md) and
  [`geo_map()`](https://eremrah.com/tuikr/reference/geo_map.md) so
  vector, missing, and `NA` inputs fail with package errors instead of
  base-R condition errors.
- Cleaned `R CMD check` notes related to NSE imports and outdated public
  links.
- Fixed a tidyselect deprecation warning in
  [`geo_map()`](https://eremrah.com/tuikr/reference/geo_map.md).
- Refreshed README examples, package metadata, and pkgdown-facing links
  to match the rewritten SDMX and geographic interfaces.

### Infrastructure

- Refreshed generated documentation and pkgdown content for the current
  API.
- Added build ignore coverage for local planning artifacts.

------------------------------------------------------------------------

## tuikr 0.1.0

- Tightened CRAN-facing package metadata and replaced placeholder
  submission notes with explicit preflight guidance.

### Major Improvements

#### New Vignettes

Added three comprehensive vignettes to guide users:

- **Getting Started**
  ([`vignette("getting-started")`](https://eremrah.com/tuikr/articles/getting-started.md)):
  Introduction to TUIK data portals, installation, basic workflow for
  statistical data, troubleshooting tips
- **Geographic Mapping**
  ([`vignette("geographic-mapping")`](https://eremrah.com/tuikr/articles/geographic-mapping.md)):
  Working with NUTS levels, creating choropleth maps, advanced
  cartography (hexagonal and Dorling cartograms)
- **Known Issues & Limitations** (`vignette("known-issues")`): Common
  challenges, workarounds, best practices, and how to report issues

#### Enhanced Documentation

- Improved
  [`geo_data()`](https://eremrah.com/tuikr/reference/geo_data.md)
  documentation with dual-mode return value descriptions
- Enhanced [`geo_map()`](https://eremrah.com/tuikr/reference/geo_map.md)
  documentation with CRS details and column descriptions
- Added comprehensive Turkish administrative terminology explanations
- Documented NUTS levels and geometry types in detail
- Replaced commented code blocks with clear explanatory notes

#### pkgdown Website Enhancements

- Added home page title, description, and direct links to TUIK portals
- Restructured navbar with articles dropdown menu for easy vignette
  access
- Enhanced reference page with detailed section descriptions
- Added internal functions section for developer reference
- Custom footer with attribution
- Improved site navigation and user experience

### Bug Fixes

- Fixed README installation commands (corrected repository name from
  `emraher/tuik` to `emraher/tuikr`)
- Fixed [`geo_data()`](https://eremrah.com/tuikr/reference/geo_data.md)
  example parameter name (`level` -\> `var_level`)
- Removed deprecated V8 import from
  [`geo_map()`](https://eremrah.com/tuikr/reference/geo_map.md)
  documentation
- Added comprehensive examples for
  [`geo_data()`](https://eremrah.com/tuikr/reference/geo_data.md)
  showing both metadata and data retrieval modes

### Documentation

- Regenerated all documentation files with updated roxygen2
- All functions now have complete, accurate examples
- Improved consistency across function documentation

## tuikr 0.0.2

- Renamed package from tuik to tuikr
- Updated package infrastructure with modern R package development tools
- Added GitHub Actions workflows for CI/CD
- Added testthat edition 3 testing infrastructure
- Added pkgdown website with eerdown theme
- Moved V8 from Depends to Suggests (optional dependency)
- Improved package documentation

## tuikr 0.0.1

- Initial release
- Functions for accessing TUIK statistical data portal
- Functions for accessing TUIK geographic statistics portal
- Support for NUTS levels 2, 3, 4 and settlement points
