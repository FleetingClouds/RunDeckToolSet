#!/bin/bash
# Script to inject a list of Git managed RunDeck Job definitions back into RunDeck.
#
declare PROJECT=$1
declare AUTH_TOKEN=$2
#
declare RUNDECK_HOST="http://localhost:4440"
declare IMPORT_ACTION="api/3/jobs/import"
# declare AUTH_TOKEN="VrdKke6c84sEpe4k5dk82p2p9rcO81OC"
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
#
			curl --silent --output ~/tmp/rdLogs/${DEF_FILE}.rslt --form xmlBatch=@${DEF_FILE} "${RUNDECK_HOST}/${IMPORT_ACTION}?format=${FILE_FORMAT}&dupeOption=${DUPE_OPTION}&authtoken=${AUTH_TOKEN}"
			SUCCESS=`cat ~/tmp/rdLogs/${DEF_FILE}.rslt | xpath -q -e '//*[@count="1"]' | grep -c succeeded`
			if [  ${SUCCESS} -lt 1  ]; then
				echo $SPACER Problem with ${DEF_FILE}
				echo ${DEF_FILE} >> ~/tmp/rdLogs/failures.txt
			else
				echo $SPACER Restored ${DEF_FILE}
			fi
		fi
	done
}
#
if [ 32 == "${#AUTH_TOKEN}" ]; then
        echo "Found token on command line"
else
        read -n 32 -s -p "Please paste your 32 digit authorization token here, now : " AUTH_TOKEN
fi
echo -e "\nRundeck API URL is set to :\n ${RUNDECK_HOST}/${IMPORT_ACTION}?format=${FILE_FORMAT}&dupeOption=${DUPE_OPTION}&authtoken=${AUTH_TOKEN:0:10}xxx..."
#
mkdir -p ~/tmp/rdLogs
rm -f ~/tmp/rdLogs/failures.txt
touch ~/tmp/rdLogs/failures.txt
#
if [ -d ${PROJECT}  ]; then
	(cd ./${PROJECT}/jobs; recursiveList "..")
	FAILURE_COUNT=$(wc -l < ~/tmp/rdLogs/failures.txt )
		echo ${FAILURE_COUNT} failures
	if [  ${FAILURE_COUNT} > 0  ]; then 
		cat ~/tmp/rdLogs/failures.txt
	fi
else
	echo No such project : ${PROJECT}
fi

exit;




