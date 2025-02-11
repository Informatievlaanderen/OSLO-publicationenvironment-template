#!/bin/bash

CONFIGDIR=$1

# Check if the directory argument is provided
if [ -z "$CONFIGDIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

HOSTNAME=$(jq -r .hostname ${CONFIGDIR}/config.json)
DIRECTORY=$(jq -r '.publicationpoints[0]' "${CONFIGDIR}/config.json")

# Find all *.publication.json files and extract unique urlref values
unique_urlrefs=$(jq -s '[.[][] | .urlref] | unique' $(find "$CONFIGDIR/$DIRECTORY" -name '*.publication.json'))

# Convert the JSON array to a bash array
urlrefs=($(echo "$unique_urlrefs" | jq -r '.[]'))

# Curl each URL and print the HTTP status code
for url in "${urlrefs[@]}"; do
    status_code=$(curl -L -o /dev/null -s -w "%{http_code}\n" "$HOSTNAME$url")
    if [[ "$url" != *"toolchain"* ]]; then
        if [ "$status_code" -ne 200 ]; then
            echo "URL: $url - Status Code: $status_code"
            echo "$url"
        fi
    fi
done
