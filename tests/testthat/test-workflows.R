test_that("Local → HTML workflow works and normalizes output", {
  skip_on_cran()
  skip_if_no_quarto()

  prepare_artifacts_dir()

  tmp_out <- file.path(tempdir(), paste0("idpedu-test-", as.integer(runif(1, 1, 1e9))))
  dir.create(tmp_out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp_out, recursive = TRUE, force = TRUE), add = TRUE)
  tasks <- c(
    test_path("fixtures/exercise1.qmd"),
    test_path("fixtures/exercise2.qmd")
  )
  title <- "Week 1 (Simple Stuff)"
  fname <- "wk_local"
  header_file <- "da.qmd"

  create_workbook(
    tasks = tasks,
    title = title,
    fname = fname,
    header_file = header_file,
    output_format = c("html"),
    output_dir = tmp_out,
    selfcontained = TRUE,
    verbose = FALSE
  )

  html_file <- file.path(tmp_out, paste0(fname, "_nolsg.html"))
  expect_true(file.exists(html_file))

  # Copy artifacts for manual inspection
  copy_to_artifacts(c(
    html_file,
    file.path(tmp_out, paste0(fname, "_lsg.html"))
  ))

  # Normalize volatile paths and times in HTML
  html <- readLines(html_file, warn = FALSE)
  html_norm <- gsub(getwd(), "<WD>", html, fixed = TRUE)
  html_norm <- gsub(tmp_out, "<TMP>", html_norm, fixed = TRUE)
  html_norm <- gsub("merged\\.[0-9a-f]{6,}", "merged.<HASH>", html_norm)

  html_norm_file <- file.path(tmp_out, paste0(fname, "_nolsg_norm.html"))
  writeLines(html_norm, html_norm_file)

  # Snapshot the normalized HTML; update with TESTTHAT_UPDATE=1
  expect_snapshot_file(html_norm_file, basename(html_norm_file))
})

test_that("Local → PDF workflow works (da.qmd)", {
  skip_on_cran()
  skip_if_no_quarto()
  skip_if_no_pdflatex()
  testthat::skip_if_not_installed("pdftools")

  prepare_artifacts_dir()

  tmp_out <- file.path(tempdir(), paste0("idpedu-test-", as.integer(runif(1, 1, 1e9))))
  dir.create(tmp_out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp_out, recursive = TRUE, force = TRUE), add = TRUE)
  tasks <- c(
    test_path("fixtures/exercise1.qmd"),
    test_path("fixtures/exercise2.qmd")
  )
  title <- "Week 1 (Simple Stuff)"
  fname <- "wk_local_da"
  header_file <- "da.qmd"

  create_workbook(
    tasks = tasks,
    title = title,
    fname = fname,
    header_file = header_file,
    output_format = c("pdf"),
    output_dir = tmp_out,
    verbose = FALSE
  )

  pdf_file <- file.path(tmp_out, paste0(fname, "_nolsg.pdf"))
  expect_true(file.exists(pdf_file))

  # Copy artifacts for manual inspection
  copy_to_artifacts(c(
    pdf_file,
    file.path(tmp_out, paste0(fname, "_lsg.pdf"))
  ))

  txt <- pdftools::pdf_text(pdf_file)
  # Basic sanity: at least 1 page and some text
  expect_true(length(txt) >= 1)
  expect_true(nchar(paste(txt, collapse = "\n")) > 100)
})

test_that("Remote → PDF workflow works (stat.qmd)", {
  skip_on_cran()
  skip_if_no_quarto()
  skip_if_no_pdflatex()
  testthat::skip_if_not_installed("pdftools")

  prepare_artifacts_dir()

  tmp_out <- file.path(tempdir(), paste0("idpedu-test-", as.integer(runif(1, 1, 1e9))))
  dir.create(tmp_out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp_out, recursive = TRUE, force = TRUE), add = TRUE)
  tasks <- c(
    "https://raw.githubusercontent.com/oduerr/idpedu/master/demo/exercise1.qmd"
  )
  title <- "Week 1 (Simple Stuff)"
  fname <- "wk_remote_stat"
  header_file <- "stat.qmd"

  create_workbook(
    tasks = tasks,
    title = title,
    fname = fname,
    header_file = header_file,
    output_format = c("pdf"),
    output_dir = tmp_out,
    verbose = FALSE
  )

  pdf_file <- file.path(tmp_out, paste0(fname, "_nolsg.pdf"))
  expect_true(file.exists(pdf_file))

  # Copy artifacts for manual inspection
  copy_to_artifacts(c(
    pdf_file,
    file.path(tmp_out, paste0(fname, "_lsg.pdf"))
  ))

  txt <- pdftools::pdf_text(pdf_file)
  expect_true(length(txt) >= 1)
  expect_true(nchar(paste(txt, collapse = "\n")) > 50)
})


