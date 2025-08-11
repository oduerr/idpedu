skip_if_no_quarto <- function() {
  testthat::skip_if(Sys.which("quarto") == "", "quarto not available")
}

skip_if_no_pdflatex <- function() {
  testthat::skip_if(Sys.which("pdflatex") == "", "pdflatex not available")
}


