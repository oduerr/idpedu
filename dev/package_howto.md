# Package build and publish (version 0.2.0)

This repo is already a valid R package. Follow these steps to build, test, tag, and publish to GitHub.

## 1) Prerequisites
- R (>= 3.0), Quarto CLI, TeX (for PDF tests), and these R packages:
  ```r
  install.packages(c("devtools", "roxygen2", "testthat", "pdftools"))
  ```

## 2) Bump version
The version has been set to `0.2.0` in `DESCRIPTION`. If you change it later, edit `DESCRIPTION` and `NEWS.md`.

## 3) Document, build, check
From the project root in R:
```r
library(devtools)
# Generate Rd/NAMESPACE
roxygen2::roxygenize()
# Run tests
devtools::test()
# Build source tarball (e.g., idpedu_0.2.0.tar.gz)
path <- devtools::build()
# Optional: Run R CMD check
devtools::check()
```
The tarball path is returned in `path`.

## 4) Tag and push to GitHub
In a shell:
```bash
# Commit any pending changes first
git add -A && git commit -m "release: v0.2.0" || true
# Create annotated tag
git tag -a v0.2.0 -m "idpedu 0.2.0"
# Push code and tags
git push origin master --tags
```

## 5) Create a GitHub Release and upload tarball
- Open the new tag `v0.2.0` on GitHub and click “Draft new release”.
- Title: `idpedu 0.2.0`.
- Upload the built file `idpedu_0.2.0.tar.gz` as a release asset.
- Publish the release.

## 6) Install from GitHub
Users can either install from source (tarball) or from the repo:

- From release asset (recommended):
  ```r
  install.packages("https://github.com/oduerr/idpedu/releases/download/v0.2.0/idpedu_0.2.0.tar.gz", repos = NULL, type = "source")
  ```
- Or from the repo tip:
  ```r
  if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
  remotes::install_github("oduerr/idpedu@v0.2.0")
  ```

## 7) Verify install
```r
library(idpedu)
?create_workbook
```

## Notes
- Artifacts in `tests/artifacts/` are gitignored and not part of the build.
- For HTML callouts, prefer `selfcontained = TRUE` (see README).
- To automate, consider GitHub Actions using `r-lib/actions/setup-r` and `check-r-package`.
