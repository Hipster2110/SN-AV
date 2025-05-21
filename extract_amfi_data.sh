#!/bin/bash

# ============================================
# Script to extract Mutual Fund Scheme Name and Asset Value
# from the AMFI (Association of Mutual Funds in India) website.
# The data is saved in a clean TSV (Tab-Separated Values) format.
# ============================================

# Step 1: Define the source URL for mutual fund NAV data
URL="https://www.amfiindia.com/spages/NAVAll.txt"

# Step 2: Name the output file
OUTPUT_FILE="amfi_schemes.tsv"

# Step 3: Download the data and extract relevant fields
curl -s "$URL" | \
awk -F';' '
    BEGIN {
        # Print column headers
        OFS="\t"
        print "Scheme Name", "Asset Value"
    }
    # Only process lines that:
    # - Have at least 5 fields
    # - Start with a number (valid scheme codes)
    NF >= 5 && $1 ~ /^[0-9]+$/ {
        # Clean whitespace from Scheme Name and Asset Value
        gsub(/^[ \t]+|[ \t]+$/, "", $4)
        gsub(/^[ \t]+|[ \t]+$/, "", $5)

        # Print them as tab-separated values
        print $4, $5
    }
' > "$OUTPUT_FILE"

# Step 4: Let the user know it worked
echo "✅ Successfully saved data to $OUTPUT_FILE"
