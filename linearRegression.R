rm(list=ls())

library(lubridate)

# Set the working directory to where your CSV files are stored
setwd("C:/Users/Seunghyun/Desktop/files")

# List all CSV files in the directory
files <- list.files(pattern = "\\.csv$")

# Loop over each file
for (file in files) {
  # Read the data
  reviews <- read.csv(file)
  
  # Convert timestamp values
  reviews$timestamp_created <- as_datetime(reviews$timestamp_created)
  reviews$timestamp_updated <- as_datetime(reviews$timestamp_updated)
  reviews$author_last_played <- as_datetime(reviews$author_last_played)
  
  # Fit the model
  model <- lm(weighted_vote_score ~ 
                1 + author_last_played + 
                author_playtime_last_two_weeks + 
                author_playtime_at_review + 
                votes_up + 
                votes_funny + 
                comment_count + 
                timestamp_created, 
              data = reviews)
  
  # Take final results
  summary <- summary(model)
  coefficients_df <- as.data.frame(summary$coefficients)
  final_df <- coefficients_df[, c("Estimate", "Pr(>|t|)")]
  
  # Output file
  output_filename <- paste0("result_", sub(".csv", "", file), ".txt")
  write.table(final_df, output_filename, sep = ",", col.names = TRUE, quote = FALSE)
}