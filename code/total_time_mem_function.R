####### TOTAL TIME AND MEMORY CONSUMPTION FUNCTION ######

# This function takes previously generated performance reports as input
# Loads them and calculates the total time and memory consumed

total_time_mem <- function(pr_files) {
  # Load PR reports
  for (file in pr_files) {
    a <- fread(here("output","performance_reports",file))
    assign(file,a)
  }

  # Extract total times and mems of each phase
  totals <- data.frame("Phase" = character(0),
                       "Total_time_sec" = numeric(0),
                       "Total_memory_Mb" = numeric(0))

  for (pr in pr_files) {
    pr_dt <- get(pr)
    time <- as.numeric(pr_dt[Chunk == "Total",2])
    mem <- as.numeric(pr_dt[Chunk == "Total", 3])
    totals <- rbind(totals,
                    data.frame("Phase" = pr,
                               "Total_time_sec" = time,
                               "Total_memory_Mb" = mem,
                               stringsAsFactors = FALSE))
    }

  # Add final Total summary
  totals <- rbind(totals,
                  data.frame("Phase" = "Total",
                             "Total_time_sec" = sum(totals$Total_time_sec),
                             "Total_memory_Mb" = sum(totals$Total_memory_Mb),
                             stringsAsFactors = FALSE))

  # Save as CSV and return
  write.csv(totals, here("output","performance_reports","pipeline_PR.csv"),
            row.names = FALSE)

  return(totals)
}


