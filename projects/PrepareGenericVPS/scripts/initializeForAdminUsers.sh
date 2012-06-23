#!/bin/bash
#
#  This script has the purpose of preparing a remote VPS for first time use.
#  It adds the bare minimum of tools for replacing UID/PWD security with SSH key security.
#  If you do not have an authorized key you will be locked out.
#  To easily run this script, using the root password supplied by the hosting 
#   service, log into the vacant VPS (Ubuntu server) and paste these four commands :
#   (but NOT the if block, itself)
if [  0 == 1 ]; then
   rm -f ./initialize.sh*
   wget https://raw.github.com/FleetingClouds/RunDeckToolSet/master/firstStart/initialize.sh
   chmod a+x ./initialize.sh
   ./initialize.sh
fi
#
#  Next : From the command line in your rundeck server, start up an SSH session with
#   the VPS using rundeck as the user name : 
#              ssh rundeck@www.warehouseman.com
#  You will be prompted to change your password from "okokok" to something more secure.
#
export OUR_USER="rundeck"
export CHEF_USER="chef"
echo "Setting up access for \"${OUR_USER}\" and for \"${CHEF_USER}\" ................"
#
echo "Get ${OUR_USER} home directory .. . . . . . . . "
export OUR_USER_HOME=$(  grep "${OUR_USER}" /etc/passwd | awk -F: '{print $6}'  )
#
# 
#
echo "Activate apt-get  .............................................."
dpkg --configure -a
apt-get install -fy
#
# 
#
echo "Activate locales  .............................................."
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales
#
# 
#
echo "Install nano ..................................................."
apt-get -y install nano
#
echo "Fiddle setuid bits for sick VPS ................................"
chmod 4755 /usr/bin/passwd
chmod 4755 /usr/bin/sudo
#
#
if [  "XX${OUR_USER_HOME}" == "XX"  ]; then
	#
	echo "Create admin group  ............................................"
	addgroup admin
	#
	echo "Create a full privileges admin user  ..........................."
	export PASS_HASH=$(perl -e 'print crypt($ARGV[0], "password")' "okokok")
	echo ${PASS_HASH}
	# addgroup sudo
	useradd -Ds /bin/bash
	useradd -m -G admin,sudo -p ${PASS_HASH} ${OUR_USER}
	passwd -e ${OUR_USER}
	#
	OUR_USER_HOME=/home/${OUR_USER}
else
	echo "The ${OUR_USER} user account is already configured in ${OUR_USER_HOME} . . . "
fi
#
echo "................................................................"
echo "Get public keys of expected clients  ..........................."
echo "................................................................"
mkdir -p ${OUR_USER_HOME}/.ssh
wget https://github.com/downloads/martinhbramwell/Cloud-Fitnesse-Tester/PublicKeys.txt
mv PublicKeys.txt ${OUR_USER_HOME}/.ssh/authorized_keys
#
#
echo "................................................................"
echo "Create a full privileges Chef user  ..........................."
echo "................................................................"
export PASS_HASH=$(perl -e 'print crypt($ARGV[0], "password")' "okokok")
echo ${PASS_HASH}
# 
useradd -m -G admin,sudo -p ${PASS_HASH} ${CHEF_USER}
passwd -e ${CHEF_USER}
#
echo "................................................................"
echo "Put the same keys in Chef user account  ........................"
echo "................................................................"
mkdir -p /home/${CHEF_USER}/.ssh
# wget https://github.com/downloads/FleetingClouds/RunDeckToolSet/auth_hosts_001
# mv auth_hosts_001 /home/${CHEF_USER}/.ssh/authorized_keys
cp ${OUR_USER_HOME}/.ssh/authorized_keys /home/${CHEF_USER}/.ssh
chown -R ${CHEF_USER}:${CHEF_USER} /home/${CHEF_USER}/.ssh
#
echo "................................................................"
echo "Assign correct ownership  ......................................"
echo "................................................................"
chown -R ${OUR_USER}:${OUR_USER} ${OUR_USER_HOME}
chown -R ${CHEF_USER}:${CHEF_USER} /home/${CHEF_USER}
#
# /id_rsa.pub




echo "Turn off password access completely  ..........................."
pushd /etc/ssh/
mv sshd_config sshd_config_backup
sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' <sshd_config_backup >sshd_config
cat sshd_config* | grep PasswordAuthentication
popd
#
echo "Turn off root access completely  ..........................."
sudo rm -fr /root/.ssh
#
echo "Restart SSH server ............................................."
restart ssh
#
echo "Finished  ......................................................"
exit;
