#' Copy the entire contents of the extdata directory
#' 
#' @param temp_dir The temporary directory to which the files will be copied
copy_extdata <- function(temp_dir) {
  extdata_path <- system.file("extdata", package = "idpedu")
  file.copy(list.files(extdata_path, full.names = TRUE), temp_dir, recursive = TRUE, overwrite = TRUE)
}

#' Copy the task files to the temporary directory
#' 
#' @param tasks A vector of task file names
#' @param temp_dir The temporary directory to which the files will be copied
copy_tasks <- function(tasks, temp_dir) {
  for (task in tasks) {
    file.copy(task, file.path(temp_dir, basename(task)), overwrite = TRUE)
  }
}

#' Remove YAML header from a QMD file content
#' 
#' @param lines A vector of lines from a QMD file
#' @return A vector of lines with the YAML header removed
remove_yaml_header <- function(lines) {
  in_yaml <- FALSE
  result <- c()
  for (line in lines) {
    if (grepl("^---\\s*$", line)) {
      in_yaml <- !in_yaml
      next
    }
    if (!in_yaml) {
      result <- c(result, line)
    }
  }
  return(result)
}

#' Create a workbook by merging QMD files and rendering them with Quarto
#' 
#' @param tasks A vector of task file names
#' @param title The title of the workbook
#' @param fname The base file name for the final documents
#' @param header_file The header file name
#' @param output_format A vector of output formats ("html" and/or "pdf")
#' @param output_dir The directory where the final documents will be saved
#' @param lsg_param The parameter to control the visibility of solutions
#' @param selfcontained A boolean to determine if the output should be self-contained
#' @export
create_workbook <- function(
    tasks = c("aufgabe1.qmd", "aufgabe2.qmd"), 
    title = title,
    fname='09_bayes3', 
    header_file = "ab.qmd", 
    output_format = c("html", "pdf"), 
    output_dir = ".", 
    selfcontained = TRUE,
    verbose = TRUE
    ){
  
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Create a temporary directory
  temp_dir <- tempfile()
  dir.create(temp_dir)
  
  if (verbose) message("Temporary directory created: '", temp_dir, "'.")
  
  # Copy the entire contents of the extdata directory to the temporary directory
  copy_extdata(temp_dir)
  
  # Copy the task files to the temporary directory
  copy_tasks(tasks, temp_dir)
  
  # Read and prepare the header file content
  header_path <- file.path(temp_dir, header_file)
  header_content <- readLines(header_path)
  title_line <- paste0("# ", title)
  
  # Combine the title, header file content, and tasks, removing YAML headers
  merged_qmd_path <- file.path(temp_dir, "merged.qmd")
  cat(header_content, sep = "\n", file = merged_qmd_path)
  cat("\n", file = merged_qmd_path, append = TRUE)
  cat(title_line, sep = "\n", file = merged_qmd_path, append = TRUE)
  cat("\n", file = merged_qmd_path, append = TRUE)
  
  for (task in tasks) {
    task_lines <- readLines(file.path(temp_dir, basename(task)))
    task_lines <- remove_yaml_header(task_lines)
    cat(task_lines, sep = "\n", file = merged_qmd_path, append = TRUE)
    cat("\n", file = merged_qmd_path, append = TRUE)
  }
  
  # Render the merged QMD document with Quarto, passing the parameter for lsg
  for (lsg in c(FALSE, TRUE)){
    for (format in output_format) {
      if (format == "html" && selfcontained) {
        quarto_render_cmd <- sprintf("quarto render %s --to %s -P lsg=%s --self-contained", merged_qmd_path, format, ifelse(lsg, "true", "false"))
      } else {
        quarto_render_cmd <- sprintf("quarto render %s --to %s -P lsg=%s", merged_qmd_path, format, ifelse(lsg, "true", "false"))
      }
      system(quarto_render_cmd)
      output_file <- file.path(temp_dir, paste0("merged.", format))
      # Check if the output file exists
      if (!file.exists(output_file)) {
        stop("Error: Output file not found: ", output_file)
      }
      
      
      lsg_suffix <- ifelse(lsg, "lsg", "nolsg")
      final_output_file <- file.path(output_dir, paste0(fname, '_', lsg_suffix, ".", format))
      # Copy the final document to the output directory
      file.copy(output_file, file.path(final_output_file), overwrite = TRUE)
      
      message("Output file saved as '", final_output_file, "'.")
    } # end format loop
  } # end lsg loop
  
  # Delete the temporary directory and all its contents
  unlink(temp_dir, recursive = TRUE)
  
  message("Workbook created and saved in directory '", output_dir, "'.")
}

if (FALSE){
  tasks = c("~/Documents/GitHub/da/lab/lr_1_MH_vs_Stan/MH_Stan.qmd") # list of tasks (can also be one)
  title = "Bayesian Inference" # Title of the worksheet
  # Stays the same for all worksheets for a given course
  header_file = "da.qmd" # To change / add go into repository inst/extdata
  fname='09_bayes3'
  output_format = c("html", "pdf") # Output format only html and pdf supported at the moment 
  create_workbook(tasks=tasks, title = title, fname=fname,  header_file=header_file, output_format=output_format)
}
