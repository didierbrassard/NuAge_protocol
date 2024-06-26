#' Generate and save data, CSV, and HTML summary report
#'
#' This function generates and saves an RData file, a CSV file, and an HTML summary
#' report for a given data frame. It also provides an option to display the summary
#' in the console.
#'
#' @param data A data frame to be saved and summarized.
#' @param dir The directory where the files will be saved.
#' @param dir_metadata The directory where the metadata file (.html) will be saved (default is the same as <dir>).
#' @param save_rdata Logical. Whether to save the data frame as an RData file (default is TRUE).
#' @param save_csv Logical. Whether to save the data frame as a CSV file (default is TRUE).
#' @param save_metadata Logical. Whether to generate and save an HTML summary report (default is TRUE).
#' @param display_summary Logical. Whether to display the summary in the console (default is FALSE).
#'
#' @return NULL
#'
#' @examples
#' # Example usage:
#' # save_and_summarize_data(your_data_frame, "output_directory")
#'
#' @importFrom summarytools dfSummary stview
#'
#' @export
save_and_summarize_data <- function(data, dir=NULL, dir_metadata=NULL, save_rdata = TRUE, save_csv = TRUE, save_metadata = TRUE, display_summary = FALSE) {
  # Stop if dir not defined
  if (is.null(dir)) stop("Output directory <dir> is not defined")
  
  # Check if the directory exists and create it if not
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
    cat(dir,"folder was created.\n")
  }
  
  # Check if dir_metadata defined
  if (is.null(dir_metadata)) {
    dir_metadata <- dir
  } else {
    # Check if the directory exists and create it if not
    if (!dir.exists(dir_metadata)) {
      dir.create(dir_metadata, recursive = TRUE)
      cat(dir_metadata,"folder was created.\n")
    }
  }
  
  # Get the name of the 'data' parameter
  data_name <- deparse(substitute(data))
  
  # Save RData file
  if (save_rdata) {
    rdata_file <- paste0(data_name, ".rdata")
    save(list = data_name, file = file.path(dir, rdata_file))
  }
  
  # Save CSV file
  if (save_csv) {
    csv_file <- paste0(data_name, ".csv")
    write.csv(data, file = file.path(dir, csv_file))
  }
  
  # Generate data dictionary and HTML report
  if (save_metadata) {
    html_file <- paste0(data_name, ".html")
    library(summarytools)
    summary_result <- dfSummary(data)
    stview(summary_result,
           file = file.path(dir_metadata, html_file),
           report.title = paste("Data Frame Summary:",data_name))
  }
  
  # Display summary in the console
  if (display_summary) {
    print(summary_result)
  }
}
