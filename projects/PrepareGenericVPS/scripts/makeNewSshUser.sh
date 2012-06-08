#!/bin/bash
export A_NEW_USER=$1
#
echo "Get ${A_NEW_USER} home directory .. . . . . . . . "
export A_NEW_USER_HOME=$(  grep "${A_NEW_USER}" /etc/passwd | awk -F: '{print $6}'  )
echo "New user's hme directory is ${A_NEW_USER_HOME}"
#
if [  "XX${A_NEW_USER_HOME}" == "XX"  ]; then
	#
	echo "Create admin group  ............................................"
	addgroup admin
	#
	echo "Create a full privileges admin user  ..........................."
	export PASS_HASH=$(perl -e 'print crypt($ARGV[0], "password")' "ok${A_NEW_USER}ok")
	echo ${PASS_HASH}
	# addgroup sudo
	useradd -Ds /bin/bash
	useradd -m -G admin,sudo -p ${PASS_HASH} ${A_NEW_USER}
	passwd -e ${A_NEW_USER}
	#
	A_NEW_USER_HOME=/home/${A_NEW_USER}
else
	echo "The ${A_NEW_USER} user account is already configured in ${A_NEW_USER_HOME} . . . "
fi
#
echo "................................................................"
echo "Prepare for SSH tasks"
echo "................................................................"
export A_NEW_USER_SSH_DIR=${A_NEW_USER_HOME}/.ssh
mkdir -p ${A_NEW_USER_SSH_DIR}
#
pushd ${A_NEW_USER_SSH_DIR}
#
  #
  echo "................................................................"
  echo "Generate SSH key pair for ${A_NEW_USER}"
  echo "................................................................"
  rm -f id_rsa*
  ssh-keygen -f id_rsa -t rsa -N '' -C "${A_NEW_USER}@${A_NEW_USER}.me"
  #
  echo "................................................................"
  echo "Get public keys of expected clients  ..........................."
  echo "................................................................"
  rm -f *.txt
  rm -f authorized_keys
  wget https://github.com/downloads/martinhbramwell/Cloud-Fitnesse-Tester/PublicKeys_${A_NEW_USER}.txt
  mv PublicKeys_${A_NEW_USER}.txt authorized_keys
  #
#
popd
#
echo "................................................................"
echo "Assign correct ownership  ......................................"
echo "................................................................"
chown -R ${A_NEW_USER}:${A_NEW_USER} /home/${A_NEW_USER}
#
#
echo "................................................................"
echo "Here is ${A_NEW_USER}'s public key"
echo "................................................................"
echo " "
cat ${A_NEW_USER_SSH_DIR}/id_rsa.pub
echo " "
echo " "
echo " "

