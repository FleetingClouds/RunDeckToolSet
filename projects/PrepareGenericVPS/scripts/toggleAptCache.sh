#! /bin/bash 
# script to tuen on or off caching for apt
#
export PF=`grep -l "Proxy" /etc/apt/apt.conf.d/*`
export MSG="Caching of apt has been : "
#
if [ -f PROXY_FILE ]; then
   mv PROXY_FILE /etc/apt/apt.conf.d/03proxy
   echo "${MSG}enabled."
else
   if [  "XX${PF}" == "XX"  ]; then
      echo "No apt proxy file found at all."
      exit
   else
      mv ${PF} ./PROXY_FILE
      echo "${MSG}disabled."
   fi
fi


