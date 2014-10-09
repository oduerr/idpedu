if (FALSE) {
  mergeRMD(dir = "~/tmp/", title = "Test", files = c("~/tmp/testMerge/HA01.Rmd", "~/tmp/testMerge/HA02.Rmd"), mergedFileName = "book1.Rmd")
  createAB("~/tmp/book.Rmd")
}

if (FALSE) {
  setwd("/Users/oli/Dropbox/__ZHAW/WaST3/__Alle_HS14/__Ich__Wast3.HS14/")
  mergeRMD(dir = "Woche1/", title = "Arbeitsblatt 1", 
           files = c("/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe01/Arbeiten_mit_W-Dichten_Call-Center.Rmd",
                     "/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe02//Erwartungswert.Rmd",
                     "/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe03/Auswaehlen_und_Anpassen_von_Verteilungen.Rmd",
                     "/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe04/Berechnung_von_Erwartungswert_und_Varianz.Rmd"),
           printpaths = FALSE,
           mergedFileName = "ab1.Rmd"
           )
  createAB(infile = "/Users/oli/Dropbox/__ZHAW/WaST3/__Alle_HS14/__Ich__Wast3.HS14/Woche1/ab1.Rmd")
  rmdFiles <- list.files(path = "/Users/oli/Documents/workspace/wast/wast3/", pattern = "*.Rmd", recursive = TRUE)
  
  
  
  # Nice trick from Vasily for our windows users...
  # x = readline()
  # V:\tolk\Private\PROJECT_02_DUERR\_COLLECTION_AUFGABEN\DECOMPOSED
  # path1=gsub("\\\\", "/", x)
  # rm(x)
  
  # File Crawler
  rootDir = "/Users/oli/Documents/workspace/wast/wast3/"
  (files1=list.files(path =rootDir, pattern = "*.Rmd", full.names=TRUE, recursive = TRUE))
  preamble= "/Users/oli/Documents/workspace/wast/Preamble/Preamble.Rmd"
  
  # An Example use case
  options(useFancyQuotes = FALSE)
  mergeRMD2(mergedFileName = "/Users/oli/tmp/All.Rmd",
            files = files1, 
            title = "A Collection of all Arbeitsblaetter", 
            print.paths = TRUE, 
            print.newpage = TRUE, 
            preamble = preamble     
  )
  createAB(infile = "/Users/oli/tmp/All.Rmd")
}