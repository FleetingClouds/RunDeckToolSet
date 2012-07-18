#!/bin/bash
# Script to upload a Job definition to RunDeck.
#
# Usage example :  ./upload.sh . net.fleetingclouds.install.php.prepare.yaml Vd48OC2S01O4P4ESvERcp5KesdOV8R3d http://test6.warehouseman.com:4440/
declare FILE_PATH=$1
declare DEF_FILE=$2
declare AUTH_TOKEN=$3
#
if [   "XX" == "XX$4"   ]; then
   declare RUNDECK_HOST="http://localhost:4440"
else
	declare RUNDECK_HOST=$4
fi
#
declare IMPORT_ACTION="api/4/jobs/import"
#
declare DUPE_OPTION="update"
#
declare FILE_FORMAT="yaml"
#
rm -fr ~/tmp/rdLogs
mkdir -p ~/tmp/rdLogs
touch ~/tmp/rdLogs/failures.txt
#
#
echo Uploading ${FILE_PATH}/${DEF_FILE}
curl --silent --output ~/tmp/rdLogs/${DEF_FILE}.rslt --form xmlBatch=@${FILE_PATH}/${DEF_FILE} "${RUNDECK_HOST}${IMPORT_ACTION}?format=${FILE_FORMAT}&dupeOption=${DUPE_OPTION}&authtoken=${AUTH_TOKEN}"
SUCCESS=`cat ~/tmp/rdLogs/${DEF_FILE}.rslt | xpath -q -e '//*[@count="1"]' | grep -c succeeded`
if [  ${SUCCESS} -lt 1  ]; then
	echo Problem with ${DEF_FILE}
	echo ${DEF_FILE} >> ~/tmp/rdLogs/failures.txt
	exit 13;
else
	echo Uploaded ${DEF_FILE}
	exit 0;
fi

