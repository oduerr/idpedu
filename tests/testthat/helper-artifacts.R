# Helpers to manage tests/artifacts directory for manual inspection

get_artifacts_dir <- function() {
  file.path(testthat::test_path(".."), "artifacts")
}

prepare_artifacts_dir <- function() {
  dir <- get_artifacts_dir()
  if (dir.exists(dir)) {
    unlink(dir, recursive = TRUE, force = TRUE)
  }
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  dir
}

copy_to_artifacts <- function(paths) {
  dir <- get_artifacts_dir()
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  for (p in paths) {
    if (!file.exists(p)) next

    # Copy the file itself
    file.copy(p, file.path(dir, basename(p)), overwrite = TRUE)

    # If HTML, also copy its resource directory (Quarto)
    if (tolower(tools::file_ext(p)) == "html") {
      parent <- dirname(p)
      base <- tools::file_path_sans_ext(basename(p))
      # Common resource dir names
      candidates <- c(
        file.path(parent, "merged_files"),
        file.path(parent, sprintf("%s_files", base))
      )
      for (cand in candidates) {
        if (dir.exists(cand)) {
          file.copy(cand, file.path(dir, basename(cand)), recursive = TRUE, overwrite = TRUE)
        }
      }
    }
  }
  invisible(TRUE)
}


