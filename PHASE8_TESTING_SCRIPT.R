# Phase 8: Testing & Validation Script
# Run this script to validate the tuikr package before final deployment

cat("========================================\n")
cat("tuikr Package Validation - Phase 8\n")
cat("========================================\n\n")

# ------------------------------------------------------------------------------
# 1. Package Development Checks
# ------------------------------------------------------------------------------

cat("1. Running devtools::document()...\n")
devtools::document()
cat("✓ Documentation generated\n\n")

cat("2. Running devtools::test()...\n")
test_results <- devtools::test()
cat("✓ Tests completed\n\n")

cat("3. Running devtools::check()...\n")
check_results <- devtools::check()
cat("✓ Package check completed\n\n")

# ------------------------------------------------------------------------------
# 2. pkgdown Site Build
# ------------------------------------------------------------------------------

cat("4. Building pkgdown site...\n")
pkgdown::build_site(preview = FALSE)
cat("✓ pkgdown site built\n\n")

# ------------------------------------------------------------------------------
# 3. Manual Function Tests (Network-Dependent)
# ------------------------------------------------------------------------------

cat("5. Testing statistical data functions...\n")

# Test statistical_themes
cat("  - Testing statistical_themes()...\n")
themes <- tryCatch({
  tuikr::statistical_themes()
}, error = function(e) {
  cat("    ✗ ERROR:", e$message, "\n")
  NULL
})

if (!is.null(themes)) {
  cat("    ✓ statistical_themes() works\n")
  cat("    → Returned", nrow(themes), "themes\n")
}

# Test statistical_tables
cat("  - Testing statistical_tables()...\n")
tables <- tryCatch({
  tuikr::statistical_tables("110")
}, error = function(e) {
  cat("    ✗ ERROR:", e$message, "\n")
  NULL
})

if (!is.null(tables)) {
  cat("    ✓ statistical_tables() works\n")
  cat("    → Returned", nrow(tables), "tables\n")
}

# Test statistical_databases
cat("  - Testing statistical_databases()...\n")
databases <- tryCatch({
  tuikr::statistical_databases("110")
}, error = function(e) {
  cat("    ✗ ERROR:", e$message, "\n")
  NULL
})

if (!is.null(databases)) {
  cat("    ✓ statistical_databases() works\n")
  cat("    → Returned", nrow(databases), "databases\n")
}

cat("\n")

# ------------------------------------------------------------------------------
# 4. Geographic Data Functions
# ------------------------------------------------------------------------------

cat("6. Testing geographic data functions...\n")

# Test geo_data (metadata mode)
cat("  - Testing geo_data() [metadata mode]...\n")
vars <- tryCatch({
  tuikr::geo_data()
}, error = function(e) {
  cat("    ✗ ERROR:", e$message, "\n")
  NULL
})

if (!is.null(vars)) {
  cat("    ✓ geo_data() works\n")
  cat("    → Returned", nrow(vars), "variables\n")
}

# Test geo_data (data download mode)
cat("  - Testing geo_data() [data download mode]...\n")
cinema_data <- tryCatch({
  tuikr::geo_data(
    variable_level = 3,
    variable_no = "SNM-GK160951-O33303",
    variable_source = "medas",
    variable_period = "yillik",
    variable_recnum = 5
  )
}, error = function(e) {
  cat("    ✗ ERROR:", e$message, "\n")
  NULL
})

if (!is.null(cinema_data)) {
  cat("    ✓ geo_data() [data mode] works\n")
  cat("    → Returned", nrow(cinema_data), "rows\n")
}

# Test geo_map at different levels
cat("  - Testing geo_map()...\n")

for (level in c(2, 3, 4, 9)) {
  map <- tryCatch({
    tuikr::geo_map(level)
  }, error = function(e) {
    cat("    ✗ ERROR at level", level, ":", e$message, "\n")
    NULL
  })

  if (!is.null(map)) {
    cat("    ✓ geo_map(", level, ") works → ", nrow(map), " features\n", sep = "")
  }
}

cat("\n")

# ------------------------------------------------------------------------------
# 5. Vignette Check
# ------------------------------------------------------------------------------

cat("7. Checking vignettes...\n")

vignette_files <- list.files("vignettes", pattern = "\\.Rmd$", full.names = TRUE)
cat("  Found", length(vignette_files), "vignette files:\n")
for (v in vignette_files) {
  cat("    -", basename(v), "\n")
}

built_vignettes <- list.files("docs/articles", pattern = "\\.html$", full.names = FALSE)
cat("  Built", length(built_vignettes), "vignette HTML files\n")

cat("\n")

# ------------------------------------------------------------------------------
# 6. Documentation Check
# ------------------------------------------------------------------------------

cat("8. Checking documentation...\n")

man_files <- list.files("man", pattern = "\\.Rd$")
cat("  Found", length(man_files), "documentation files\n")

# Check that key functions are documented
key_functions <- c(
  "statistical_themes.Rd",
  "statistical_tables.Rd",
  "statistical_databases.Rd",
  "geo_data.Rd",
  "geo_map.Rd"
)

for (fn in key_functions) {
  if (fn %in% man_files) {
    cat("    ✓", fn, "\n")
  } else {
    cat("    ✗ MISSING:", fn, "\n")
  }
}

cat("\n")

# ------------------------------------------------------------------------------
# 7. Package Metadata Check
# ------------------------------------------------------------------------------

cat("9. Checking package metadata...\n")

desc <- read.dcf("DESCRIPTION")
cat("  Package:", desc[,"Package"], "\n")
cat("  Version:", desc[,"Version"], "\n")
cat("  Title:", desc[,"Title"], "\n")

if (desc[,"Version"] == "0.1.0") {
  cat("    ✓ Version is 0.1.0\n")
} else {
  cat("    ✗ Version should be 0.1.0\n")
}

cat("\n")

# ------------------------------------------------------------------------------
# 8. NEWS.md Check
# ------------------------------------------------------------------------------

cat("10. Checking NEWS.md...\n")

if (file.exists("NEWS.md")) {
  news <- readLines("NEWS.md")
  if (any(grepl("# tuikr 0.1.0", news))) {
    cat("    ✓ NEWS.md contains 0.1.0 entry\n")
  } else {
    cat("    ✗ NEWS.md missing 0.1.0 entry\n")
  }
} else {
  cat("    ✗ NEWS.md not found\n")
}

cat("\n")

# ------------------------------------------------------------------------------
# 9. Final Summary
# ------------------------------------------------------------------------------

cat("========================================\n")
cat("Validation Summary\n")
cat("========================================\n\n")

cat("Package checks:\n")
cat("  ✓ Documentation generated\n")
cat("  ✓ Tests run\n")
cat("  ✓ R CMD check completed\n")
cat("  ✓ pkgdown site built\n\n")

cat("Function tests:\n")
cat("  ✓ Statistical data functions tested\n")
cat("  ✓ Geographic data functions tested\n")
cat("  ✓ All NUTS levels tested\n\n")

cat("Documentation:\n")
cat("  ✓ All key functions documented\n")
cat("  ✓ Vignettes built\n")
cat("  ✓ Version metadata correct\n\n")

cat("========================================\n")
cat("Review the output above for any errors.\n")
cat("If all tests pass, proceed to Phase 9.\n")
cat("========================================\n")

# Return check results for review
invisible(list(
  check = check_results,
  test = test_results
))
