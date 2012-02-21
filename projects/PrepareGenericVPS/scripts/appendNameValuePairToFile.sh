#!/bin/bash
# Script to collect prepare an empty Jenkins server with an empty Fitnesse wiki.
#

targetFilePath=""
variableName=""
variableValue=""

#  Input validations
function giveHelp {
   
   echo "Usage: $0 -p targetFilePath -n variableName -v variableValue"
   echo " - -p absolute path of the file"
   echo " - -n name of the pair"
   echo " - -v value of the pair"
   echo ""
   echo "returns : 0 = success, >0 = fail"
   exit
}

if [ $# -lt 3 ] ; then
  giveHelp
  exit 1
fi 
#
while [ $# -gt 1 ] ; do
  case $1 in
    -p) targetFilePath=$2 ; shift 2 ;;
    -n) variableName=$2 ; shift 2 ;;
    -v) variableValue=$2 ; shift 2 ;;
    *) shift 1 ;;
  esac
done
#
#
if [ "X${targetFilePath}" == "X" ] || [ "X${variableName}" == "X" ] || [ "X${variableValue}" == "X" ]; then
  echo "Got -p ${targetFilePath} -n ${variableName} -v ${variableValue}" && giveHelp && exit 1
fi
#
[ ! -f ${targetFilePath} ] && echo "${targetFilePath} : File not found!" && exit 1

echo Will append the text \"${variableName}=${variableValue}\" to the file ${targetFilePath}.
echo ""
#exit 1

# Input validated

sudo grep -q ${variableName} ${targetFilePath} || echo ${variableName}=${variableValue}  | sudo tee -a ${targetFilePath}

exit
