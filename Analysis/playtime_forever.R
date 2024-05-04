args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  file = args[1]
#  directory = args[2]
} else {
  cat('usage: Rscript playtime_forever.R <file name>\n', file=stderr())
  stop()
}

library(data.table)

# Read CSV

#data <- read.csv(file, stringsAsFactors = FALSE)
#data <- fread(file, stringsAsFactors = FALSE)
data <- fread(file, fill=TRUE)

# Data type conversions
# Correct references in the R script
data$voted_up <- as.logical(data$voted_up)
data$steam_purchase <- as.logical(data$steam_purchase)
data$received_for_free <- as.logical(data$received_for_free)
data$written_during_early_access <- as.logical(data$written_during_early_access)
data$hidden_in_steam_china <- as.logical(data$hidden_in_steam_china)
data$timestamp_created <- as.POSIXct(data$timestamp_created, origin = "1970-01-01")
data$timestamp_updated <- as.POSIXct(data$timestamp_updated, origin = "1970-01-01")
data$author_last_played <- as.POSIXct(data$author_last_played, origin = "1970-01-01")



average <- data[, .(Average = mean(author_playtime_forever, na.rm = TRUE)), by = .(game)]

# Order the games by average score and select the top ten
top_games <- average[order(-Average)][1:10]

most_common_language <- data[, .N, by = language][order(-N)][1]$language

filename <- paste0("top10_author_playtime_forever_", most_common_language, ".csv")
fwrite(top_games, file = filename)

cat("Results written to:", filename, "\n")