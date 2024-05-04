#!/bin/bash

# Define the path to the CSV file
csv_file="/staging/groups/stat605-project14/all_reviews/all_reviews.csv"

# Define the paths for the output CSV files
output_dir="/home/groups/STAT_DSCP/group14/data_plot4"
voted_up_csv="${output_dir}/voted_up.csv"
voted_down_csv="${output_dir}/voted_down.csv"

# Create the output directory if it does not exist
mkdir -p $output_dir

# Define an array of games to keep
declare -a games_to_keep=("YoloMouse")

# Extract the header and filter columns
awk -F, 'BEGIN {OFS=FS} NR==1 {print $3,$7,$9,$15}' $csv_file > $voted_up_csv
awk -F, 'BEGIN {OFS=FS} NR==1 {print $3,$7,$9,$15}' $csv_file > $voted_down_csv

# Filter the rows and split based on "voted_up"
awk -F, -v games="${games_to_keep[*]}" '
BEGIN {
  split(games, games_arr, " ");
  OFS=FS;
}
NR > 1 {
  for(i in games_arr) {
    if ($3 == games_arr[i]) {
      if ($15 == "1")
        print $3,$7,$9,$15 >> "'$voted_up_csv'";
      else if ($15 == "0")
        print $3,$7,$9,$15 >> "'$voted_down_csv'";
      break;
    }
  }
}' $csv_file

echo "Files with filtered data are saved to:"
echo "Voted up: $voted_up1_csv"
echo "Voted down: $voted_down1_csv"
