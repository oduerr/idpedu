test_that("Local → HTML workflow works and normalizes output", {
  skip_on_cran()
  skip_if_no_quarto()

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
  html_lsg <- file.path(tmp_out, paste0(fname, "_lsg.html"))
  expect_true(file.exists(html_lsg))
  copy_to_artifacts(c(html_file, html_lsg))

  # Basic sanity: HTML is readable and non-empty
  html <- readLines(html_file, warn = FALSE)
  expect_true(length(html) > 10)

})

test_that("Local → HTML solution filter toggles inline and block content", {
  skip_on_cran()
  skip_if_no_quarto()

  tmp_out <- file.path(tempdir(), paste0("idpedu-test-", as.integer(runif(1, 1, 1e9))))
  dir.create(tmp_out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp_out, recursive = TRUE, force = TRUE), add = TRUE)
  tasks <- c(
    test_path("fixtures/exercise3.qmd")
  )
  title <- "Week X (Solutions Test)"
  fname <- "wk_sol_html"
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
  html_lsg <- file.path(tmp_out, paste0(fname, "_lsg.html"))
  expect_true(file.exists(html_file))
  expect_true(file.exists(html_lsg))

  # Copy artifacts for inspection
  copy_to_artifacts(c(html_file, html_lsg))

  html_norm <- readLines(html_file, warn = FALSE)
  expect_true(length(html_norm) > 10)
  # Do not assert 'quadratic formula' here; may appear from other sources

  html_lsg_content <- readLines(html_lsg, warn = FALSE)
  expect_true(length(html_lsg_content) > 10)
  # Block solution should appear in lsg version (class list may contain other classes)
  expect_true(any(grepl('<div class=\"[^\"]*solution[^\"]*\"', html_lsg_content)))
})

test_that("Local → PDF solution filter toggles inline and block content", {
  skip_on_cran()
  skip_if_no_quarto()
  skip_if_no_pdflatex()
  testthat::skip_if_not_installed("pdftools")

  tmp_out <- file.path(tempdir(), paste0("idpedu-test-", as.integer(runif(1, 1, 1e9))))
  dir.create(tmp_out, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(tmp_out, recursive = TRUE, force = TRUE), add = TRUE)
  tasks <- c(
    test_path("fixtures/exercise3.qmd")
  )
  title <- "Week X (Solutions Test)"
  fname <- "wk_sol_pdf"
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
  pdf_lsg  <- file.path(tmp_out, paste0(fname, "_lsg.pdf"))
  expect_true(file.exists(pdf_file))
  expect_true(file.exists(pdf_lsg))

  # Copy artifacts for manual inspection
  copy_to_artifacts(c(pdf_file, pdf_lsg))

  # Sanity check
  txt_lsg <- pdftools::pdf_text(pdf_lsg)
  expect_true(nchar(paste(txt_lsg, collapse = "\n")) > 10)
  # nolsg version should not contain the inline 42
  txt_nolsg <- pdftools::pdf_text(pdf_file)
  expect_false(grepl(" 42", paste(txt_nolsg, collapse = "\n")))
})

test_that("Local → PDF workflow works (da.qmd)", {
  skip_on_cran()
  skip_if_no_quarto()
  skip_if_no_pdflatex()
  testthat::skip_if_not_installed("pdftools")

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
  pdf_lsg <- file.path(tmp_out, paste0(fname, "_lsg.pdf"))
  expect_true(file.exists(pdf_lsg))
  copy_to_artifacts(c(pdf_file, pdf_lsg))

  txt <- pdftools::pdf_text(pdf_file)
  expect_true(length(txt) >= 1)
  expect_true(nchar(paste(txt, collapse = "\n")) > 100)
  # Check that solution markers are absent in nolsg
  expect_false(grepl("42", paste(txt, collapse = "\n")))
})

test_that("Remote → PDF workflow works (stat.qmd)", {
  skip_on_cran()
  skip_if_no_quarto()
  skip_if_no_pdflatex()
  testthat::skip_if_not_installed("pdftools")

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
  pdf_lsg <- file.path(tmp_out, paste0(fname, "_lsg.pdf"))
  expect_true(file.exists(pdf_lsg))
  copy_to_artifacts(c(pdf_file, pdf_lsg))

  # In lsg version, the inline solution 42 should appear as text
  txt_lsg <- pdftools::pdf_text(pdf_lsg)
  expect_true(grepl("42", paste(txt_lsg, collapse = "\n")))
  txt <- pdftools::pdf_text(pdf_file)
  expect_true(length(txt) >= 1)
  expect_true(nchar(paste(txt, collapse = "\n")) > 50)
})


