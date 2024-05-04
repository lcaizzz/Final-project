#!/usr/bin/env Rscript

# Get the command line arguments
args <- commandArgs(trailingOnly=TRUE)

# Check if there is exactly one argument
if(length(args) == 1) {
  file <- args[1]
} else {
  cat('Usage: Rscript playtime_at_review.R <file name>\n', file=stderr())
  stop("Incorrect number of arguments.", call. = FALSE)
}

library(data.table)

# Read the CSV file using fread
data <- fread(file, fill=TRUE)

# Calculate the average playtime at review and average playtime forever, grouped by game
average_playtime_at_review <- data[, .(average_author_playtime_at_review = mean(author_playtime_at_review, na.rm = TRUE)), by = .(game)]
average_playtime_forever <- data[, .(average_author_playtime_forever = mean(author_playtime_forever, na.rm = TRUE)), by = .(game)]

# Merge the two averages by game
averages <- merge(average_playtime_at_review, average_playtime_forever, by = "game")

# Generate a filename for the output CSV
output_filename <- paste0(sub(".csv", "", file), "_averages1.csv")

# Write the data table to a CSV file
fwrite(averages, file = output_filename)
