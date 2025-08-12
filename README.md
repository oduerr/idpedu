idpedu
======

Usefull tools for teaching statistics.

## To install the packages

```r
  library(devtools)  # You might need to install devtools first
  install_github("oduerr/idpedu") 
  library(idpedu)
```

## Compile a worksheet
The new command `create_workbook` renders HTML and PDF files from a list of tasks. Example tasks (`exercise1.qmd`, `exercise2.qmd`, `exercise3.qmd`) live under the repository fixtures:


### Example tasks:
- Example tasks (fixtures): https://github.com/oduerr/idpedu/tree/master/tests/testthat/fixtures
- Raw links for remote usage:
  - https://raw.githubusercontent.com/oduerr/idpedu/master/tests/testthat/fixtures/exercise1.qmd
  - https://raw.githubusercontent.com/oduerr/idpedu/master/tests/testthat/fixtures/exercise2.qmd
  - https://raw.githubusercontent.com/oduerr/idpedu/master/tests/testthat/fixtures/exercise3.qmd


### Tips for developing the worksheets:

#### Include solutions in the worksheet 

- Inline (recommended for short answers):
```r
[Solution. The quadratic formula is $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$.]{.solution}
```

- Block (for longer solutions):
```r
::: {.solution}
This is a block solution with math: $a^2 + b^2 = c^2$.
:::
``` 
(see below).

#### Code chunks

- Use `echo=lsg` and/or `eval=lsg` to control the visibility of the solutions.

```
  ```{r, echo=lsg, eval=lsg}
  # Code chunk with solutions
  ```










- Use the `quarto` package to preview the changes. RStudio will do as well. Much faster then compiling 'pdf'
```bash
quarto preview tests/testthat/fixtures/exercise1.qmd
```


### Compile a worksheet
```r
  
  ### Local Files (if you cloned the repo)
  tasks = c(
   "tests/testthat/fixtures/exercise1.qmd",
   "tests/testthat/fixtures/exercise2.qmd"
  ) # list of tasks (can also be a single task)
  
  ### Remote Files (alternatively)
  tasks = c(
   "https://raw.githubusercontent.com/oduerr/idpedu/master/tests/testthat/fixtures/exercise1.qmd",
   "https://raw.githubusercontent.com/oduerr/idpedu/master/tests/testthat/fixtures/exercise2.qmd"
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
quarto preview tests/testthat/fixtures/exercise1.qmd
```

## Thinks to consider

### Selfcontained
The html files are rendered to be selfcontained. This means that the images are embedded in the html file. This is good for distribution, but bad for the size of the html file. If you want to reduce the size of the html file you can use the `selfcontained = FALSE` option in create_workbook. While being selfcontained these file are not rendered as html in github, you have to dowload then.

### Adding a custom header
The header file is a markdown file which is included at the beginning of the worksheet. Add a custom qmd-file like `custom.qmd` in the inst/extdata folder exchange `header_file = "custom.qmd"`


## Tips for developing the package:
You can use `devtools::load_all()` to load the chances.


















