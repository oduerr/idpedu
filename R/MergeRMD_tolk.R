# install.packages('rmarkdown')
# install.packages('gdata') # package for keep function


# library(rmarkdown)


# setwd('V:/tolk/Private/PROJECT 02 O. DUERR/TEST FILES')

#################################################
#
#' Takes several rmd-files and merge it into a single file
#'
#' @param dir a temporary working directort
#' @param title of the exercise sheet
#' @param files a list of files containing the rmd-files which will be merged. Should be provided as c("file path1","file path2", ...)
#' 
#'  To create a list of files with names following some pattern one can use.(pattern=regular expression)
#'  files = list.files(path='V:/tolk/Private/PROJECT 02 O. DUERR/TEST FILES',pattern = "HA0[1-2].Rmd")
#'  
#'  
mergeRMD = function(dir = ".",title=".", files, printpaths=FALSE, mergedFileName = "book.Rmd") {
  book_header = paste("---\ntitle:",title, "\n---")
  old = setwd(dir)
  
  if (file.exists(mergedFileName)) {
    warning(paste0(mergedFileName, " already exists"))
  } 
  write(book_header, file = mergedFileName)
  
  # _files_ variable to be able to access it from different Rmd files
  
  
  # Introduce Aufgabe names
  task.names=paste0("##Aufgabe ", 1:length(files))
  
  # Introduce a (character) vector of baseDir addresses 
  dir.insert=character(length=length(files))
  
  # dir.insert=list(matrix(nrow=1,ncol=length(files),dimnames=NULL))
  
  for(i in 1:length(files)){
    text = readLines(files[i])
    metaspan = grep("---", text) # find the boundaries of meta-text
    # TODO tolk pls invetigate if '---' is allowed in Rmd outside meta text
    # Dashes in the text do not affect the outcome, since for each aufgabe, we take the lines between metaspan[1] and metaspan[2].        
    
    # Automatic Name Assignment to Aufgaben
    # Insert Aufgabe titles right after the meta-text
    
    # Define insert variable to write 'precode' on top of the final document 
    # (will be erased after each cycle)
    cell.insert=character(length=1)
    
    # Print Aufgabe Names
    cell.insert[1]=task.names[i]
    
    cell.insert[2]="```{r, echo=FALSE, eval=TRUE,comment=NA} " # comment=NA is to hide ## in knitr output 
    
    # Write files variable in the final Rmd document to make it accessable for every r chunk
    cell.insert[3]="options(useFancyQuotes = FALSE)" # options for sQuote to print plain quotation marks
    cell.insert[4]=paste("files<-c(",paste(sQuote(noquote(files)),collapse=","),")")
    
    # DONE TODO: tolk pls make the baseDir in each aufgabe pointing to the directory the file came from.             
    # change baseDir for every individual Aufgabe
    cell.insert[5]=paste("baseDir=dirname(files[", i , "])") 
    
    # DONE TODO: tolk make option to print out filepath for each aufgabe after aufgabe name            
    # Print Aufgabe file paths depending on the printpaths variable (default is print)
    if (printpaths==T){
      #cell.insert[6]=paste("cat(format(files[",i,"]))")
      # TODO print the last 80 characters, be careful and check
      cell.insert[6]=paste("message(files[",i,"])")
    } else {
      cell.insert[6]=""
    }
    
    cell.insert[7]="```"

    text = c(text[1:metaspan[2]],cell.insert[1:7],text[(metaspan[2]+1):length(text)])
    # text = c(text[1:metaspan[2]],task.names[i],files[i],dir.insert[i],text[(metaspan[2]+1):length(text)])
    text = text[-c(metaspan[1]:metaspan[2])] # get rid of the meta-text
   
    # TODO [Optional] Decide if we want to eliminate the newly written global variables
    # Delete all variables except lsg and baseDir 
    # to avoid variable conflict across files
    # text[length(text)+1]="```{r, echo=FALSE, eval=TRUE}"
    #text[length(text)+1]="rm(list=setdiff(objects(),c('lsg','baseDir')))"
    # text[length(text)+1]="```"      

    write(text, sep = "\n", file = mergedFileName, append = T) # sep = "\n" for newline sepation
  }
  
  
  
  # Render the input file to the specified output format using pandoc        
  # render("book.Rmd", output_format = "pdf_document")
  setwd(old)
}

