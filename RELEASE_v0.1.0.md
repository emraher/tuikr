# tuikR 0.1.0

This release represents a major improvement to the tuikR package with comprehensive documentation, new vignettes, and an enhanced pkgdown website.

## 🎉 Major Improvements

### 📚 New Vignettes

Three comprehensive vignettes to guide users:

- **Getting Started** - Introduction to TUIK data portals, installation, basic workflow for statistical data, and troubleshooting tips
- **Geographic Mapping** - Working with NUTS levels, creating choropleth maps, and advanced cartography (hexagonal and Dorling cartograms)
- **Known Issues & Limitations** - Common challenges, workarounds, best practices, and how to report issues

### 📖 Enhanced Documentation

- Improved `geo_data()` documentation with dual-mode return value descriptions
- Enhanced `geo_map()` documentation with CRS details and column descriptions
- Added comprehensive Turkish administrative terminology explanations
- Documented NUTS levels and geometry types in detail
- Replaced commented code blocks with clear explanatory notes

### 🌐 pkgdown Website Enhancements

- Added home page title, description, and direct links to TUIK portals
- Restructured navbar with articles dropdown menu for easy vignette access
- Enhanced reference page with detailed section descriptions
- Added internal functions section for developer reference
- Custom footer with attribution
- Improved site navigation and user experience

**Visit the website:** https://eremrah.com/tuikR/

## 🐛 Bug Fixes

- Fixed README installation commands (corrected repository name from `emraher/tuik` to `emraher/tuikR`)
- Fixed `geo_data()` example parameter name (`level` → `variable_level`)
- Removed deprecated V8 import from `geo_map()` documentation
- Added comprehensive examples for `geo_data()` showing both metadata and data retrieval modes

## 📝 Documentation

- Regenerated all documentation files with updated roxygen2
- All functions now have complete, accurate examples
- Improved consistency across function documentation

## 🚀 Installation

```r
# Install from GitHub
devtools::install_github("emraher/tuikR")

# Load the package
library(tuikR)

# Get started
vignette("getting-started", package = "tuikR")
```

## 📊 Quick Example

```r
library(tuikR)
library(tidyverse)
library(sf)

# Get statistical themes
themes <- statistical_themes()

# Get tables for a theme
tables <- statistical_tables("110")  # Justice and Elections

# Get geographic data
vars <- geo_data()  # Get available variables
cinema <- geo_data(3, "SNM-GK160951-O33303", "medas", "yillik", 5)  # Cinema data

# Create a map
map <- geo_map(3)  # NUTS-3 (provinces)
map %>%
  left_join(cinema, by = "code") %>%
  ggplot() +
  geom_sf(aes(fill = as.numeric(sinema_film_sayisi)))
```

## 🙏 Acknowledgments

This package provides access to data from the Turkish Statistical Institute (TUIK/TÜİK).

## 📄 Citation

If you use this package in your research, please cite:

```
Er, E. (2026). tuikR: Download Data File And Database Urls from TUIK.
R package version 0.1.0. https://github.com/emraher/tuikR
DOI: 10.5281/zenodo.313863336
```

---

**Full Changelog**: https://github.com/emraher/tuikR/compare/v0.0.2...v0.1.0
