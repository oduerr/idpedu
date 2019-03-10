#################################################
#
#' Merges Rmd-files into a single 'Arbeitsblatt'
#'
#' @param mergedFileName Name of the file containing all merged files, along with its filepath. When filepath is not given, 
#' current working directory is assumed.
#' @param title Title of the merged collection of files (e.g. Arbeitsblattname).
#' @param files List of files containing the Rmd files to be merged. Should be provided as c("file path1","file path2", ...). 
#' See examples on interactive file selection in the details.
#' @param preamble (Optional) File path to the preamble written in plain Rmd file (meta-text, R code allowed). Preamble will be placed before all exercises. Latex packages should be placed in header_lsg.tex.
#' @param print.paths (By default, FALSE) Indicate whether to print paths of each exercise (provided as clickable links in the final pdf document).
#' @param print.newpage (By default, TRUE) Indicate whether to start each exercise from a new sheet.
#' 
#'     
#' @details Merges Rmd files from different locations into one Rmd file. Relies on packages rmarkdown, knitr, devtools, data.table, idpedu (GitHub).
#' 
#' It is important to state **options(useFancyQuotes = FALSE)** before running the function. 
#' It is also preferred to leave free the last line in each .Rmd file to avoid problems with **readLines()** command, which is used in mergeRMD2.
#' The data and figures called in each individual Rmd file must be placed in the same directory as the individual Rmd file.
#' Each exercises with header "Aufgabe" is automatically numbered in the same order as in the **files** argument.
#' 
#' @author Vasily Tolkachev \email{tolk@@zhaw.ch}, Oliver Durr \email{oliver.duerr@@zhaw.ch}
#' 
#' @examples
#' \dontrun{
#'
#'mergeRMD2(mergedFileName = "V:/tolk/Private/PROJECT_02_DUERR/TEST_FILES_2/DUMMY/book4.Rmd",
#'          title = "Arbeitsblatt 1",
#'          files = c("V:/tolk/Private/PROJECT_02_DUERR/TEST_FILES_2/DUMMY/HA01.Rmd", 
#'                    "V:/tolk/Private/PROJECT_02_DUERR/TEST_FILES_2/DUMMY/HA02.Rmd"),
#'          preamble="V:/tolk/Private/PROJECT_02_DUERR/TEST_FILES_2/DUMMY/Preamble.Rmd" ,
#'          print.paths=T, 
#'          print.newpage=T)
#'
#'createAB("V:/tolk/Private/PROJECT_02_DUERR/TEST_FILES_2/DUMMY2/book4.Rmd") 
#' 
#' 
#'#======================================================
#'# Ways to select files and directories
#'          
#'# 1. Interactively choose directory with GUI window, then apply files crawler
#'path1=gsub("\\\\", "/", choose.dir())
#'          
#'## or choose specific files
#'files1=gsub("\\\\", "/", choose.files())
#'          
#'# 2. Replace the address line below with the raw path provided by Windows.
#   'x = readline()
#   'V:\tolk\Private\PROJECT_02_DUERR\_COLLECTION_AUFGABEN\DECOMPOSED          
#   'path1=gsub("\\\\", "/", x)
#   'rm(x)
#'          
#'# 3. Copy the text of the file(directory) path from the desired location and run the following
#' path1=gsub("\\\\", "/", readClipboard())
#'          
#'# Files Crawler
#'  (files1=list.files(path =path1, pattern = "*.Rmd", full.names=TRUE, recursive = TRUE))
#'
#'#======================================================
#'                     
#'          
#'  }


mergeRMD2 = function(mergedFileName = "book.Rmd",title=".", files, preamble, print.paths=FALSE, print.newpage=TRUE) {
  
  dir=dirname(mergedFileName)
  
  old = setwd(dir)
  
  if (file.exists(mergedFileName)) {
    warning(paste0(mergedFileName, " already exists"))
  } 
  
  # _files_ variable to be able to access it from different Rmd files
  
  # Initialise empty character vector to input strings from files later
  text.input = vector("character", 1)
  
  # Introduce Aufgabe names
  task.names=paste0("## Aufgabe ", 1:length(files), ": ")
  
  for(i in 1:length(files)){
    
    # Write files strings into a buffer variable
    text.input=readLines(files[i],warn = FALSE) # ,warn = FALSE
    
    metaspan = grep("---",  text.input) # find the boundaries of meta-text
    
    # Automatic Name Assignment to Aufgaben
    # Insert Aufgabe titles right after the meta-text
    
    # Define insert variable to write 'precode' on top of the final document 
    # (will be erased after each cycle)
    cell.insert=character(length=1)
    
    # Print Aufgabe Names
    j=1
    
    cell.insert[j]=task.names[i]
    
    cell.insert[j+1]="```{r, echo=FALSE, eval=TRUE,comment=NA}" # comment=NA is to hide ## in knitr output 
    
    # Write files variable in the final Rmd document to make it accessable for every r chunk
    cell.insert[j+2]="options(useFancyQuotes = FALSE)" # options for sQuote to print plain quotation marks
    cell.insert[j+3]=paste("files<-c(",paste(sQuote(noquote(files)),collapse=","),")")
    
    # change baseDir for every individual Aufgabe
    cell.insert[j+4]=paste("baseDir=dirname(files[", i , "])") 
    
    cell.insert[j+5]="```"  
    
    if (print.paths==T){
      
      # hyperlink to filepaths (print the last 76 characters)
      
      # cell.insert[j+5]=paste("message(files[",i,"])") # OLD
      cell.insert[j+6]=paste0("\\href{run:`r dirname(files[",i,"])`}{`r paste0(\"...\", gsub(pattern=\"\\\\_\", replacement=\"\\\\\\\\_\",substring(dirname(files[",i,"]),first=nchar(dirname(files[",i,"]))-76,last=nchar(dirname(files[",i,"]))))) `}")
      
    } else {
      cell.insert[j+6]=""
    }
    
    # Insert the precode into text
    # texti= c(values,..., inserted,... values)
    
    text.input = c(text.input[1:metaspan[2]],cell.insert[1:(j+6)],text.input[(metaspan[2]+1):length(text.input)])
    
    # Get rid of the meta-text
    # BEFORE: text = text[-c(metaspan[1]:metaspan[2])]
    
    text.input = text.input[-c(metaspan[1]:metaspan[2])]
    
    
    if (print.newpage==T){
      text.input[length(text.input)+1]="\\newpage"
    } else{
      text.input[length(text.input)+1]=""
    }
    
    text.input[length(text.input)+1]=""
    
    # introduce sequence of variables text.chunk1, texttext.chunk2,... to assign strings from aufgaben
    
    assign(paste0("text.chunk",i),text.input)
    
    # If want to retrieve values for the currently used string from the local environment
    # text.chunk.val.i=get(paste0("text.chunk",i)) 
  }
  
  #================================  
  
  
  text.combined=eval(parse(text=paste0("c(",paste0("text.chunk",1:length(files),collapse=","),")")))
  
  #================================ 
  
  # eval(parse(text="c(noquote(paste0("text",1:2,collapse=",")))"))
  
  # Insert the the metatext for the final Arbeitsblatt
  # Insert title of the final Arbeitsblatt on top, right after the meta text
  
  
  book_header = paste("---\noutput:","pdf_document", "\n---")
  cell.insert2=paste("\\begin{center} \\huge{",title, "} \\end{center}")
  
  # Inserting the preamble (from Rmd file)
  if (!missing(preamble)){
    
    preamble.input = vector("character", 1)
    preamble.input=readLines(preamble)
    
    metaspan = grep("---",  preamble.input) # find the boundaries of meta-text
    preamble.input = preamble.input[-c(metaspan[1]:metaspan[2])]
    
    #     preamble="V:/tolk/Private/PROJECT_02_DUERR/TEST_FILES_2/DUMMY/Preamble.Rmd"
    preamble.input[length(preamble.input)+1]=""
    
    text.final=c(book_header,cell.insert2,preamble.input,text.combined)
    
  } else {
    
    text.final=c(book_header,cell.insert2,text.combined)
  }
  
  
  write(text.final, sep = "\n", file = mergedFileName, append = F)
  
  # Remove variables created by the function
  rm(list=c("text.input","text.final","text.combined", paste0("text.chunk",1:length(files))))
  
  if (!missing(preamble)){
    rm(list=c("preamble","preamble.input"))
  }
  
  
  setwd(old)
}

