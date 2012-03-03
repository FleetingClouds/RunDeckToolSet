#!/bin/bash
# Script to extract a list of RunDeck Job definitions to Git managed directory.
#
declare PROJECT=$1
declare AUTH_TOKEN=$2
#
declare MANIFEST=jobList.txt
# declare AUTH_TOKEN=NOn57K48k3C4cKRCN48kU1cK7ds6KSrS
declare RUNDECK_HOST="http://localhost:4440"
declare SYSTEM_ACTION="api/1/system/info"
declare JOBLISTING_ACTION="api/1/jobs"
declare JOBEXPORT_ACTION="api/1/jobs/export"
#
declare PROJECT_PARM="project=${PROJECT}"
declare FORMAT="yaml"
#declare FORMAT="xml"
declare FORMAT_PARM="format=${FORMAT}"
declare PATH_PREFIX="net.fleetingclouds."
#
if [ 32 == "${#AUTH_TOKEN}" ]; then
        echo "Found token on command line"
else
        read -n 32 -s -p "Please paste your 32 digit authorization token here, now : " AUTH_TOKEN
fi
#
echo -e "\n"

if [  -d  "${PROJECT}"  ]; then 
#
	wget --quiet -O /dev/null "${RUNDECK_HOST}/${SYSTEM_ACTION}?authtoken=${AUTH_TOKEN}"
	RESULT=$?
#
	if [  $RESULT == 8 ]; then
		echo -e "Failed : You need to use a *valid* Authentication Token"
		exit $RESULT;
	fi
#
	echo -e "Generating draft jobs manifest to ./${PROJECT}/${MANIFEST}"
	echo -e "Rundeck API URL is set to :\n ${RUNDECK_HOST}/${JOBLISTING_ACTION}?${PROJECT_PARM}&authtoken=${AUTH_TOKEN:0:10}xxx..."
#
	wget --quiet "${RUNDECK_HOST}/${JOBLISTING_ACTION}?authtoken=${AUTH_TOKEN}&${PROJECT_PARM}" \
	-O - | xpath -q -e "result/jobs"  -e "job[*]/@id" \
	 | sed -e "s| id=\"||g" \
	 | sed -e "s|\"||g" \
	> ./${PROJECT}/${MANIFEST}
#
	echo Processing now ...
#
	mapfile -t JOB_LIST < "./${PROJECT}/${MANIFEST}"

	DEFAULT_LOCATION=`pwd`
#	echo DEFAULT_LOCATION = ${DEFAULT_LOCATION}

	FULL_URL="${RUNDECK_HOST}/${JOBEXPORT_ACTION}?authtoken=${AUTH_TOKEN}&${PROJECT_PARM}&${FORMAT_PARM}&idlist="
	for JOB in "${JOB_LIST[@]}"
	do
		FILE_PATH=`echo $JOB | sed s/$PATH_PREFIX// | sed 's/\(.*\)\..*/\1/' | sed -e 's|\.|/|g' `
#		echo Path : ${DEFAULT_LOCATION}/${PROJECT}/jobs/${FILE_PATH}
#		echo File : ${JOB}.${FORMAT}

		LOCAL_PATH=${PROJECT}/jobs/${FILE_PATH}
		FULL_PATH=${DEFAULT_LOCATION}/${LOCAL_PATH}
		TMP_PATH=${DEFAULT_LOCATION}/tmp
		mkdir -p ${FULL_PATH}
		mkdir -p ${TMP_PATH}
		wget --quiet ${FULL_URL}${JOB} -O ${TMP_PATH}/intermediateResult.txt
		RESULT=$?
#
		if [  $RESULT == 8 ]; then
			echo -e "Failed : You need to use a *valid* Authentication Token"
			exit $RESULT;
		else
			mv ${TMP_PATH}/intermediateResult.txt ${FULL_PATH}/${JOB}.${FORMAT}
			echo Wrote : ./${LOCAL_PATH}/${JOB}.${FORMAT}
		fi

	done

else

	echo No such project ${PROJECT}
fi

echo Done.
echo . . . .  . . . .  . . . .  . . . . 


exit


## wget --quiet 'http://continuous.warehouseman.com:4440/api/1/jobs?authtoken=VrdKke6c84sEpe4k5dk82p2p9rcO81OC&project=PrepareGenericVPS' -O - | xpath -q -e "result/jobs"  -e "job[*]/name/text() | job[*]/@id"

