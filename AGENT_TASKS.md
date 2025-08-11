# idpedu – Agent Cleanup Tasks

This document defines the **step-by-step tasks** for an AI agent (e.g., Cursor) to remove legacy code from the `idpedu` R package while preserving the key workflows.

---

## Reference Workflows

The canonical workflows to preserve are defined in `Testing_2025.R`.  
These cover three cases:
1. Local → HTML
2. Local → PDF
3. Remote → PDF

All three must produce identical outputs (format, filenames, and content) after cleanup.

---

## **Tasks for the agent**

### **Task 0 — Create fixtures and workflow tests**
1. Extract the three workflows from `Testing_2025.R` and turn them into `tests/testthat/test-workflows.R`.
2. Create `tests/testthat/fixtures/` containing:
   - Minimal `.qmd` files (copied from `demo/`).
   - Any header files needed (`da.qmd`, `stat.qmd`) from `inst/extdata` or copied locally for tests.
3. For HTML workflow:
   - Normalize volatile paths in the output.
   - Save as `_norm.html` and snapshot it.
4. For PDF workflows:
   - Verify file existence.
   - Check page count and total text length with `pdftools::pdf_text()`.
   - Do **not** snapshot the binary PDF.

---

### **Task 1 — Plan**
1. Read the package structure: `DESCRIPTION`, `NAMESPACE`, `R/`, `inst/`, `demo/`.
2. Build a **dependency map** starting from `create_workbook()` to identify required functions and files.
3. List all functions/files not reachable from the three workflows.
4. Propose any additional minimal tests needed to protect current behavior.
5. Output only the plan for review — **no code changes yet**.

---

### **Task 2 — Prune legacy**
1. Run coverage with:
   ```r
   covr::package_coverage(type = "tests")
   ```
2. Identify unused functions and files.
3. Remove clearly unused code.
4. For maybe-useful code:
   - Mark with `lifecycle::deprecated()` and `@keywords internal`.
5. Inline single-use helpers.
6. Update `NAMESPACE` accordingly.

---

### **Task 3 — Final QA & Documentation**
1. Run:
   ```r
   devtools::document()
   devtools::test(filter = "workflows")
   devtools::check(document = TRUE, error_on = "warning")
   ```
2. Create `dev/CHANGESET.md` summarizing:
   - What was removed.
   - What was kept.
   - Any deprecations.
3. Update `NEWS.md`.
4. Verify that the number of R files and total repo size decreased.

---

## **Constraints**
- No breaking changes to `create_workbook()` or its arguments.
- Keep all three workflows functional with identical outputs.
- No new heavy dependencies without explicit justification.
- Strengthen tests before removing anything.
- Prefer removal over rewrite, unless rewrite is essential for test pass.

---

## **Out of scope**
- Changing the public API or defaults.
- Purely cosmetic style rewrites.
- Adding large new dependencies.
