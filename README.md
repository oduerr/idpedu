idpedu
======

Usefull tools for teaching statistics.

To install the packages
```r
  library(devtools)  # You might need to install devtools first
  install_github("oduerr/idpedu") 
  library(idpedu)
```

Compile an worksheet:
```r
  tasks = c("~/Documents/GitHub/da/lab/lr_1_MH_vs_Stan/MH_Stan.qmd") # list of tasks (can also be one)
  title = "Bayesian Inference" # Title of the worksheet
  # Stays the same for all worksheets for a given course
  header_file = "da.qmd" # To change / add go into repository inst/extdata
  fname='09_bayes3'
  output_format = c("html", "pdf") # Output format only html and pdf supported at the moment
  create_workbook(tasks=tasks, title = title, fname=fname,  header_file=header_file, output_format=output_format)
```