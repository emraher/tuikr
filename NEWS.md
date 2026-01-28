# tuikR 0.1.0

## Major Improvements

### New Vignettes

Added three comprehensive vignettes to guide users:

* **Getting Started** (`vignette("getting-started")`): Introduction to TUIK data portals, installation, basic workflow for statistical data, troubleshooting tips
* **Geographic Mapping** (`vignette("geographic-mapping")`): Working with NUTS levels, creating choropleth maps, advanced cartography (hexagonal and Dorling cartograms)
* **Known Issues & Limitations** (`vignette("known-issues")`): Common challenges, workarounds, best practices, and how to report issues

### Enhanced Documentation

* Improved `geo_data()` documentation with dual-mode return value descriptions
* Enhanced `geo_map()` documentation with CRS details and column descriptions
* Added comprehensive Turkish administrative terminology explanations
* Documented NUTS levels and geometry types in detail
* Replaced commented code blocks with clear explanatory notes

### pkgdown Website Enhancements

* Added home page title, description, and direct links to TUIK portals
* Restructured navbar with articles dropdown menu for easy vignette access
* Enhanced reference page with detailed section descriptions
* Added internal functions section for developer reference
* Custom footer with attribution
* Improved site navigation and user experience

## Bug Fixes

* Fixed README installation commands (corrected repository name from `emraher/tuik` to `emraher/tuikR`)
* Fixed `geo_data()` example parameter name (`level` → `variable_level`)
* Removed deprecated V8 import from `geo_map()` documentation
* Added comprehensive examples for `geo_data()` showing both metadata and data retrieval modes

## Documentation

* Regenerated all documentation files with updated roxygen2
* All functions now have complete, accurate examples
* Improved consistency across function documentation

---

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
