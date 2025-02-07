#!/bin/bash

FILE=$1
COMMIT=$2
STATUS=$3

# Generate the output JSON
jq --arg branchtag "${COMMIT}" --arg status "${STATUS}" -r '
    [
        .[] | select(.urlref | test($status)) | {
            urlref: (.urlref | sub("/[^/]+/[^/]+$"; "/ontwerpstandaard/toolchain4")),
            repository: .repository,
            branchtag: "\($branchtag)",
            name: .name,
            filename: .filename,
            directory: (.urlref | sub("/[^/]+/[^/]+$"; "/ontwerpstandaard/toolchain4")),
            navigation: {
                prev: .urlref
            },
            dummy: "001"
        }
    ]
' ${FILE}
