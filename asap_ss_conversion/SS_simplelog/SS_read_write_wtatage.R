#' Function to read a wtatage file from SS.
#'
#' @param file Absolute or relative path to the file to read.
#' @return A list containing the two elements of a wtatage file: maxage, the 
#'   maxage, and wtatage_df, a dataframe containing the weight at age infomration.
SS_readwtatage <- function(file) { #, 
                           #version = NULL, 
                           #verbose = TRUE, 
                           #echoall = FALSE) {
  
#Read a weight at age matrix\
wtatage_lines <- readLines(file)

# want to create the empty list to fill in, in order to get the default size.
wtatagelist <- list(maxage = NULL,
                wtatage_df = NULL)

  # The first value found will be the maxage.
  tmp_lnum <- 0
  while(is.null(wtatagelist$maxage)){
    tmp_lnum <- tmp_lnum + 1 #increment the line number
    tmp_l <- wtatage_lines[tmp_lnum]
    find_val <- grep("[[:digit:]]{1,3}\\s+", tmp_l )
    if(length(find_val) == 1){
      wtatagelist$maxage <- as.numeric(strsplit(tmp_l, "#")[[1]][1])
    } 
  }
  # Then, look for the header
  hdr <- grep("#\\s*Yr\\s*Seas\\s*Sex\\s*Bio_Pattern\\s*BirthSeas\\s*Fleet", 
              wtatage_lines)
  if(hdr <= tmp_l){
    stop("There was a problem finding the maxage and header lines. Please make",
         "sure you are using a file with formatting for a wtatage.ss_new file")
  }
  # remove any characters that aren't actual headers
  hdr_names <- strsplit(wtatage_lines[hdr], "#|\\s+")[[1]]
  to_rm <- c(grep("^$", hdr_names), grep("#", hdr_names))
  hdr_names <- hdr_names[-to_rm]

  # Read the table
  # note that read.table knows "#" is a comment and avoids reading it.
  wtatagelist$wtatage_df <- read.table(file, 
                                   header = FALSE, 
                                   skip = hdr, 
                                   as.is = TRUE)
  #add the headerlines
  if(length(hdr_names) == ncol(wtatagelist$wtatage_df)){
    colnames(wtatagelist$wtatage_df) <- hdr_names
  } else {
    stop("There was a problem getting the column names for the wtatage dataframe.")
  }
  # remove the terminator line
  if(wtatagelist$wtatage_df[nrow(wtatagelist$wtatage_df),1] == -9999) {
    wtatagelist$wtatage_df <- wtatagelist$wtatage_df[-nrow(wtatagelist$wtatage_df), ]
  } else {
    stop("The wtatage.ss data requires a terminator line where the first",
    " value = -9999, but this was not found. Please check that your file",
    " includes a final line with year = -9999.")
  }
  
  #TODO: Add standardized comments. for each line?

  wtatagelist
}

#' write an SS wtatage.ss file using an SS object
#' 
#' @param wtatagelist
#' @param outfile relative or absolute file path with file name to write to.
#' @return Returns the first variable \code{wtatagelist} invisibly, as this 
#'   function is primarily used for its side effects (i.e, writing to file)
SS_writewtatage <- function(wtatagelist, outfile = "wtatage.ss", overwrite = FALSE){
  #TODO: add standardized comments for each line?
  # Manage options for overwriting or not overwriting file.
  if (file.exists(outfile)) {
    if (!overwrite) {
      message("File exists and input 'overwrite' = FALSE: ", outfile)
      return()
    } else {
      file.remove(outfile)
    }
  }
  
  zz <- file(outfile, open = "at")
  on.exit(close(zz), add = TRUE)
  
  # write max age.
  writeLines(paste0(wtatagelist$maxage, " # maxage"), con = zz)
  
  # write comments (look up how to do this using the r4ss funs)
  cmts <- c(
           "# if Yr is negative, then fill remaining years for that Seas, growpattern, Bio_Pattern, Fleet",
           "# if season is negative, then fill remaining fleets for that Seas, Bio_Pattern, Sex, Fleet",
           "# will fill through forecast years, so be careful",
           "# fleet 0 contains begin season pop WT",
           "# fleet -1 contains mid season pop WT",
           "# fleet -2 contains maturity*fecundity"
            )
  writeLines(cmts, con = zz)
  # Write the dataframe 
  # header line 
  writeLines(paste0("#", paste0(colnames(wtatagelist$wtatage_df), 
                    collapse = " ")),
             con = zz)
  #data
  #append terminator line
  write.table(wtatagelist$wtatage_df,
              file = zz,
              append = TRUE,
              col.names = FALSE,
              row.names = FALSE,
              quote = FALSE)
  #write the terminator line
  writeLines(paste0("-9999 ", 
             paste0(rep(0, times = ncol(wtatagelist$wtatage_df)-1), collapse = " "),
             " #terminator"),
             con = zz)
  
  invisible(wtatagelist)
}