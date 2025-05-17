##### Efficient exprMat loading function #####

loadExprMat <- function(countsfile, slide_number) {
  ### Adapted from Scratch Space vignette script: 0.-loading-flat-files.Rmd
  ### Safely reads in the dense (0-filled) counts matrices in chunks
  ### Note: the file might be gzip compressed, so we don't know a priori the number of chunks needed
  
  # Starting parameters (unmodified from Scratch Space)
  nonzero_elements_perchunk <- 5*10**7
  lastchunk <- FALSE
  skiprows <- 0
  chunkid <- 1
  
  # Checks for required cols (unmodified from Scratch Space)
  required_cols <- fread(countsfile, select = c("fov", "cell_ID"))
  gc() # Force memory clean after big loads
  
  if (!all(c("cell_ID", "fov") %in% colnames(required_cols))) {
    stop("Columns 'fov' and 'cell_ID' are required, but not found")
  }
  
  # Checks for undesired character cols, such as "cell" (self added)
  col_names <- fread(countsfile, nrows = 1) # Reads the colnames of the file
  gc() # Force memory clean after big loads
  char_cols <- which(sapply(col_names, is.character)) # Detects char cols
  
  # Stablishes chunk size (slightly modified from Scratch Space)
  number_of_cells <- nrow(required_cols)
  number_of_cols <-  length(col_names) - length(char_cols) # Modified to avoid char cols
  number_of_chunks <- ceiling(number_of_cols * number_of_cells / (nonzero_elements_perchunk))
  chunk_size <- floor(number_of_cells / number_of_chunks)
  
  # Creates a list for storing chunks (unmodified from Scratch Space)
  sub_counts_matrix <- vector(mode = 'list', length = number_of_chunks)
  
  # Reads the matrix in chunks (slightly modified from Scratch Space)
  cellcount <- 0
  
  while (lastchunk == FALSE) { # Loops until it is the last chunk
    
    read_header <- FALSE # By default it does not read the header
    if (chunkid == 1) {read_header <- TRUE} # Only reads the header in the first chunk
    
    # Added: if char_cols present, drops them while reading the chunks
    if (length(char_cols) > 0) {
      countsdatatable <- data.table::fread(countsfile,
                                           nrows = chunk_size,
                                           skip = skiprows + (chunkid > 1),
                                           drop = char_cols,
                                           header = read_header)
    } else {
      # If char_cols not present, does not drop anything
      countsdatatable <- data.table::fread(countsfile,
                                           nrows = chunk_size,
                                           skip = skiprows + (chunkid > 1),
                                           header = read_header)
    }
    gc() # Force memory clean after big loads
    
    # Names de columns in all chunks
    if (chunkid == 1) {
      header <- colnames(countsdatatable)
    } else {
      colnames(countsdatatable) <- header
    }
    
    # Keeps track of cells/rows already read
    cellcount <- nrow(countsdatatable) + cellcount
    
    # Checks if it is last chunk
    if (cellcount == number_of_cells) {
      lastchunk <- TRUE
    }
    
    skiprows <- skiprows + chunk_size
    
    # Creates the unique cell ID: c_slide_fov_cell to name rows later
    slide_fov_cell_counts <- paste0("c_", slide_number, "_", countsdatatable$fov, "_", countsdatatable$cell_ID)
    
    # Converts the chunk to sparse and adds it to the list
    sub_counts_matrix[[chunkid]] <- as(countsdatatable[,-c("fov", "cell_ID"), with = FALSE], "sparseMatrix")
    rownames(sub_counts_matrix[[chunkid]]) <- slide_fov_cell_counts
    
    chunkid <- chunkid + 1
  }
  
  # Binds all chunks in a single matrix and returns it
  exprMat <- do.call(rbind, sub_counts_matrix)
  
  return(exprMat)
}

##### Normalization for CosMx data #####

normalize_CosMx <- function(seu, method = "SCT") {
  ### Parameterized function to perform either RC, LogNormalize or SCT in
  ### a Seurat object of CosMx data
  ### Note: the functions used belong to the Seurat package

  # Checks and loads Seurat package
  if (!requireNamespace("Seurat", quietly = TRUE)) {
    stop("Install Seurat package for normalization.")
  }

  library(Seurat)

  # Checks if the method is valid
  if (!method %in% c("RC", "LogNormalize", "SCT")) {
    stop("The selected method is invalid, choose: 'RC', 'LogNormalize' or 'SCT'")
  }

  # Applies normalization depending on the method selected
  if (method == "SCT") {
    seu <- SCTransform(seu, verbose = FALSE)
  } else if (method == "RC" | method == "LogNormalize") {
    seu <- NormalizeData(seu, normalization.method = method)
    seu <- FindVariableFeatures(seu)
    seu <- ScaleData(seu, features = rownames(seu))
  }

  return(seu) # Returns the normalized Seurat object
}

##### ggplot2-like custom palette #####

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
