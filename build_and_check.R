#############################################
### PLEASE RESTART R BEFORE RUNNING THIS SCRIPT ###
#############################################

# Load necessary libraries
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
library(devtools)

if (!requireNamespace("roxygen2", quietly = TRUE)) {
  install.packages("roxygen2")
}
library(roxygen2)

# Document the package
roxygenize()

# Build the package
build()

# Check the package
check()

# Optionally, install the package locally
install()



