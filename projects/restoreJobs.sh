#!/bin/bash
# Script to inject a list of Git managed RunDeck Job definitions back into RunDeck.
#
declare PROJECT=$1
#
declare RUNDECK_SERVER="http://localhost:4440"
declare API_TASK="api/3/jobs/import"
declare AUTH_TOKEN="VrdKke6c84sEpe4k5dk82p2p9rcO81OC"
declare DUPE_OPTION="update"
# declare DUPE_OPTION="create"
declare FILE_FORMAT="yaml"
#
#
recursiveList() {

	SPACER="..$1"
	DIR=`pwd`
#
	for DEF_FILE in *; do
		if [ -d ${DEF_FILE} ]; then
			(cd ${DEF_FILE}; recursiveList $SPACER)
		else
			curl -s --output ~/${DEF_FILE}.rslt --form xmlBatch=@${DEF_FILE} "${RUNDECK_SERVER}/${API_TASK}?authtoken=${AUTH_TOKEN}&format=${FILE_FORMAT}&dupeOption=${DUPE_OPTION}"
			SUCCESS=`cat ~/${DEF_FILE}.rslt | xpath -q -e '//*[@count="1"]' | grep -c succeeded`
			if [  ${SUCCESS} -lt 1  ]; then
				echo $SPACER Problem with ${DEF_FILE}
				echo ${DEF_FILE} >> ~/failures.txt
			else
				echo $SPACER Restored ${DEF_FILE}
			fi
		fi
	done
}
#
rm -f ~/failures.txt
touch ~/failures.txt
#
if [ -d ${PROJECT}  ]; then
	(cd ./${PROJECT}/jobs; recursiveList "..")
	FAILURE_COUNT=$(wc -l < ~/failures.txt )
		echo ${FAILURE_COUNT} failures
	if [  ${FAILURE_COUNT} > 0  ]; then 
		cat ~/failures.txt
	fi
else
	echo No such project : ${PROJECT}
fi

exit;




