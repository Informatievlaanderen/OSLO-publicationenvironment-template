#!/bin/bash

# for debugging purposes
#set -x

extractwhat=$1
TARGETDIR=/tmp/workspace
CHECKOUTFILE=${TARGETDIR}/checkouts.txt
CONFIGDIR_DEFAULT=$( eval echo "${CIRCLE_WORKING_DIRECTORY}" )
CONFIGDIR=${2:-$CONFIGDIR_DEFAULT/config}


REPORTLINEPREFIX='#||# '

STRICT=$(jq -r .toolchain.strickness ${CONFIGDIR}/config.json)
execution_strickness() {
    if [ "${STRICT}" != "lazy" ]; then
        exit -1
    fi
}

#############################################################################################
# extraction command functions

get_mapping_file() {
    if [ -f ".names.json" ] ; then
	    # mapping file is already extracted
	MAPPINGFILE=".names.json"
    else 
    local MAPPINGFILE=`jq -r 'if (.filename | length) > 0 then .filename else @sh "config/eap-mapping.json"  end' .publication-point.json`
    #local MAPPINGFILE="config/eap-mapping.json"
    if [ -f ".names.txt" ]
    then
	STR=".[] | select(.name == \"$(cat .names.txt)\") | [.]"
	jq "${STR}" ${MAPPINGFILE} > .names.json
	MAPPINGFILE=".names.json"
    fi
    fi
    echo ${MAPPINGFILE}
}



#############################################################################################
extract_stakeholder() {
    local MAPPINGFILE=$1
    local TDIR=${TARGETDIR}/ttl
    mkdir -p ${TDIR}
    jq -r '.[] | select(.type | contains("voc")) | @sh "python /app/specgen/generate_vocabulary.py --add_contributors --rdf /tmp/workspace/ttl/\(if .prefix then .prefix + "/" else "" end)\(.name).ttl --csv src/stakeholders.csv --csv_contributor_role_column \(.contributors) --output /tmp/workspace/ttl/\(if .prefix then .prefix + "/" else "" end)\(.name).ttl"' < $MAPPINGFILE | bash -e
}

#############################################################################################
# main one being worked on
extract_json() {
    local MAPPINGFILE=$1
    local LINE=$2
    local TDIR=${TARGETDIR}/json
    local RDIR=${TARGETDIR}/report4
    local TTDIR=${TARGETDIR}/report4/${LINE}
    mkdir -p ${TDIR} ${RDIR} ${TTDIR} ${TARGETDIR}/target/${LINE}

    local OUTPUTFILE=$(cat .names.txt).jsonld
    local DIAGRAM=$( jq -r .[].diagram ${MAPPINGFILE} )
    local UMLFILE=$( jq -r .[].eap ${MAPPINGFILE} )
    local SPECTYPE=$( jq -r .[].type ${MAPPINGFILE} )
    local URLREF=$( jq -r .urlref .publication-point.json )
    local HOSTNAME=$( jq -r .hostname  ${CONFIGDIR}/config.json )
    local DOMAIN=$( jq -r .domain  ${CONFIGDIR}/config.json )
#    local REPORTFILE=${TTDIR}/$(cat .names.txt).report
    local REPORTFILE=${TTDIR}/oslo-converter-ea.report.md

    touch ${REPORTFILE}
    if [ -f branchtag.report.md ] ; then 
	    cp branchtag.report.md ${TTDIR}/branchtag.report.md 
    fi

    case $SPECTYPE in
	    ap) SPECTYPE="ApplicationProfile"
		    ;;
            voc) SPECTYPE="Vocabulary"
		    ;;
            oj) SPECTYPE="ApplicationProfile"
		    ;;
            *) echo "ERROR: ${SPECTYPE} not recognized"
	       SPECTYPE="ApplicationProfile"	    
    esac


    HOSTNAME2=$(echo ${HOSTNAME} | sed -e "s|/$||g" )
    URLREF2=$(echo ${URLREF} | sed -e "s|^/||g" )


    echo "${REPORTLINEPREFIX}oslo-converter-ea for diagram ${DIAGRAM}" &>>${REPORTFILE}
    echo "${REPORTLINEPREFIX}-------------------------------------" &>>${REPORTFILE}
    oslo-converter-ea --umlFile ${UMLFILE} --diagramName ${DIAGRAM} --outputFile ${OUTPUTFILE} \
                 --specificationType ${SPECTYPE} --versionId ${URLREF2} --baseUri https://${DOMAIN} \
                 --publicationEnvironment ${HOSTNAME2}/ \
                 &> ${REPORTFILE}

        if [ $? -gt 0 ] ; then
            echo "UML extraction failed"
            execution_strickness
        fi

    # XXX use one export for reporting one for processing

    SK_REPORTFILE=${TTDIR}/oslo-stakeholders-converter.report.md
    echo "${REPORTLINEPREFIX}oslo-stakeholders-converter" &>>${SK_REPORTFILE}
    echo "${REPORTLINEPREFIX}-------------------------------------" &>>${SK_REPORTFILE}
    oslo-stakeholders-converter --input stakeholders.csv --outputFormat application/json --output ${TTDIR}/stakeholders.json &>>${SK_REPORTFILE}
    oslo-stakeholders-converter --input stakeholders.csv --outputFormat application/json --output stakeholders.json

#   exit code of java program is not reliable for detecting processing error
#    if  [ $? -eq 0 ] ; then
#   the content is also not reliable as it contains error when there are business errors
#    if cat ${TTDIR}/$(cat .names.txt).report | grep "error" 
#    then
#       echo "extract_json: ERROR EA-to-RDF ended in an error"
#       cat ${TTDIR}/$(cat .names.txt).report
#       exit -1 ;
#    fi
    if [ ! -f "${OUTPUTFILE}" ]
    then
        echo "extract_json: ${OUTPUTFILE} was not created"
        cat  ${REPORTFILE}
	echo "{}" > ${OUTPUTFILE}
	execution_strickness
        # exit -1;
    fi
    jq . ${OUTPUTFILE} &> /dev/null
    if [ ! $? -eq 0 ] || [ ! -s  $(cat .names.txt).jsonld ]; then
        echo "extract_json: ERROR UML extractor ended in an error"
        cat ${REPORTFILE}
	execution_strickness
        # exit -1 ;
    fi

    cat .publication-point.json
    jq -s '.[0] + .[1][0] + .[2]' ${OUTPUTFILE} $MAPPINGFILE .publication-point.json > ${TTDIR}/all-$(cat .names.txt).jsonld ## the sum in jq overwrites the value for .contributors
    cp ${OUTPUTFILE} ${TTDIR}
    ## overwrite the content with the aggregated version
    cp ${TTDIR}/all-$(cat .names.txt).jsonld  $(cat .names.txt).jsonld 
    ( echo "\n########################\n" ) >> ${RDIR}/ALL.report
    ( echo $PWD ; cat ${REPORTFILE} ) >> ${RDIR}/ALL.report
}

#############################################################################################
# do the conversions

if [ ! -f "${CHECKOUTFILE}" ]
then
    # normalise the functioning
    echo $CWD > ${CHECKOUTFILE}
fi

cat ${CHECKOUTFILE} | while read line
do
    SLINE=${TARGETDIR}/src/${line}
    echo "Processing line ($extractwhat): ${SLINE}"
    if [ -d "${SLINE}" ]
    then
      pushd ${SLINE}
       MAPPINGFILE=$(get_mapping_file)   
       cat $MAPPINGFILE

       # determine the EAP config files to be used
       # if present use the repository ones, otherwise the definied by the publication environment
       jq -r '.[0] | if has("config") then empty else  @sh "cp ~/project/config/config-\(.type).json config" end ' < $MAPPINGFILE | bash 
       jq 'def maybe(k): if has(k) then { (k) : .[k] } else { (k) : "config/config-\(.type).json" } end; .[0] |= . + maybe("config")' $MAPPINGFILE > /tmp/mapfile
       cp /tmp/mapfile $MAPPINGFILE
       case $extractwhat in
	      jsonld) extract_json $MAPPINGFILE $line
		      ;;
        stakeholders) extract_stakeholder $MAPPINGFILE
		      ;;
                   *) echo "ERROR: $extractwhat not defined"
        esac
      popd
    else
      echo "Error: ${SLINE}" >> log.txt
    fi
done

