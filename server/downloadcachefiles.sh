#!/bin/bash

# Directory where files will be downloaded
DOWNLOAD_DIR="./txcache1/fhir-server"

# Base URL for the downloads
BASE_URL="https://igs.raly.ch/tx.fhir.ch/cache-files"

# List of files to download
FILES=(
    "loinc-2.80.db"
    "sct_ch_20250607.cache"
    "sct_intl_20250601.cache"
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

# Function to download a file if it's not commented out
download_package() {
    local url=$1
    local destfile=$2
    echo "Downloading $file..."
    curl -s --create-dirs -o "$DOWNLOAD_DIR/$destfile" "$url"
    if [ $? -eq 0 ]; then
        echo "$url downloaded successfully."
    else
        echo "Error downloading $file."
    fi
}

# Export the function to be used in parallel
export -f download_package

CHTERM=(
#    "https://www.fhir.ch/ig/ch-term/3.0.0/package.tgz"
    "https://www.fhir.ch/ig/ch-term/3.2.0/package.tgz"
    "https://www.fhir.ch/ig/ch-term/3.1.0/package.tgz"
)

URLS=`printf "%s\n" "${CHTERM[@]}" | grep -v '^#'`

for url in $URLS ; do
    echo "$url"
    part1=`echo $url | cut -d"/" -f5`
    part2=`echo $url | cut -d"/" -f6`
    echo "Part1: $part1, Part2: $part2"
    filename="ch.fhir.ig.$part1#$part2.tgz"
    dirname="ch.fhir.ig.$part1#$part2"
    echo "$filename"
    download_package $url $filename
    mkdir -p $DOWNLOAD_DIR/$dirname
    tar -xz -C $DOWNLOAD_DIR/$dirname -f $DOWNLOAD_DIR/$filename 
    rm -rf $DOWNLOAD_DIR/$filename
done



echo "Download process completed."
