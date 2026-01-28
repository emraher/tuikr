# Phase 6: Zenodo Integration - Manual Instructions

This phase requires manual actions on GitHub and Zenodo websites. Follow these steps carefully.

## Prerequisites

Before starting, ensure:
- [x] All Phases 1-5 are complete and committed
- [x] Version 0.1.0 is set in DESCRIPTION, NEWS.md, and CITATION.cff
- [x] All local changes are committed (`git status` should be clean)

## Step 1: GitHub Repository Rename

**CRITICAL:** This step will rename your repository from `emraher/tuik` to `emraher/tuikr`.

### 1.1 Rename on GitHub

1. Go to: https://github.com/emraher/tuik/settings
2. Scroll down to "Repository name"
3. Change `tuik` to `tuikr`
4. Click "Rename"

**Important:** GitHub will automatically:
- Set up redirects from old URLs to new URLs
- Update GitHub Actions workflows
- Preserve all issues, PRs, and stars

### 1.2 Update Local Git Remote

After renaming on GitHub, update your local repository:

```bash
cd /Users/emraher/Workspace/tuik

# Update the remote URL
git remote set-url origin git@github.com:emraher/tuikr.git

# Verify the change
git remote -v
# Should show:
# origin  git@github.com:emraher/tuikr.git (fetch)
# origin  git@github.com:emraher/tuikr.git (push)

# Push all commits and verify connection
git push origin master
```

### 1.3 Rename Local Directory (Optional)

For consistency, you may want to rename the local directory:

```bash
cd /Users/emraher/Workspace
mv tuik tuikr
cd tuikr
```

If you do this, remember to update any IDE/editor project settings.

---

## Step 2: Configure Zenodo Integration

### 2.1 Link GitHub Repository to Zenodo

1. Go to: https://zenodo.org/account/settings/github/
2. Log in with your GitHub account if needed
3. Find `emraher/tuikr` in the repository list
4. Click the toggle to enable Zenodo archiving

**Note:** If the repository was previously linked as `emraher/tuik`, the rename should preserve the connection. Verify the existing DOI badge still works.

### 2.2 Verify Existing Zenodo Record

The README shows an existing Zenodo DOI: 313863336

1. Visit: https://zenodo.org/badge/latestdoi/313863336
2. Verify it points to the correct repository
3. Check that automatic versioning is enabled

### 2.3 Enable Automatic Versioning

If not already enabled:

1. Go to your Zenodo record settings
2. Enable "Automatically create new version on GitHub release"
3. This will create a new DOI version when you create GitHub release v0.1.0

---

## Step 3: Verify Package References

All package files should already reference `tuikr` (this was done in Phase 1). Verify:

- [x] README.md: Installation instructions use `emraher/tuikr`
- [x] DESCRIPTION: URLs point to `emraher/tuikr`
- [x] CITATION.cff: Repository URL is `emraher/tuikr`
- [x] _pkgdown.yml: URL is `https://eremrah.com/tuikr`
- [x] GitHub Actions workflows: Should auto-update after rename

---

## Step 4: Push Pending Commits

After renaming the repository, push all pending commits:

```bash
# Verify you're on the master branch
git branch

# Push all commits
git push origin master

# Push all tags if any
git push origin --tags
```

---

## Step 5: Verify GitHub Actions

After pushing:

1. Go to: https://github.com/emraher/tuikr/actions
2. Verify that workflows trigger correctly:
   - R-CMD-check should run
   - test-coverage should run
   - pkgdown should run
3. All workflows should pass (green checkmarks)

---

## Step 6: Verify pkgdown Deployment

After GitHub Actions complete:

1. Go to: https://github.com/emraher/tuikr/settings/pages
2. Verify that GitHub Pages is enabled
3. Source should be: "Deploy from a branch"
4. Branch should be: `gh-pages` / `/ (root)`
5. Visit: https://eremrah.com/tuikr/
6. Verify the website loads correctly with:
   - All three vignettes in Articles menu
   - Correct version number (0.1.0)
   - Working navigation

---

## Step 7: Update Zenodo Badge (If Needed)

If the Zenodo badge in README.md breaks after renaming:

1. Get the new badge code from your Zenodo record
2. Update README.md (line 10):

```markdown
[![DOI](https://zenodo.org/badge/313863336.svg)](https://zenodo.org/badge/latestdoi/313863336)
```

3. Commit and push if changed

---

## Completion Checklist

- [ ] Repository renamed to `emraher/tuikr` on GitHub
- [ ] Local git remote updated to new URL
- [ ] All commits pushed successfully to renamed repository
- [ ] GitHub Actions workflows pass
- [ ] pkgdown website deployed to https://eremrah.com/tuikr/
- [ ] Zenodo integration verified
- [ ] Zenodo badge works in README
- [ ] All links in package documentation work

---

## Rollback Plan (If Needed)

If something goes wrong:

1. Rename repository back to `tuik` on GitHub
2. Update local remote: `git remote set-url origin git@github.com:emraher/tuik.git`
3. Create an issue on GitHub describing the problem

---

## Next Steps

After completing Phase 6, proceed to:

**Phase 7:** GitHub Repository Configuration
- Set repository description and topics
- Create GitHub release v0.1.0
- Configure repository settings

**Phase 8:** Testing & Validation
- Run comprehensive package checks
- Test installation from GitHub
- Verify all examples work

**Phase 9:** Deployment Checklist
- Final verification before announcement
