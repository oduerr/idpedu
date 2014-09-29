if (FALSE) {
  mergeRMD(dir = "~/tmp/", title = "Test", files = c("~/tmp/testMerge/HA01.Rmd", "~/tmp/testMerge/HA02.Rmd"), mergedFileName = "book1.Rmd")
  createAB("~/tmp/book.Rmd")
}

setwd("/Users/oli/Dropbox/__ZHAW/WaST3/__Alle_HS14/__Ich__Wast3.HS14/")
mergeRMD(dir = "Woche1/", title = "Arbeitsblatt 1", 
         files = c("/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe01/Arbeiten_mit_W-Dichten_Call-Center.Rmd",
                   "/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe02//Erwartungswert.Rmd",
                   "/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe03/Auswaehlen_und_Anpassen_von_Verteilungen.Rmd",
                   "/Users/oli/Documents/workspace/wast/wast3/ARBEITSBLATT_01/aufgabe04/Berechnung_von_Erwartungswert_und_Varianz.Rmd"),
         printpaths = TRUE,
         mergedFileName = "ab1.Rmd"
         )
createAB(infile = "/Users/oli/Dropbox/__ZHAW/WaST3/__Alle_HS14/__Ich__Wast3.HS14/Woche1/ab1.Rmd")
