% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CreateArbeitsblattMitBild.R
\name{createAB}
\alias{createAB}
\title{Exercises out of Rmd-files.}
\usage{
createAB(infile, wast1 = FALSE, wastNum = -1)
}
\arguments{
\item{infile}{the rmarkdown description file}

\item{wast1}{if TRUE a wast1 Arbeitsblatt will be build}
}
\description{
Exercises out of Rmd-files.
}
\details{
Creates 2 excersis sheets from a r-makeup file. In this version the compiling happens in a 
temporary folder. Which is benificial if you use e.g. dropbox.
}
