#! /bin/bash
# Script that prepares a machine for using RubyGems
#
# Reference pages :
#  #  http://wiki.opscode.com/display/chef/Workstation+Setup+for+Debian+and+Ubuntu
#
declare INSTALLERS=~/installers
declare RUBY_HOME=~/programs/org/rubygems
#
aptitude -y update
aptitude -y upgrade
#
#
echo "Install Ruby and other Dependencies"
#
echo " - ruby"
aptitude -y install ruby
echo " - ruby-dev"
aptitude -y install ruby-dev
echo " - libopenssl-ruby"
aptitude -y install libopenssl-ruby
echo " - rdoc"
aptitude -y install rdoc
echo " - ri"
aptitude -y install ri
echo " - irb"
aptitude -y install irb
echo " - build-essential"
aptitude -y install build-essential
echo " - wget"
aptitude -y install wget
echo " - ssl-cert"
aptitude -y install ssl-cert
echo " - curl"
aptitude -y install curl
#
#
echo "Install RubyGems from Source"
#
echo " - prepare directories"
mkdir -p ${INSTALLERS}
mkdir -p ${RUBY_HOME}
#
echo " - get RubyGems"
pushd ${INSTALLERS}
rm -f rubygems-1.8.10.tgz
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
popd
#
echo " - unpack RubyGems"
pushd ${RUBY_HOME}
rm -fr rubygems-1.8.10
tar zxf ${INSTALLERS}/rubygems-1.8.10.tgz
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
aptitude -y update
aptitude -y upgrade
#

