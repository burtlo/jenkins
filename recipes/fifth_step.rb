node.default['jenkins']['master']['repository'] = 'https://pkg.jenkins.io/debian/'
node.default['jenkins']['master']['distribution'] = 'binary/'
node.default['jenkins']['master']['repository_key'] = 'https://pkg.jenkins.io/debian/jenkins-ci.org.key'

apt_repository 'jenkins' do
  uri node.default['jenkins']['master']['repository']
  distribution node.default['jenkins']['master']['repository']
  key  node.default['jenkins']['master']['repository_key']
end

node.default['java']['install_flavor'] = 'openjdk'
node.default['java']['openjdk_packages'] = [ 'openjdk-8-jre-headless' ]
node.default['java']['jdk_version'] = '8'

include_recipe 'java'

package 'jenkins'

service 'jenkins' do
  action [ :start, :enable ]
end
