rm(list=ls())

library(dplyr)

# Set the directory containing your files
setwd("C:/Users/Seunghyun/Desktop/files")

# Get all CSV files
files <- list.files(pattern = "\\.txt$")

# Initialize a list to store results for each file
results_list <- list()

# Loop through each file
for (file in files) {
  # Read the data, skipping the first row
  data <- read.csv(file, header = FALSE, skip = 1)
  # Rename the columns for clarity
  colnames(data) <- c("Variable", "Estimate", "PValue")
  
  # Filter rows where PValue < 0.05
  valid_rows <- data %>% filter(PValue < 0.05)
  
  # Compute the mean of Estimate for valid rows and count them
  if (nrow(valid_rows) > 0) {
    summary_stats <- valid_rows %>%
      group_by(Variable) %>%
      summarise(MeanEstimate = mean(Estimate), Count = n())
    results_list[[file]] <- summary_stats
  }
}

# Combine all individual file results into one dataframe
final_results <- bind_rows(results_list)

# Aggregate the results across all files
aggregated_results <- final_results %>%
  group_by(Variable) %>%
  summarise(MeanEstimate = mean(MeanEstimate), TotalCount = sum(Count))

# Write the final aggregated results to CSV
write.csv(aggregated_results, "final_aggregated_results.csv", row.names = FALSE)

