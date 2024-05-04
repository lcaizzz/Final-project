#!/bin/bash

# Define input and output directories
input_file="/staging/groups/stat605-project14/all_reviews/all_reviews.csv"
output_file="/home/groups/STAT_DSCP/group14/avg_playtimes.csv"

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$output_file")"

# Calculate average playtime forever and at review, then number of players
awk -F, 'NR > 1 {
    game = $3; # Game name
    playtimeForever = $7; # Playtime forever
    playtimeReview = $9; # Playtime at review

    # Accumulate playtime and count entries for each game
    playtime_forever[game] += playtimeForever;
    playtime_at_review[game] += playtimeReview;
    count_forever[game]++;
    count_review[game]++;
} 
END {
    # Print header
    print "game,average_author_playtime_forever,average_author_playtime_at_review";
    
    # Calculate average playtime and output results
    for (game in playtime_forever) {
        avg_forever = (count_forever[game] ? playtime_forever[game] / count_forever[game] : 0);
        avg_review = (count_review[game] ? playtime_at_review[game] / count_review[game] : 0);
        print game "," avg_forever "," avg_review;
    }
}' "$input_file" | sort > "$output_file"

echo "Processing complete. File saved to $output_file"
