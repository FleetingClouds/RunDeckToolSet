#!/bin/bash
#  Get Ready
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
wget https://github.com/downloads/martinhbramwell/Cloud-Fitnesse-Tester/SomePublicKeys.txt
mv SomePublicKeys.txt /home/${OUR_USER}/.ssh/authorized_keys
#
chown -R ${OUR_USER}:${OUR_USER} /home/${OUR_USER}
#
pushd /etc/ssh/
# mv sshd_config sshd_config_backup
sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' <sshd_config_backup >sshd_config
cat sshd_config* | grep PasswordAuthentication
popd
#
restart ssh
#
exit 0;
