#! /bin/bash
# Script that prepares a machine for using Chef Workstation
#
# Reference pages :
#  #  http://wiki.opscode.com/display/chef/Workstation+Setup+for+Debian+and+Ubuntu
#
#
declare CHEF_HOME=/home/chef
declare CHEF_REPO_NAME=chef-repo
declare CHEF_REPO=${CHEF_HOME}/${CHEF_REPO_NAME}
declare CHEF_PEMS=${CHEF_REPO}/.chef
declare INSTALLERS=~/installers
declare LOCAL_MIRROR=http://openerpns.warehouseman.com/downloads
#
echo "Ensure Ruby and RubyGems are already installed."
source ./installRubyGems.sh
#
#
echo "Run the gem installer for chef"
#
gem install chef --no-ri --no-rdoc
#
#
#
echo "Prepare a default local Chef repository"
#
pushd ${INSTALLERS}
rm -f chef-repo.tgz
curl https://nodeload.github.com/opscode/chef-repo/tarball/master > chef-repo.tgz
popd
#
echo "Create a folder for chef"
mkdir -p ${CHEF_HOME}
pushd ${CHEF_HOME}
pwd
echo "Create a repository for chef"
rm -fr ${CHEF_REPO_NAME}
tar xvf ${INSTALLERS}/chef-repo.tgz
mv -i opscode-chef-repo-a3bec38/ ${CHEF_REPO_NAME}
popd
#
echo "Create a Configuration Folder"
mkdir -p ${CHEF_PEMS}
#
#
echo "Get Chef secrets"
pushd ${CHEF_PEMS}
pwd
wget ${LOCAL_MIRROR}/chef/hasanb.pem
wget ${LOCAL_MIRROR}/chef/fltgclds-validator.pem
wget ${LOCAL_MIRROR}/chef/knife.rb
popd
#
echo "Hand it all over to correct ownership"
chown -R chef:chef ${CHEF_HOME}
#
#
echo "Verify it is all working."
knife client list
#
echo ""
echo ""
echo "Chef Workstation is now installed."
echo ""
echo ""


