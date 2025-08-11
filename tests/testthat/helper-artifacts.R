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
    if (file.exists(p)) {
      file.copy(p, file.path(dir, basename(p)), overwrite = TRUE)
    }
  }
  invisible(TRUE)
}


