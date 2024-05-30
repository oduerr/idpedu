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



#' Create a workbook by rendering and merging QMD files with Quarto
#' 
#' @param tasks A vector of task file names
#' @param header_file The header file name
#' @param output_format A vector of output formats ("html" and/or "pdf")
#' @param output_dir The directory where the final documents will be saved
#' @export
create_workbook <- function(tasks = c("aufgabe1.qmd", "aufgabe2.qmd"), header_file = "header.qmd", output_format = c("html", "pdf"), output_dir = "output") {
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Create a temporary directory
  temp_dir <- tempfile()
  dir.create(temp_dir)
  
  # Copy the entire contents of the extdata directory to the temporary directory
  copy_extdata(temp_dir)
  
  # Copy the task files to the temporary directory
  copy_tasks(tasks, temp_dir)
  
  # Render each QMD file individually with Quarto
  rendered_files <- c()
  for (task in tasks) {
    task_path <- file.path(temp_dir, basename(task))
    rendered_path <- sub("\\.qmd$", ".md", task_path)
    quarto_render_cmd <- sprintf("quarto render %s --to markdown", task_path)
    system(quarto_render_cmd)
    rendered_files <- c(rendered_files, rendered_path)
  }
  
  # Render the header file with Quarto
  header_path <- file.path(temp_dir, header_file)
  rendered_header_path <- sub("\\.qmd$", ".md", header_path)
  quarto_render_cmd <- sprintf("quarto render %s --to markdown", header_path)
  system(quarto_render_cmd)
  
  # Merge rendered Markdown files into a single workbook
  merged_md_path <- file.path(temp_dir, "arbeitsblatt.md")
  pandoc_cmd <- sprintf(
    "pandoc %s %s --shift-heading-level-by=1 -o %s",
    rendered_header_path,
    paste(rendered_files, collapse = " "),
    merged_md_path
  )
  system(pandoc_cmd)
  
  # Render the merged Markdown file with Quarto
  for (format in output_format) {
    quarto_render_cmd <- sprintf("quarto render %s --to %s", merged_md_path, format)
    system(quarto_render_cmd)
    
    # Copy the final document to the output directory
    output_file <- file.path(temp_dir, paste0("arbeitsblatt.", format))
    file.copy(output_file, file.path(output_dir, paste0("arbeitsblatt.", format)), overwrite = TRUE)
  }
  
  # Delete the temporary directory and all its contents
  unlink(temp_dir, recursive = TRUE)
  
  message("Workbook created and saved in directory '", output_dir, "'.")
}
create_workbook(tasks = c("/Users/oli/Documents/GitHub/da/lab/lr_1_MH_vs_Stan/MH_Stan.qmd"), header_file = "da.qmd", output_format = c("html", "pdf"), output_dir = "output")
