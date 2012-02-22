#!/bin/bash
# Script to extract a list of RunDeck Job definitions to Git managed directory.
#
export PROJECT=$1
export MANIFEST=jobList.txt

if [  -d  ${PROJECT}  ]; then 

	if [  -f  ./${PROJECT}/${MANIFEST}  ]; then 
		echo Backing up jobs of project : ${PROJECT}
	else 
		echo No project jobs list : ./${PROJECT}/${MANIFEST}
	fi
else
	echo No such project ${PROJECT}
fi


exit


## wget --quiet 'http://continuous.warehouseman.com:4440/api/1/jobs?authtoken=VrdKke6c84sEpe4k5dk82p2p9rcO81OC&project=PrepareGenericVPS' -O - | xpath -q -e "result/jobs"  -e "job[*]/name/text() | job[*]/@id"

