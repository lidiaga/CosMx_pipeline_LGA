##### Chunk time and memory monitor #####

all_times <- list()  # Store execution times
all_mem <- list()    # Store memory usage

knitr::knit_hooks$set(monitor = local({
  now <- NULL
  mem_before <- NULL
  
  function(before, options) {
    if (before) {
      now <<- Sys.time()
      mem_before <<- sum(gc(reset = TRUE)[, 2])
    } else {
      res <- round(as.numeric(difftime(Sys.time(), now, units = "secs")), 2)
      mem_res <- round(sum(gc()[, 2]) - mem_before, 2)
      
      all_times[[options$label]] <<- res
      all_mem[[options$label]] <<- mem_res
    }
  }
}))