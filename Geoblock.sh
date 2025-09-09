#!/bin/bash

# Country Codes Alpha-2
allowed_countries=("al" "ad" "am" "at" "by" "be" "ba" "bg" "hr" "cy" "cz" "dk" "ee" "fi" "fr" "ge" "de" "gr" "hu" "is" "ie" "it" "lv" "li" "lt" "lu" "mt" "md" "mc" "me" "nl" "mk" "no" "pl" "pt" "ro" "ru" "sm" "rs" "sk" "si" "es" "se" "ch" "ua" "gb" "ca" "us" "au" "nz")

# Store the starting directory
START_DIR=$(pwd)

# Define output files with absolute paths in the starting directory
ipv4_output="$START_DIR/combined_ipv4_blacklist.txt"
ipv6_output="$START_DIR/combined_ipv6_blacklist.txt"

# Clone the repository and check for errors
git clone https://github.com/ipverse/rir-ip.git || {
    echo "Failed to clone repository"
    exit 1
}

# Change directory and check if it exists
cd rir-ip/country || {
    echo "Directory rir-ip/country not found"
    exit 1
}

# Create output files
> "$ipv4_output" || { echo "Failed to create $ipv4_output"; exit 1; }
> "$ipv6_output" || { echo "Failed to create $ipv6_output"; exit 1; }

# Loop through all directories and process those not in allowed_countries
for dir in */; do
    # Remove trailing slash to get country code
    country=${dir%/}
    # Check if country is NOT in allowed_countries
    if [[ ! " ${allowed_countries[*]} " =~ " $country " ]]; then
        if [ -d "$country" ]; then
            # Check and combine IPv4 file
            if [ -f "$country/ipv4-aggregated.txt" ]; then
                cat "$country/ipv4-aggregated.txt" >> "$ipv4_output" && echo "Added IPv4 for $country to blacklist" || echo "Failed to add IPv4 for $country"
            else
                echo "IPv4 file not found for $country"
            fi

            # Check and combine IPv6 file
            if [ -f "$country/ipv6-aggregated.txt" ]; then
                cat "$country/ipv6-aggregated.txt" >> "$ipv6_output" && echo "Added IPv6 for $country to blacklist" || echo "Failed to add IPv6 for $country"
            else
                echo "IPv6 file not found for $country"
            fi
        else
            echo "$country directory does not exist"
        fi
    else
        echo "Skipping $country (allowed country)"
    fi
done

# Verify output files have content
if [ -s "$ipv4_output" ]; then
    echo "IPv4 blacklist saved to $ipv4_output"
else
    echo "Warning: $ipv4_output is empty"
fi

if [ -s "$ipv6_output" ]; then
    echo "IPv6 blacklist saved to $ipv6_output"
else
    echo "Warning: $ipv6_output is empty"
fi

# Change back to parent directory and remove the cloned repository
cd "$START_DIR" || { echo "Failed to return to $START_DIR"; exit 1; }
rm -rf rir-ip && echo "Removed rir-ip repository" || echo "Failed to remove rir-ip repository"
