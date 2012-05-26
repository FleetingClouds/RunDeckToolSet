#! /bin/bash
# Script that prepares a machine for using Ruby
#
# Reference pages :
#  #  http://wiki.opscode.com/display/chef/Workstation+Setup+for+Debian+and+Ubuntu
#
#     ¡¡  THIS HAS NOT YET BEEN TESTED  !!
#  
sudo aptitude -y update
sudo aptitude -y upgrade
#
#
echo "Install Ruby and other Dependencies"
#
sudo aptitude -y install ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert curl git-core
#
#
#
echo "Install RubyGems from Source"
#
echo " - prepare directories"
mkdir -p ~/installers
mkdir -p ~/programs/org/rubygems
pushd ~/installers
#
echo " - get RubyGems"
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
popd
pushd ~/programs/org/rubygems
#
echo " - unpack RubyGems"
tar zxf rubygems-1.8.10.tgz
#
echo " - make symbolic link"
ln -s rubygems-1.8.10 rubygems
pushd rubygems
#
echo " - run the setup"
ruby setup.rb --no-format-executable
popd
popd
#
#
echo "Run the gem installer for chef"
#
sudo gem install chef --no-ri --no-rdoc

