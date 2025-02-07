#!/bin/bash

#set -x 

# Arg1 = file under consideration
# Arg2 = data to be created
# Arg3 = json values selector to extract the data from file Arg1 to be aggregated in file Arg2
# Arg4 = grouping per type or not
# Arg5 = add uri  or not

filedir=$(dirname $1)
filename=$(basename $1)
ROOTSPECIFICATIONS=$(cat rootspecifications)
PERTYPE=${4:-false}
ADDURI=${5:-false}

OUTPUT=$2

if [ ${PERTYPE} == true ] ; then
	TYPE=$(jq -r '.documenttype' $1)
	OUTPUT=$2.${TYPE}
fi
if [ ! -f $OUTPUT ] ; then
	echo "[]" > $OUTPUT
fi

if [ ${ADDURI} == true ] ; then

	for root in ${ROOTSPECIFICATIONS} ;
	do
	if [[ "${filedir}" =~ "${root}" ]] ; then
	  jq ".values.$3" "$1" > /tmp/$filename.json
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
	  jq -s ".[0] + .[1].values.$3  " ${OUTPUT} "$1" >> ${OUTPUT}.0 ;
	  mv ${OUTPUT}.0 ${OUTPUT};
	fi
	done

fi

