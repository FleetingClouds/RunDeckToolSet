#!/bin/bash
# Script to collect prepare an empty Jenkins server with an empty Fitnesse wiki.
#

targetFilePath=""
variableName=""
variableValue=""
separator=""
quotes=""

#  Input validations
function giveHelp {

   echo "Usage: $0 -p targetFilePath -n variableName -v variableValue"
   echo " - -p relative path of the file"
   echo " - -n name of the pair"
   echo " - -v value of the pair"
   echo " - -s separator character (=, \t, ' ')"
   echo " - -q quotes around the value of the pair (0/1)"
   echo ""
   echo "returns : 0 = success, >0 = fail"
   exit
}

if [ $# -lt 5 ] ; then
  giveHelp
  exit 1
fi
#
while [ $# -gt 1 ] ; do
  case $1 in
    -p) targetFilePath=$2 ; shift 2 ;;
    -n) variableName=$2 ; shift 2 ;;
    -v) variableValue=$2 ; shift 2 ;;
    -s) separator=$2 ; shift 2 ;;
    -q) quotes=$2 ; shift 2 ;;
    *) shift 1 ;;
  esac
done
#
#
if [ "X${targetFilePath}" == "X" ] || [ "X${variableName}" == "X" ] || [ "X${separator}" == "X" ] || [ "X${quotes}" == "X" ] || [ "X${variableValue}" == "X" ]; then
  echo "Got -p ${targetFilePath} -n ${variableName} -v ${variableValue}" && giveHelp && exit 1
fi
#
[ ! -f ${targetFilePath} ] && echo "${targetFilePath} : File not found!" && exit 1
echo "Separator = ${separator}"
echo "Quotes = ${quotes}"
aQuote='.'
[ "X${quotes}" == "X1" ] && aQuote="'"
#
echo Will try to append the text \"${variableName}${separator}${aQuote}${variableValue}${aQuote}\" to the file ${targetFilePath}.
echo ""
#exit 1

# Input validated

sudo grep -q ${variableName} ${targetFilePath} || echo ${variableName}${separator}${aQuote}${variableValue}${aQuote} | sudo tee -a ${targetFilePath}

exit
