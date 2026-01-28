# Phase 7: GitHub Repository Configuration - Manual Instructions

This phase configures your GitHub repository settings and creates the v0.1.0 release.

## Prerequisites

- [x] Phase 6 complete (repository renamed to `emraher/tuikR`)
- [x] All commits pushed to GitHub
- [x] GitHub Actions passing

## Step 1: Configure Repository Settings

### 1.1 Repository Description

1. Go to: https://github.com/emraher/tuikR
2. Click the gear icon (⚙️) next to "About"
3. Set **Description:**
   ```
   R package for accessing Turkish Statistical Institute (TUIK) data
   ```
4. Set **Website:**
   ```
   https://eremrah.com/tuikR
   ```
5. Click "Save changes"

### 1.2 Repository Topics

In the same "About" section, add topics (tags):

```
r
rstats
tuik
turkey
statistics
geographic-data
spatial-data
nuts
turkish-data
open-data
```

Click "Save changes"

### 1.3 Enable GitHub Pages

1. Go to: https://github.com/emraher/tuikR/settings/pages
2. Under "Source", select:
   - **Branch:** `gh-pages`
   - **Folder:** `/ (root)`
3. Click "Save"
4. Wait 1-2 minutes for deployment
5. Verify site is accessible at: https://eremrah.com/tuikR/

**Note:** If you have a custom domain configured (eremrah.com), ensure DNS settings are correct.

---

## Step 2: Create GitHub Release v0.1.0

### 2.1 Prepare Release

1. Go to: https://github.com/emraher/tuikR/releases
2. Click "Create a new release"
3. Click "Choose a tag"
4. Type: `v0.1.0`
5. Click "Create new tag: v0.1.0 on publish"

### 2.2 Fill Release Information

**Release title:**
```
tuikR 0.1.0
```

**Description:**

Copy the entire contents of `RELEASE_v0.1.0.md` file into the description box.

Alternatively, you can write a shorter version:

```markdown
# tuikR 0.1.0

Major improvements with comprehensive documentation, vignettes, and enhanced pkgdown website.

## Highlights

- 📚 Three new comprehensive vignettes
- 📖 Enhanced function documentation
- 🌐 Improved pkgdown website with articles menu
- 🐛 Bug fixes for installation and examples

[View full changelog](https://github.com/emraher/tuikR/blob/master/NEWS.md)

**Installation:**
```r
devtools::install_github("emraher/tuikR")
```

**Website:** https://eremrah.com/tuikR/
```

### 2.3 Publish Release

1. Keep "Set as the latest release" checked
2. Keep "Create a discussion for this release" unchecked (optional)
3. Click "Publish release"

**What happens:**
- GitHub will create tag `v0.1.0`
- Zenodo will automatically archive the release (if configured)
- GitHub Actions will run for the tag
- pkgdown site will be updated with the version

---

## Step 3: Verify Release

### 3.1 Check Release Page

1. Go to: https://github.com/emraher/tuikR/releases/tag/v0.1.0
2. Verify release notes display correctly
3. Check that source code archives are available

### 3.2 Verify Zenodo Archive

1. Wait 5-10 minutes for Zenodo to process
2. Go to: https://zenodo.org/badge/latestdoi/313863336
3. Should show the new version
4. Click through to verify metadata is correct

### 3.3 Check GitHub Actions

1. Go to: https://github.com/emraher/tuikR/actions
2. Verify workflows triggered by the tag
3. All should pass (green checkmarks)

### 3.4 Verify Badges in README

Visit: https://github.com/emraher/tuikR

Check that all badges work:
- Lifecycle badge (experimental)
- Zenodo DOI badge
- R-CMD-check badge

---

## Step 4: Test Installation

Test that users can install the package:

### 4.1 Install from GitHub

In a fresh R session:

```r
# Remove existing version if installed
remove.packages("tuikR")

# Install from GitHub
devtools::install_github("emraher/tuikR")

# Load and check version
library(tuikR)
packageVersion("tuikR")
# Should show: '0.1.0'

# Check vignettes are available
browseVignettes("tuikR")
# Should show 3 vignettes
```

### 4.2 Install Specific Version

```r
# Install from release tag
devtools::install_github("emraher/tuikR@v0.1.0")
```

### 4.3 Test Basic Functionality

```r
library(tuikR)

# Test statistical functions
themes <- statistical_themes()
print(themes)

# Test geographic functions
vars <- geo_data()
print(head(vars))

map <- geo_map(3)
print(map)
```

All should work without errors.

---

## Step 5: Repository Configuration Checklist

Verify all settings:

### Settings > General
- [x] Repository name: `tuikR`
- [x] Description: Set correctly
- [x] Website: https://eremrah.com/tuikR
- [x] Topics: Added correctly

### Settings > Pages
- [x] Source: gh-pages branch
- [x] Custom domain: eremrah.com (if applicable)
- [x] Enforce HTTPS: Enabled

### Settings > Actions
- [x] Actions permissions: Allow all actions
- [x] Workflow permissions: Read and write permissions

### Releases
- [x] v0.1.0 release created
- [x] Release notes complete
- [x] Tagged correctly

---

## Completion Checklist

- [ ] Repository description and topics set
- [ ] GitHub Pages enabled and working
- [ ] Release v0.1.0 created successfully
- [ ] Zenodo archive created (new version)
- [ ] Installation from GitHub works
- [ ] All badges in README work
- [ ] pkgdown website shows version 0.1.0
- [ ] Vignettes accessible from website

---

## Next Steps

After completing Phase 7, proceed to:

**Phase 8:** Testing & Validation
- Run comprehensive package checks
- Test all examples
- Validate documentation
- Check for any remaining issues

**Phase 9:** Deployment Checklist
- Final verification
- Prepare announcement
- Update related documentation
