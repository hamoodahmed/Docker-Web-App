#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# -------------------------
# Check arguments
# -------------------------
if (length(args) < 2) {
  stop("Usage: Rscript graphs.R <working_directory> <cpu|memory>")
}

# Set working directory
setwd(args[1])

# Ensure graphics folder exists
if (!dir.exists("graphics")) {
  dir.create("graphics")
}

# Load libraries
library(mongolite)
library(ggplot2)

# -------------------------
# Read collections and databases
# -------------------------
collectionNames = readLines("collections.csv", warn = FALSE)
# Trim whitespace and remove empty lines
collectionNames = trimws(collectionNames)
collectionNames = collectionNames[collectionNames != ""]
# Remove cadvisor safely
collectionNames = collectionNames[collectionNames != "cadvisor"]

databaseNames = readLines("database-names.csv", warn = FALSE)
databaseNames = trimws(databaseNames)
databaseNames = databaseNames[databaseNames != ""]
if (length(databaseNames) == 0) stop("No valid database names found in database-names.csv")

# -------------------------
# Function to generate plots
# -------------------------
cadvisor.plots <- function(collections, database, type){
  
  df = data.frame(collections = collections, number.docs = 0)
  
  for (i in 1:length(collections)) {
    m = mongo(collection = collections[i], db = database, url = "mongodb://localhost:27017")
    
    # Count documents
    df[i, "number.docs"] = m$count()
    
    # Load all data
    alldata <- m$find('{}')
    
    # Parse timestamps safely
    times <- tryCatch({
      t <- alldata$timestamp
      t <- gsub("T", " ", t)
      t <- gsub("Z", "", t)
      t <- strptime(t, "%Y-%m-%d %H:%M:%OS")
      as.POSIXct(t)
    }, error = function(e) NULL)
    
    if (is.null(times) || length(times) < 2) {
      message(paste("Skipping collection:", collections[i], "- no valid timestamps"))
      next
    }
    
    delta.time <- as.numeric(diff(times))
    
    # -------------------------
    # CPU plot
    # -------------------------
    if (type == "cpu") {
      cpu.usage.total <- tryCatch(alldata$cpu$usage$total, error=function(e) NULL)
      if (is.null(cpu.usage.total) || length(cpu.usage.total) < 2) {
        message(paste("Skipping CPU for collection:", collections[i], "- no valid CPU data"))
        next
      }
      
      cores = diff(cpu.usage.total) / delta.time / 1e9
      dat = data.frame(cores, time = times[-1])
      
      g = ggplot(dat, aes(x=time, y=cores)) +
        ggtitle(paste("CPU Usage:", collections[i]), subtitle=database) +
        geom_line(color=i+1) +
        theme(plot.subtitle = element_text(size=10, face="italic"))
      
      png(file=file.path("graphics", paste0(collections[i], "-", database, "-cpu.png")))
      print(g)
      dev.off()
    }
    
    # -------------------------
    # Memory plot
    # -------------------------
    else if (type == "memory") {
      memory.usage <- tryCatch(alldata$memory$usage / 1e6, error=function(e) NULL)
      if (is.null(memory.usage) || length(memory.usage) < 2) {
        message(paste("Skipping Memory for collection:", collections[i], "- no valid Memory data"))
        next
      }
      
      dat = data.frame(memory = memory.usage, time = times)
      
      g = ggplot(dat, aes(x=time, y=memory)) +
        ggtitle(paste("Memory Usage:", collections[i]), subtitle=database) +
        ylab("megabytes") +
        geom_line(color=i+1) +
        theme(plot.subtitle = element_text(size=10, face="italic"))
      
      png(file=file.path("graphics", paste0(collections[i], "-", database, "-memory.png")))
      print(g)
      dev.off()
    }
  }
  
  return(df)
}

# -------------------------
# Run function for each database
# -------------------------
for (db in databaseNames) {
  if (db != "") {
    cadvisor.plots(collections = collectionNames, database = db, type = args[2])
  }
}