#!/bin/bash

# Directory where files will be downloaded
DOWNLOAD_DIR="./txcache/fhir-server"

# Base URL for the downloads
BASE_URL="https://storage.googleapis.com/tx-fhir-org"

# List of files to download
FILES=(
    "loinc-2.78.db"
    "ndc-20211101.db"
    "omop_20230531_a.db"
    "rxnorm_09032024.db"
    "unii_20240622.db"
    "sct_be_20231115.cache"
    "sct_ch_20230607.cache"
    "sct_dk_20240331.cache"
    "sct_intl_20240801.cache"
    "sct_ips_20221130.cache"
    "sct_nl_20240930.cache"
    "sct_se_20231130.cache"
    "sct_uk_20230412.cache"
    "ucum-essence-2.2.xml"
)

# Create the download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Function to download a file if it's not commented out
download_file() {
    local file=$1
    echo "Downloading $file..."
    curl -s --create-dirs -o "$DOWNLOAD_DIR/$file" "$BASE_URL/$file"
    if [ $? -eq 0 ]; then
        echo "$file downloaded successfully."
    else
        echo "Error downloading $file."
    fi
}

# Export the function to be used in parallel
export -f download_file

# Export the variables
export DOWNLOAD_DIR BASE_URL

# Use GNU parallel to download files concurrently
# Lines starting with "#" are ignored
printf "%s\n" "${FILES[@]}" | grep -v '^#' | parallel -j 4 download_file

echo "Download process completed."

