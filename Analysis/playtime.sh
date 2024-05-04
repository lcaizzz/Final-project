#!/bin/bash

# Extract R and packages
tar -xzf R413.tar.gz
tar -xzf packages_FITSio.tar.gz
tar -xzf bit64_4.0.5.tar.gz

# Set environment variables for R
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

# Create a directory for R packages if it doesn't already exist
mkdir -p $R_LIBS

# Install R packages
#Rscript -e "install.packages(c('data.table', 'ROSE'), repos='http://mirror.las.iastate.edu/CRAN')"
Rscript -e "install.packages(c('data.table', 'ROSE', 'bit64'), repos='http://mirror.las.iastate.edu/CRAN')"

# Extract the filename from the provided path and remove any directory path components
filename="${1##*/}"

# Output the filename (optional, for verification)
echo "$filename"

# Run the R scripts with the filename as an argument
Rscript playtime_forever.R "$filename"
#Rscript playtime_last_two_weeks.R "$filename"
Rscript playtime_at_review.R "$filename"
