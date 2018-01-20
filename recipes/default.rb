#
# Cookbook:: jenkins
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

remote_file '/tmp/jenkins-ci.org.key' do
  source 'https://pkg.jenkins.io/debian/jenkins-ci.org.key'
  notifies :run, 'execute[apt-key add /tmp/jenkins-ci.org.key]', :immediately
end

execute 'apt-key add /tmp/jenkins-ci.org.key' do
  action :nothing
end

file '/etc/apt/sources.list.d/jenkins.list' do
  content 'deb http://pkg.jenkins.io/debian-stable binary/'
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'apt-get update' do
  action :nothing
end

package 'software-properties-common'

execute 'add-apt-repository ppa:openjdk-r/ppa' do
  not_if { File.exist?('/etc/apt/openjdk-r-ppa-trusty.list') }
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'apt-get update' do
  action :nothing
end

package 'openjdk-8-jre-headless'

package 'jenkins'

service 'jenkins' do
  action [ :start, :enable ]
end
