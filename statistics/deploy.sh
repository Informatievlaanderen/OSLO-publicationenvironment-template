#!/bin/bash

#
# deploy the template to the generated repository when creating the final commit
# This deploy.sh will always be executed, but if no changes have happend
# then this will not lead to a git commit
#

CONFIGDIR=$1
TARGET=$2
REPORTLINEPREFIX='#||# '

mkdir -p ${TARGET}/.circleci
cp -r circleci/* ${TARGET}/.circleci
mkdir -p ${TARGET}/report4
cp -r report/* ${TARGET}/report4


PUBLICATIONPOINTSDIRS=$(jq -r '.publicationpoints | @sh' ${CONFIGDIR}/config.json)
PUBLICATIONPOINTSDIRS=$(echo ${PUBLICATIONPOINTSDIRS} | sed -e "s/'//g")


echo "[]" > /tmp/supportingpublicationpoints.json
for dir in ${PUBLICATIONPOINTSDIRS}; do
    echo "${REPORTLINEPREFIX}collecting publication points from directory ${CONFIGDIR}/$dir"
    echo "${REPORTLINEPREFIX}"
    PUBLICATIONPOINTSFILES=$(find  ${CONFIGDIR}/$dir -name *.publication.json )
    for f in ${PUBLICATIONPOINTSFILES} ; do
            echo "${REPORTLINEPREFIX}  + adding supporting $f"
            echo "${REPORTLINEPREFIX} "
	    jq -s '.[0] + .[1]' /tmp/supportingpublicationpoints.json $f > /tmp/spb.json
	    mv /tmp/spb.json /tmp/supportingpublicationpoints.json
    done
done

# remove the disabled publication points: no statistics should be build on them
jq '[.[]|select(  .disabled != true )]' /tmp/supportingpublicationpoints.json > /tmp/sp0.json






cp /tmp/supportingpublicationpoints.json ${TARGET}/report4/publication.json
