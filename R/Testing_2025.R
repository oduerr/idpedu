if (FALSE){
  install.packages(".", repos = NULL, type = "source")
  library(idpedu)
  ### Local Files
  tasks = c(
    "/Users/oli/Documents/GitHub/idpedu/demo/exercise1.qmd"#,
    #"/Users/oli/Documents/GitHub/idpedu/demo/exercise2.qmd"
  ) # list of tasks (can also be a single task)
  
  
  ### Remote Files
  if (FALSE){
    tasks = c(
      #"https://raw.githubusercontent.com/oduerr/idpedu/master/demo/exercise1.qmd"
      #"https://raw.githubusercontent.com/oduerr/idpedu/master/demo/exercise2.qmd"
    ) # list of tasks (can also be a single task)
  }
  
  
  title = "Week 1 (Simple Stuff)" # Title of the worksheet
  fname='week1' # Name of the file(s) which are produces
  
  # Stays the same for all worksheets for a given course
  header_file = "da.qmd" # To change / add go into repository inst/extdata
  create_workbook(tasks=tasks, title = title, fname=fname,  header_file=header_file)
  
  header_file = "stat.qmd" # To change / add go into repository inst/extdata
  create_workbook(tasks=tasks, title = title, fname=fname,  header_file=header_file)
}
    
