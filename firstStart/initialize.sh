#!/bin/bash
#
#  This script has the purpose of preparing a remote VPS for first time use.
#  It adds the bare minimum of tools for replacing UID/PWD security with SSH key security.
#  If you do not have an authorized key you will be locked out.
#  To easily run this script, using the root password supplied by the hosting 
#   service, log into the vacant VPS (Ubuntu server) and paste these four commands :
#   (but NOT the if block, itself)
#
# To obtain this script, execute the contained three lines
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
echo "Setting up access for ${OUR_USER}."
#
# Activate apt-get
#
dpkg --configure -a
apt-get install -f
#
# Activate locales
#
apt-get install language-pack-en
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales
#
# Install required tools
#
apt-get install nano
#
# Create a full privileges admin user
#
addgroup admin
#
export PASS_HASH=$(perl -e 'print crypt($ARGV[0], "password")' "okokok")
echo ${PASS_HASH}
# addgroup sudo
useradd -Ds /bin/bash
useradd -m -G admin,sudo -p ${PASS_HASH} ${OUR_USER}
passwd -e ${OUR_USER}
#
mkdir -p /home/${OUR_USER}/.ssh
wget https://github.com/downloads/martinhbramwell/Cloud-Fitnesse-Tester/PublicKeys.txt
mv PublicKeys.txt /home/${OUR_USER}/.ssh/authorized_keys
#
chown -R ${OUR_USER}:${OUR_USER} /home/${OUR_USER}
#
pushd /etc/ssh/
mv sshd_config sshd_config_backup
sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' <sshd_config_backup >sshd_config
cat sshd_config* | grep PasswordAuthentication
popd
#
restart ssh
#
exit 0;
