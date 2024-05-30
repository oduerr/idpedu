#################################################
#
#' Creates a "Arbeitsblatt" with and without solution from a Rmd-file
#'
#' @param infile the rmarkdown description file
#
# @export
#
createAB.old <- function(infile) {
  library(rmarkdown)
  library(tools)
  header_lsg =  system.file("rmarkdown/templates/aufgabe/skeleton/header_lsg.tex", package = "idpedu")
  header_nolsg =  system.file("rmarkdown/templates/aufgabe/resources/header_nolsg.tex", package = "idpedu")
  before_body = system.file("rmarkdown/templates/aufgabe/resources/before_body.tex", package = "idpedu")
  
  inc = includes(before_body = before_body, in_header = header_lsg) 
  lsg <- TRUE
  output_file_base = basename(file_path_sans_ext(infile))
  
  # What happens under the hut?
  # render is from the rmarkdown packages
  # It takes the rmd and creates an md-file with knitr
  # Then it takes the md-file and creates an output 
  render(input = infile, pdf_document(includes = inc), output_file = paste0(output_file_base, "_lsg.pdf"), encoding = "UTF-8")
  lsg <- FALSE
  inc = includes(before_body = before_body, in_header = header_nolsg)
  render(input = infile, pdf_document(includes = inc), output_file = paste0(output_file_base, "_nolsg.pdf"), encoding = "UTF-8")
}