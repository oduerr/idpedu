idpedu
======

Usefull tools for teaching statistics.

## To install the packages

```r
  install.packages("https://github.com/oduerr/idpedu/releases/download/quarto_1st/idpedu_0.1.tar.gz", repos = NULL, type = "source")
  #library(devtools)  # You might need to install devtools first
  #install_github("oduerr/idpedu") 
  library(idpedu)
```

## Compile an worksheet.
The new command `create_workbook` renders html and pdf files from a list of tasks. The tasks `exercise1.qmd`, `exercise2.qmd` can be found at <https://github.com/oduerr/idpedu/tree/master/demo> along with the rendered html and pdf files.

```r
  ### Local Files
  tasks = c(
   "/Users/oli/Documents/GitHub/idpedu/demo/exercise1.qmd",
   "/Users/oli/Documents/GitHub/idpedu/demo/exercise2.qmd"
  ) # list of tasks (can also be a single task)
  
  ### Remote Files
  tasks = c(
   "https://raw.githubusercontent.com/oduerr/idpedu/master/demo/exercise1.qmd",
   "https://raw.githubusercontent.com/oduerr/idpedu/master/demo/exercise2.qmd"
  ) # list of tasks (can also be a single task)
  
  
  title = "Week 1 (Simple Stuff)" # Title of the worksheet
  fname='week1' # Name of the file(s) which are produces
  
  # Stays the same for all worksheets for a given course
  header_file = "da.qmd" # To change / add go into repository inst/extdata
  
  create_workbook(tasks=tasks, title = title, fname=fname,  header_file=header_file)
```

## Tips for developing the worksheets:

- Use the `quarto` package to preview the changes. RStudio will do as well. Much faster then compiling 'pdf'
```bash
quarto preview exercise1.qmd
```

## Thinks to consider

### Selfcontained
The html files are rendered to be selfcontained. This means that the images are embedded in the html file. This is good for distribution, but bad for the size of the html file. If you want to reduce the size of the html file you can use the `selfcontained = FALSE` option in create_workbook. While being selfcontained these file are not rendered as html in github, you have to dowload then.

### Adding a custom header
The header file is a markdown file which is included at the beginning of the worksheet. Add a custom qmd-file like `custom.qmd` in the inst/extdata folder exchange `header_file = "custom.qmd"`




















