#! /bin/bash 
# Script that prepares a machine for developing Ruby on Rails
#
#
# Reference pages :
#  http://ruby.railstutorial.org/ruby-on-rails-tutorial-book
#  https://rvm.io//rvm/install/
#
sudo aptitude -y install pkg-config

mkdir -p ~/installers

wget -c http://nodejs.org/dist/node-v0.4.12.tar.gz
tar -xvvf node-v0.4.12.tar.gz
cd node-v0.4.12
export JOBS=2
./configure --prefix=$HOME/local/node
make
make install


# -----------
echo 'export PATH=$HOME/local/node/bin:$PATH' >> ~/.profile
echo 'export NODE_PATH=$HOME/local/node:$HOME/local/node/lib/node_modules' >> ~/.profile
source ~/.profile
source ~/.rvm/scripts/rvm
# -----------


curl -L get.rvm.io | sudo bash -s stable
source /etc/profile.d/rvm.sh
# type rvm | head -n 1
# rvm requirements
sudo aptitude -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion
sudo aptitude -y install libnotify-bin
# rvm list known
rvm install 1.9.2
ruby -v
# which ruby
# which gem
gem update
gem install rails
gem install autotest -v 4.4.6
gem install autotest-rails-pure -v 4.1.2
gem install ZenTest
gem install mynyml-redgreen --source http://gemcutter.org

# ---------------------------------------------------

cat > ~/.autotest <<EOF
# PLATFORM = RUBY_PLATFORM unless defined? PLATFORM 
require 'redgreen'
require 'autotest/timestamp'
 
module Autotest::GnomeNotify
  def self.notify title, msg, img
    system "notify-send '#{title}' '#{msg}' -i #{img} -t 3000"
  end
 
  Autotest.add_hook :ran_command do |at|
    image_root = "~/.autotest_images"
    results = [at.results].flatten.join("\n")
    results.gsub!(/\\e\[\d+m/,'')
    output = results.slice(/(\d+)\sexamples?,\s(\d+)\sfailures?(,\s(\d+)\spending?|)/)
    full_sentence, green, failures, garbage, pending = $~.to_a.map(&:to_i)
    if output
      if failures > 0
        notify "FAIL", "#{output}", "#{image_root}/fail.png"
      elsif pending > 0
        notify "Pending", "#{output}", "#{image_root}/pending.png"
      else
        notify "Pass", "#{output}", "#{image_root}/pass.png"
      end
    end
  end
  
  Autotest.add_hook :initialize do |at|
    %w{./log/test.log ./webrat.log}.each {|exception| at.add_exception(exception)}
  end
  
end
EOF


# ---------------------------------------------------


rm -fr ~/.autotest_images
mkdir -p ~/tmp
pushd ~/tmp
wget http://automate-everything.com/wp-content/uploads/2009/08/autotest_images.zip
unzip autotest_images.zip
popd
mv ~/tmp/home/eduard/.autotest_images .
rm -f ~/tmp/autotest_images.zip*
rm -fr ~/tmp/home


mkdir rails_projects
cd rails_projects
rails new demo_app
bundle install
cd demo_app

rails generate scaffold User name:string email:string
rails generate scaffold Micropost content:string user_id:integer
bundle exec rake db:migrate

rails server






