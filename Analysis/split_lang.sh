#!/bin/bash

# Define the path to the CSV file
csv_file="/staging/groups/stat605-project14/all_reviews/all_reviews.csv"

# Define the output directory
output_dir="/home/groups/STAT_DSCP/group14/data_lang"

# Create the output directory if it does not exist
mkdir -p $output_dir

# Get the header from the CSV file
header=$(head -1 $csv_file)

# Split the file by language, appending the header to each new file before the respective content
awk -F, -v header="$header" 'NR == 1 {next} {
    file = "'$output_dir'/reviews_"$11".csv";
    if (!seen[file]++) {
        print header > file;
    }
    print >> file;
}' $csv_file
