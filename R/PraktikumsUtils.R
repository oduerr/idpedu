#################################################
#
#' Creates an "Ankreuzblatt" from a file containing the student names
#' 
#' @param infile tab-delimited file containig the name of the stundent col 1 and how often he showed his excercise
#' @param outfile the name of the output file
#' @param header the column names of the sheet e.g. header = c("Aufgabe 1 a", "Aufgabe 1 b")
#' @param name the name of the sheet 
#'  
createAnkreuzBlatt <- function(infile, output_file, header, name) {
    oldDir = getwd()
    td = tempdir()
    setwd(td)
    
    print(paste0("  Creating temporary files in ", td))
    name.title = paste0("\\section*{", name, "}")
    df <- read.delim2(infile, header = FALSE, stringsAsFactors = FALSE)
    names <- df[,1]
    anz.vorgerechet <- df[,2]
    library(xtable)    
    library(rmarkdown)
    str = paste("\\documentclass[a4paper]{article}", "\\usepackage[a4paper]{geometry}", 
                "\\usepackage[utf8]{inputenc}", "\\usepackage{rotating}", 
                "\\setlength{\\voffset}{0.5cm}", "\\setlength{\\headheight}{0.01cm}",
                "\\setlength{\\textheight}{30cm}",
                "\\begin{document}", name.title, "<<echo=FALSE, eval=TRUE, results = \"asis\">>=", 
                "options(xtable.comment = FALSE)", "df.out <- data.frame(matrix(nrow = length(names), ncol = length(header))) ", 
                "colnames(df.out) <- header", "rownames(df.out) <- names", 
                "df.out$anz.vorgerechet <- anz.vorgerechet", "tab <- xtable(df.out, align = rep('|l', ncol(df.out)+1))", 
                "print((tab), rotate.colnames=TRUE, hline.after=-1:nrow(df.out), scalebox=1.2)", 
                "@", "\\end{document}", sep = "\n")
    cat(str, file = "dumm.Rnw")
    output = "dumm.tex"
    library('knitr')
    knit(input = "dumm.Rnw", output = output)
    system(paste0("pdflatex ", output)) 
    file.copy(from = "dumm.pdf", to=output_file, overwrite = TRUE)
    
    setwd(oldDir) 
}

#################################################
#' Picks a student by random from a file containing the student names and how often they have shown their solution
#' @param infile the file containing the names and how often they have shown their solution
randomPick <- function (infile) {
  df <- read.delim2(infile, header = FALSE, stringsAsFactors = FALSE)
  names <- df[,1]
  anz.vorgerechet <- df[,2]
  p <- (1 /(anz.vorgerechet + 1)) ^ 4 
  p <- p / sum(p)
  print(sample(x = names, size = 1, prob = p))
}

# For debugging
if (FALSE) {
  infile = "/Users/oli/Dropbox/__ZHAW/WaST3/__Alle_HS14/__Ich__Wast3.HS14/Teilnehmer_w2.txt"
  output_file = "/Users/oli/Dropbox/__ZHAW/WaST3/__Alle_HS14/__Ich__Wast3.HS14/Teilnehmer_w2.pdf"
  header = c( "Aufgabe 1 Vektoren", "Aufgabe 1 Matrixen", 
              "Aufgabe 1 Listen", "Aufgabe 2 Dataframes", 
              "Aufgabe 2 Einfache Statistische", "Aufgabe 3", 
              "Aufgabe 4 a", "Aufgabe 4 b")
  name = "Praktikum Loesungen Woche 1"
  createAnkreuzBlatt(infile = infile, output_file = output_file, header = header, name = name)
  for (i in 1:10) randomPick(infile)
}




