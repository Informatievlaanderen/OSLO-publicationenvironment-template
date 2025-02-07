#!/bin/bash

#set -x 

# Arg1 = file under consideration
# Arg2 = file to be created, filename is also an encoding of the query to be executed
# Arg3 = grouping per type or not
# Arg4 = add uri  or not

filedir=$(dirname $1)
filename=$(basename $1)
ROOTSPECIFICATIONS=$(cat rootspecifications)
PERTYPE=${3:-false}
ADDURI=${4:-false}

TARGET=$2

OUTPUT=${TARGET%.*} ; \
selector=${OUTPUT##*.} ; \

if [ ${PERTYPE} == true ] ; then
        TYPE=$(jq -r '.documenttype' $1)
        OUTPUT=${OUTPUT}.${TYPE}
fi
if [ ! -f $OUTPUT ] ; then
	echo "[]" > $OUTPUT
fi

if [ ${ADDURI} == true ] ; then

	for root in ${ROOTSPECIFICATIONS} ;
	do
	if [[ "${filedir}" =~ "${root}" ]] ; then
	  jq ".values.$selector" "$1" > /tmp/$filename.json
	  URI=$(jq -r .uri "$1")
	  jq --arg id "${URI}" '.[] |= . + {"spec" : "\($id)"} '  /tmp/$filename.json > /tmp/$filename.1.json
	  jq -s ".[0] + .[1]" ${OUTPUT} /tmp/$filename.1.json >> ${OUTPUT}.0 ;
	  mv ${OUTPUT}.0 ${OUTPUT};
	fi
	done

else

	for root in ${ROOTSPECIFICATIONS} ;
	do
	if [[ "${filedir}" =~ "${root}" ]] ; then
	  jq -s ".[0] + .[1].values.$selector  " ${OUTPUT} "$1" >> ${OUTPUT}.0 ;
	  mv ${OUTPUT}.0 ${OUTPUT};
	fi
	done

fi

