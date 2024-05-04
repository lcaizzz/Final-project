#!/bin/bash

# Define the base directory where the review CSV files are stored
base_dir="/home/groups/STAT_DSCP/group14/data_lang"

# Define the output file path
output_file="/home/groups/STAT_DSCP/group14/waffle.csv"

# Prepare the output file with the header
echo "language,number_of_players" > "$output_file"

# Process each review file
for file in ${base_dir}/reviews_*.csv; do
    # Extract the language from the filename
    language=$(basename "$file" | sed 's/reviews_\(.*\)\.csv/\1/')

    # Count the number of players (rows minus one for the header)
    num_players=$(awk 'END {print NR-1}' "$file")

    # Append the language and number of players to the output file
    echo "$language,$num_players" >> "$output_file"
done

echo "Player counts by language have been compiled into $output_file."
