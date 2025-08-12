#' Copy the entire contents of the extdata directory
#' 
#' @param temp_dir The temporary directory to which the files will be copied
copy_extdata <- function(temp_dir) {
  extdata_path <- system.file("extdata", package = "idpedu")
  file.copy(list.files(extdata_path, full.names = TRUE), temp_dir, recursive = TRUE, overwrite = TRUE)
}

#' Copy the task files to the temporary directory
#' 
#' @param tasks A vector of task file names or URLs
#' @param temp_dir The temporary directory to which the files will be copied
copy_tasks <- function(tasks, temp_dir) {
  for (task in tasks) {
    if (grepl("^https?://", task)) {
      # If the task is a URL, download it
      message("Downloading task from URL: '", task, "'.")
      utils::download.file(task, destfile = file.path(temp_dir, basename(task)), mode = "wb")
    } else {
      # Otherwise, copy it from the local file system
      file.copy(task, file.path(temp_dir, basename(task)), overwrite = TRUE)
    }
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
#' @param selfcontained A boolean to determine if the output should be self-contained
#' @param verbose Logical flag to print progress messages during rendering
#' @param execute_dir Optional path used as the execution directory for Quarto.
#' @export
#' @examples NULL
create_workbook <- function(
    tasks = c("aufgabe1.qmd", "aufgabe2.qmd"), 
    title = title,
    fname='09_bayes3', 
    header_file = "ab.qmd", 
    output_format = c("html", "pdf"), 
    output_dir = ".", 
    selfcontained = TRUE,
    verbose = TRUE,
    execute_dir = "project"
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
  # htwg_logo.png, da.qmd, stat.qmd, and other files
  copy_extdata(temp_dir)
  
  # Copy the task files to the temporary directory
  copy_tasks(tasks, temp_dir)
  
  # Guessing the project directory
  if (execute_dir == "project") {
  execute_dir <- rprojroot::find_root(
      rprojroot::has_file_pattern('\\.Rproj$') |
        rprojroot::has_file('_quarto.yml') |
        rprojroot::is_r_package
    )
  }
  if (verbose) message("Project directory (guessed): '", execute_dir, "'.")


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
      # Build Quarto command with optional execute-dir
      # Export lsg flag to child process as env for robust detection in Lua filter
      Sys.setenv(IDPEDU_LSG = ifelse(lsg, "true", "false"))

      args <- c(
        "quarto", "render", merged_qmd_path,
        "--to", format,
        "-P", sprintf("lsg=%s", ifelse(lsg, "true", "false"))
      )
      # Ensure the solution filter is applied if available in temp_dir
      sol_filter <- file.path(temp_dir, "solution.lua")
      if (file.exists(sol_filter)) {
        args <- c(args, "--lua-filter", sol_filter)
      }
      if (format == "html" && selfcontained) args <- c(args, "--self-contained")
      if (!is.null(execute_dir)) args <- c(args, "--execute-dir", execute_dir)
      quarto_render_cmd <- paste(shQuote(args), collapse = " ")
      if (verbose) message("Running command: '", quarto_render_cmd, "'.")
      res <- system(quarto_render_cmd, intern = TRUE, ignore.stderr = FALSE, ignore.stdout = FALSE)
      if (!is.null(attr(res, "status")) && attr(res, "status") != 0) {
        message("Error: The following command failed:\n  ", quarto_render_cmd)
        message("Output:\n", paste(res, collapse = "\n"))
      }
      
      
      output_file <- file.path(temp_dir, paste0("merged.", format))
      # Check if the output file exists
      if (!file.exists(output_file)) {
        stop("Error: Output file not found: ", output_file)
      }
 
      # If HTML is not self-contained, also copy the resource directory (e.g., merged_files)
      if (identical(format, "html") && isFALSE(selfcontained)) {
        resources_dir <- file.path(temp_dir, "merged_files")
        if (dir.exists(resources_dir)) {
          # Copy to output_dir keeping the same directory name referenced by the HTML
          file.copy(resources_dir, file.path(output_dir, basename(resources_dir)), recursive = TRUE, overwrite = TRUE)
        }

        # Copy any other local assets referenced by the HTML (e.g., images like htwg_logo.png)
        html_lines <- tryCatch(readLines(output_file, warn = FALSE), error = function(e) character())
        if (length(html_lines) > 0) {
          refs <- unique(c(
            unlist(regmatches(html_lines, gregexpr('src=\"([^\"]+)\"', html_lines))),
            unlist(regmatches(html_lines, gregexpr('href=\"([^\"]+)\"', html_lines)))
          ))
          # Extract the path inside the quotes
          refs <- gsub('^(src|href)=\"', '', refs)
          refs <- gsub('\"$', '', refs)
          # Keep only local relative files (exclude protocols, fragments, data URIs, and the resource dir already copied)
          is_local <- function(x) {
            !grepl('^(https?:|data:|#)', x) && nzchar(x)
          }
          ref_paths <- refs[is_local(refs) & !grepl('^merged_files/', refs)]
          for (rel in unique(ref_paths)) {
            src <- file.path(temp_dir, rel)
            if (file.exists(src)) {
              dest <- file.path(output_dir, rel)
              dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
              file.copy(src, dest, overwrite = TRUE)
            }
          }
        }
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
