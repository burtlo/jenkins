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

package 'jenkins'

# WARNING. The worry here is that installing Jenkins
# it will choose to install/link to the wrong version
# of Java (1.7 when 1.8 is required). So it may not work
# if you append the remaining steps after going to install
# the package.
#
# A THEORY:
#
#  If it does break one thing that worked before was to
# uninstall the jenkins package explicitly in the recipe
# and then re-install it after the other things have been
# done.
#
# package 'jenkins' do
#   action :remove
# end
#
package 'software-properties-common'

execute 'add-apt-repository ppa:openjdk-r/ppa' do
  not_if { File.exist?('/etc/apt/sources.list.d/openjdk-r-ppa-trusty.list') }
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'apt-get update' do
  action :nothing
end

package 'openjdk-8-jre-headless'

# Obviously this is the final, correct position of the jenkins package. The
# other previous entries would be removed.
package 'jenkins'

service 'jenkins' do
  action [ :start, :enable ]
end
