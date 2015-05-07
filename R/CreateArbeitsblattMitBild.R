#################################################
# 
#' Exercises out of Rmd-files.
#' 
#' @param infile the rmarkdown description file
#' @param wast1 if TRUE a wast1 Arbeitsblatt will be build
#' 
#' @details Creates 2 excersis sheets from a r-makeup file. In this version the compiling happens in a 
#' temporary folder. Which is benificial if you use e.g. dropbox.
#' 
#' 
createAB <- function(infile, wast1 = FALSE, wastNum=-1) {
  library(rmarkdown)
  library(tools)
  
  # infile = system.file("rmarkdown/templates/aufgabe/skeleton/skeleton.Rmd", package = "wast")
  infile = normalizePath(infile) #We need the absolute path
  baseDir = dirname(infile)
    
  header_lsg =  system.file("rmarkdown/templates/aufgabe/skeleton/header_lsg.tex", package = "idpedu")
  header_nolsg =  system.file("rmarkdown/templates/aufgabe/resources/header_nolsg.tex", package = "idpedu")
  img = system.file("rmarkdown/templates/aufgabe/resources/logo.jpg", package = "idpedu")
  if (wastNum < 0) {
    if (wast1) {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img_wast1.tex", package = "idpedu")
    } else {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img.tex", package = "idpedu")
    }
  } else {
    if (wastNum == 1) {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img_wast1.tex", package = "idpedu")
    } else if (wastNum == 2) {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img_wast2.tex", package = "idpedu")
    } else if (wastNum == 3) {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img.tex", package = "idpedu")
    } else if (wastNum == 4) {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img_stop.tex", package = "idpedu")
    } else if (wastNum == 10) {
      before_body_img = system.file("rmarkdown/templates/aufgabe/resources/before_body_img_cas.tex", package = "idpedu")
      img = system.file("rmarkdown/templates/aufgabe/resources/logo_cas.png", package = "idpedu")
    }
  }
  header_nolsg =  system.file("rmarkdown/templates/aufgabe/resources/header_nolsg.tex", package = "idpedu")
  template <-  system.file(
    "rmarkdown/templates/aufgabe/resources/template.tex", 
    package = "idpedu"
  )
  
  # Creating new directory and copying all the stuff into that directory
  oldDir = getwd()
  td = tempdir()
  print(paste0("  Creating temporary files in ", td))
  toRemove = {}
  stopifnot(file.copy(header_lsg, to=td))
  toRemove = append(toRemove, header_lsg)
  stopifnot(file.copy(header_nolsg, to=td))
  toRemove = append(toRemove, header_nolsg)
  stopifnot(file.copy(before_body_img, to=td))
  toRemove = append(toRemove, before_body_img)
  stopifnot(file.copy(img, to=td))
  toRemove = append(toRemove, img)
  stopifnot(file.copy(infile, to=td))
  toRemove = append(toRemove, infile)
  
  changedDir = FALSE
  tryCatch(
  {
    setwd(td)
    changedDir = TRUE
    output_file_base = basename(file_path_sans_ext(infile))
    
    # Creating the non-lsg file
    lsg <- FALSE
    inc = includes(before_body = before_body_img, in_header = header_nolsg)
    output_file = paste0(output_file_base, "_nolsg.pdf")
    render(input = basename(infile), pdf_document(includes = inc), output_file = output_file , encoding = "UTF-8")
    toRemove = append(toRemove, output_file)
    file.copy(output_file, to=dirname(infile), overwrite = TRUE)

    # Creating the lsg-file
    inc = includes(before_body = basename(before_body_img), in_header = basename(header_lsg))
    lsg <- TRUE
    output_file = paste0(output_file_base, "_lsg.pdf")
    render(input = basename(infile), pdf_document(includes = inc), output_file = output_file, encoding = "UTF-8")
    toRemove = append(toRemove, output_file)
    dirname(infile)
    file.copy(output_file, to=dirname(infile), overwrite = TRUE)
    
  }
  ,finally = {
    #TODO delete old files
    if (changedDir) {
      file.remove(basename(toRemove))
      rm(baseDir)
      print("Removed old stuff")
    }
    setwd(oldDir) 
  }
  )
  
}


##################################################
# Cleaning the headers
sanitize_headings <- function(filename) {
  text<-readLines(filename,warn=F) 
  lin<-grep("##",text)
  n<-length(lin)/2
  for (i in 1:n){
    line.aufg<-lin[2*(i-1)+1]
    line.tit<-lin[2*i]
    text[line.tit]<-paste0(text[line.aufg],gsub("##","",text[line.tit]))
    text[line.aufg]<-""
  }
  cat(text,file=filename,sep="\n")
}



