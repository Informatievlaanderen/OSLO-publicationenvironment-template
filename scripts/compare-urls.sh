#!/bin/bash

DEVURLS=$1
PRODURLS=$2

# Check if both file arguments are provided
if [ -z "$DEVURLS" ] || [ -z "$PRODURLS" ]; then
    echo "Usage: $0 <dev_urls.txt> <prod_urls.txt>"
    exit 1
fi

# Read the contents of the dev and prod files into arrays
dev_array=()
while IFS= read -r line; do
    dev_array+=("$line")
done <"$DEVURLS"

prod_array=()
while IFS= read -r line; do
    prod_array+=("$line")
done <"$PRODURLS"

# Find strings that are in prod.txt but not in dev.txt
unique_in_prod=()
for prod_item in "${prod_array[@]}"; do
    found=false
    for dev_item in "${dev_array[@]}"; do
        if [[ "$prod_item" == "$dev_item" ]]; then
            found=true
            break
        fi
    done
    if [ "$found" = false ]; then
        unique_in_prod+=("$prod_item")
    fi
done

# Print the unique strings
for item in "${unique_in_prod[@]}"; do
    echo "$item"
done
