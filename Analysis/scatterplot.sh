#!/bin/bash

# Define the directory containing the CSV files
csv_dir="/home/groups/STAT_DSCP/group14/data_lang"

# Output directory for temporary and final files
output_dir="/home/groups/STAT_DSCP/group14/plot3"
mkdir -p "$output_dir"

# List of games to filter and merge
declare -a games=("黑色沙漠(失效)" "PUT IN BAD" "Grand Theft Auto 2" "Going Medieval" "YoloMouse" "Ultimate Under Water")

# Prepare the header for the combined output file for each game
for game in "${games[@]}"; do
    echo "game,language,avg_author_playtime_forever,number_of_users" > "$output_dir/combined_${game// /_}.csv"
done

# Process each file
for file in "$csv_dir"/reviews_*.csv; do
    country=$(basename "$file" | sed 's/reviews_\(.*\)\.csv/\1/')
    temp_file="$output_dir/temp_$country.csv"

    # Calculate the average playtime and count of games
    awk -F, 'NR > 1 {
        playtime[$3] += $7;
        count[$3]++;
    }
    END {
        for (game in playtime) {
            print game, "language_placeholder", playtime[game]/count[game], count[game]
        }
    }' OFS=, "$file" > "$temp_file"

    # Replace the language placeholder with the actual country/language
    sed -i "s/language_placeholder/$country/" "$temp_file"

    # Append data for specific games to their respective combined files
    for game in "${games[@]}"; do
        grep -F "\"$game\"" "$temp_file" >> "$output_dir/combined_${game// /_}.csv"
    done

    # Cleanup temporary file if needed
    rm "$temp_file"
done

# Display the path of the final output files
for game in "${games[@]}"; do
    echo "Combined data for $game saved to: $output_dir/combined_${game// /_}.csv"
done
