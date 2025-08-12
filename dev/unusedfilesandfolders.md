# Unused files and folders report

This report lists files and folders that appear unused by the current `idpedu` code (`R/`), tests (`tests/`), and documentation, based on a repository-wide search for references.

## Criteria
- Considered "used" if referenced by code, tests, or README/NEWS, or loaded at runtime via `system.file(...)` from `inst/`.
- Considered "unused" if only present in their own directory without any inbound references elsewhere.

## Summary of findings

- inst/extdata: in use (copied wholesale by `copy_extdata()` and referenced in README/tests)
- inst/rmarkdown/templates/aufgabe: appears unused (legacy template tree)
- dev: developer notes; `AGENT_CREATE_AUFGABEN.md` is empty
- R/Testing*.R: developer scratch files, wrapped in `if (FALSE)`; not executed by package
- output/: generated demo artifacts; not used by package code
- Read-and-delete-me: standard CRAN skeleton; not used by package

## Evidence by area

### 1) Runtime code paths (R/CreateAB2.R)
- Uses `inst/extdata` via `system.file("extdata", package = "idpedu")` and expects:
  - `da.qmd`, `stat.qmd`, `preamble.tex`, `solution.lua`, `htwg_logo.png`
- No references to `inst/rmarkdown/templates/aufgabe/**`.

### 2) Tests (`tests/testthat/*`)
- Exercise fixtures reference only `inst/extdata` files (e.g., `preamble.tex`, `htwg_logo.png`) through the header files `da.qmd` and `stat.qmd`.
- No references to `inst/rmarkdown/templates/aufgabe/**`.

### 3) Documentation (README.md, NEWS.md)
- Mentions and instructs editing `inst/extdata`.
- No mention of `inst/rmarkdown/templates/aufgabe/**` except a note in `dev/CHANGESET.md` about future removal.

## Likely unused files/folders

- `inst/rmarkdown/templates/aufgabe/` (entire tree)
  - `resources/`
    - `before_body.tex`
    - `before_body_img.tex`
    - `before_body_img_ast.tex`
    - `before_body_img_cas.tex`
    - `before_body_img_cas_da.tex`
    - `before_body_img_cas_stat_mod.tex`
    - `before_body_img_htwg_bi.tex`
    - `before_body_img_htwg_dataanalytics.tex`
    - `before_body_img_htwg_ds.tex`
    - `before_body_img_htwg_stat.tex`
    - `before_body_img_qs.tex`
    - `before_body_img_qs_asp_spc.tex`
    - `before_body_img_qs_asp_spc_pruefung.tex`
    - `before_body_img_stdm.tex`
    - `before_body_img_stop.tex`
    - `before_body_img_wast1.tex`
    - `before_body_img_wast2.tex`
    - `header_nolsg.log` (LaTeX log)
    - `header_nolsg.tex`
    - `htwg_logo.png` (duplicate of extdata image)
    - `logo.jpg`
    - `logo_cas.png`
    - `template.tex`
  - `skeleton/`
    - `header_lsg.tex`
    - `skeleton.Rmd`
  - `template.yaml`

  Evidence:
  - No inbound references from `R/`, `tests/`, or docs. Only self-contained references within the template files.
  - `dev/CHANGESET.md` explicitly marks this tree for future deprecation.

- `tests/testthat/fixtures/da.qmd`
  - Present but not referenced by tests or code; tests set `header_file <- "da.qmd"` which resolves to `inst/extdata/da.qmd` via `copy_extdata()`.

- `tests/testthat/fixtures/stat.qmd`
  - Present but not referenced by tests or code; tests set `header_file <- "stat.qmd"` which resolves to `inst/extdata/stat.qmd` via `copy_extdata()`.

- `dev/AGENT_CREATE_AUFGABEN.md`
  - File exists but is empty.

- `output/arbeitsblatt.html`, `output/arbeitsblatt.pdf`
  - Built example outputs. Not used by code/tests.

- `Read-and-delete-me`
  - CRAN skeleton reminder; not referenced elsewhere.

- `R/Testing.R`, `R/Testing_2025.R`
  - Wrapped in `if (FALSE)`; not part of runtime or tests. Keep as developer examples or move under `dev/`.

## Files/folders confirmed as used

- `inst/extdata/`
  - `da.qmd`, `stat.qmd`, `preamble.tex`, `solution.lua`, `htwg_logo.png` — referenced by runtime or test/README flows and copied by `copy_extdata()`.
- `R/CreateAB2.R` — main API; exported via `NAMESPACE`.
- `tests/testthat/**` — all test files and fixtures used by the test suite.

## Recommendation
- Consider removing or archiving the legacy template tree `inst/rmarkdown/templates/aufgabe/**` after a final check in downstream projects.
- Move `R/Testing*.R` and `output/*` to `dev/` or remove if no longer needed.
- Delete the empty `dev/AGENT_CREATE_AUFGABEN.md` or add content if intended.
- Keep `inst/extdata/**` as authoritative assets for the current workflow.