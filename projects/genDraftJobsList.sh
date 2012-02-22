#!/bin/bash
# Script to extract a list of RunDeck Job definitions to Git managed directory.
#
export PROJECT=$1
export MANIFEST=jobList.txt
export AUTH_TOKEN=VrdKke6c84sEpe4k5dk82p2p9rcO81OC
export RUNDECK_HOST="http://localhost:4440"
export JOBLISTING_ACTION="api/1/jobs"
export JOBEXPORT_ACTION="api/1/jobs/export"
export AUTH_PARM="authtoken=${AUTH_TOKEN}"
export PROJECT_PARM="project=${PROJECT}"
export FORMAT_PARM="format=yaml"
export PATH_PREFIX="net.fleetingclouds."

if [  -d  ${PROJECT}  ]; then 

	echo Generating draft jobs manifest to ./${PROJECT}/${MANIFEST}
	wget --quiet "${RUNDECK_HOST}/${JOBLISTING_ACTION}?${AUTH_PARM}&${PROJECT_PARM}" \
	-O - | xpath -q -e "result/jobs"  -e "job[*]/@id" \
	 | sed -e "s| id=\"||g" \
	 | sed -e "s|\"||g" \
	> ./${PROJECT}/${MANIFEST}
#
	echo Now process it
#
	mapfile -t JOB_LIST < "./${PROJECT}/${MANIFEST}"

	DEFAULT_LOCATION=`pwd`
#	echo DEFAULT_LOCATION = ${DEFAULT_LOCATION}

	FULL_URL="${RUNDECK_HOST}/${JOBEXPORT_ACTION}?${AUTH_PARM}&${PROJECT_PARM}&${FORMAT_PARM}&idlist="
	for JOB in "${JOB_LIST[@]}"
	do
		FILE_PATH=`echo $JOB | sed s/$PATH_PREFIX// | sed 's/\(.*\)\..*/\1/' | sed -e 's|\.|/|g' `
#		echo Path : ${DEFAULT_LOCATION}/${PROJECT}/jobs/${FILE_PATH}
#		echo File : ${JOB}.yaml

		LOCAL_PATH=${PROJECT}/jobs/${FILE_PATH}
		FULL_PATH=${DEFAULT_LOCATION}/${LOCAL_PATH}
		mkdir -p ${FULL_PATH}
		wget --quiet ${FULL_URL}${JOB} -O ${FULL_PATH}/${JOB}.yaml
		echo Wrote : ./${LOCAL_PATH}/${JOB}.yaml

	done

else

	echo No such project ${PROJECT}
fi

echo Done.
echo . . . .  . . . .  . . . .  . . . . 


exit


## wget --quiet 'http://continuous.warehouseman.com:4440/api/1/jobs?authtoken=VrdKke6c84sEpe4k5dk82p2p9rcO81OC&project=PrepareGenericVPS' -O - | xpath -q -e "result/jobs"  -e "job[*]/name/text() | job[*]/@id"

