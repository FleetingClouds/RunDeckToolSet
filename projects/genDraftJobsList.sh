#!/bin/bash
# Script to extract a list of RunDeck Job definitions to Git managed directory.
#
export PROJECT=$1
export MANIFEST=jobList.txt
export AUTH_TOKEN=VrdKke6c84sEpe4k5dk82p2p9rcO81OC

if [  -d  ${PROJECT}  ]; then 

	echo Generating draft jobs manifest of project : ${PROJECT}
	wget "http://localhost:4440/api/1/jobs?authtoken=$AUTH_TOKEN&project=$PROJECT" -O - | xpath -q -e "result/jobs"  -e "job[*]/@id" > ./${PROJECT}/${MANIFEST}
else
	echo No such project ${PROJECT}
fi


exit


## wget --quiet 'http://continuous.warehouseman.com:4440/api/1/jobs?authtoken=VrdKke6c84sEpe4k5dk82p2p9rcO81OC&project=PrepareGenericVPS' -O - | xpath -q -e "result/jobs"  -e "job[*]/name/text() | job[*]/@id"

