#
export RD_OPTION_HOST=$1
#
echo Will correct : $RD_OPTION_HOST
#
IP_ADDR=`echo $RD_OPTION_HOST | nslookup | grep Address | sed '1,1d' | sed s/Address://g`
echo $IP_ADDR
ssh-keygen -R $IP_ADDR
ssh-keygen -R $RD_OPTION_HOST
ssh $RD_OPTION_HOST

