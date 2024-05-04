rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  file = args[1]
} else {
  cat('usage: Rscript pre.R <file name>\n', file=stderr())
  stop()
}
file=toString(args[1])

# Read CSV
reviews <- read.csv(file, stringsAsFactors = FALSE)

# Define column names
#colnames(reviews) <- c("recommendationid", "appid", "game", "author_steamid", "author_num_games_owned",
 #                      "author_num_reviews", "author_playtime_forever", "author_playtime_last_two_weeks",
  #                     "author_playtime_at_review", "author_last_played", "language", "review",
   #                    "timestamp_created", "timestamp_updated", "voted_up", "votes_up", "votes_funny",
    #                   "author_num_reviews", "author_playtime_forever", "author_playtime_last_two_weeks",
     #                  "author_playtime_at_review", "author_last_played", "language", "review",
      #                 "timestamp_created", "timestamp_updated", "voted_up", "votes_up", "votes_funny",
       #                "weighted_vote_score", "comment_count", "steam_purchase", "received_for_free",
        #               "written_during_early_access", "hidden_in_steam_china", "steam_china_location")

# Data type conversions
reviews$voted_up <- as.logical(reviews$voted_up)
reviews$steam_purchase <- as.logical(reviews$steam_purchase)
reviews$received_for_free <- as.logical(reviews$received_for_free)
reviews$written_during_early_access <- as.logical(reviews$written_during_early_access)
reviews$hidden_in_steam_china <- as.logical(reviews$hidden_in_steam_china)
reviews$timestamp_created <- as.POSIXct(reviews$timestamp_created, origin = "1970-01-01")
reviews$timestamp_updated <- as.POSIXct(reviews$timestamp_updated, origin = "1970-01-01")
reviews$author_last_played <- as.POSIXct(reviews$author_last_played, origin = "1970-01-01")


#model <- lm(weighted_vote_score ~ author_playtime_forever + author_num_games_owned + votes_up + steam_purchase + received_for_free + written_during_early_access, data = reviews)
#voted_up; votes_up; 
model <- glm(voted_up ~ author_playtime_forever + author_num_games_owned + votes_up + steam_purchase + written_during_early_access+comment_count+author_playtime_last_two_weeks, data = reviews, family=binomial(link="logit"))
results = summary(model)

print(colnames(results$coefficients))
significant_indices <- which(results$coefficients[,"Pr(>|z|)"] < 0.01)

# Subset coefficients, standard errors, t-values, and p-values based on significance
if (length(significant_indices) > 0) {
  results_df <- data.frame(
Estimate = summary(model)$coefficients[, "Estimate"],
variable=summary(model)$coefficients[,0],
country=file
)
} else {
  results_df <- NULL  # No coefficients are significant
}

#results_df <- data.frame(
 # Estimate = summary(model)$coefficients[, "Estimate"],
  #  StdError = summary(model)$coefficients[, "Std. Error"],
   #   zValue = summary(model)$coefficients[, "z value"],
    #    Pr = summary(model)$coefficients[, "Pr(>|z|)"]
#	)

filename <- paste("linearRegression_", file, ".csv", sep = "")
write.csv(results_df, file = filename, row.names = FALSE)
