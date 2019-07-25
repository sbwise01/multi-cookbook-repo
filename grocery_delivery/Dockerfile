FROM circleci/ruby:2.6
RUN sudo apt-get update -y && sudo apt-get install cmake -y
COPY Gemfile /tmp/Gemfile
RUN cd /tmp && bundle install
COPY gd-config.rb /etc/gd-config.rb
COPY knife.rb /root/.chef/knife.rb

# This is a good way to test grocery_delivery
