
execute "install java 8" do
  command <<-EOH
    rpm -U jdk-8u91-linux-x64.rpm
  EOH
  cwd '/vagrant/vagrant_data/byo'
  not_if { ::File.exists?('/usr/java/jdk1.8.0_91/jre/lib/security') }
end

execute "add jce policy" do
  command <<-EOH
    rm -f /usr/java/jdk1.8.0_91/jre/lib/security/*.jar
    cp UnlimitedJCEPolicyJDK8/* /usr/java/jdk1.8.0_91/jre/lib/security
  EOH
  cwd '/vagrant/vagrant_data'
end

execute "install gateway rpm" do
  command <<-EOH
    rpm -U ssg-9.2.00-6904.noarch.rpm
    rpm -U ssg-appliance-9.2.00-6904.x86_64.rpm
    service ssg start
    sleep 15
  EOH
  cwd '/vagrant/vagrant_data/byo'
  not_if {::File.exists?('/opt/SecureSpan/Gateway/node/default/etc')}
end

execute "configure node properties" do
  command <<-EOH
    cat create-node.properties | /opt/SecureSpan/Gateway/config/bin/ssgconfig-headless create
    service ssg restart
  EOH
  cwd '/vagrant/vagrant_data'
end

directory "/opt/SecureSpan/Gateway/node/default/etc/bootstrap/license" do
  owner 'root'
  group 'root'
  mode  '0775'
  recursive true
end

execute "bootstrap license" do
  command <<-EOH
    cp SSG_Gateway_9.xml /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/
    cp SSG_MAG_9.xml /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/
    cp SSG_MAS_9.xml /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/
    chmod -R 775 /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/*.xml
    service ssg stop
    service ssg start
    sleep 15
  EOH
  cwd '/vagrant/vagrant_data/byo'
  not_if {::File.exists?('/opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/SSG_Gateway_9.xml')}
end

directory "/opt/SecureSpan/Gateway/node/default/etc/bootstrap/services" do
  owner 'root'
  group 'root'
  mode  '0775'
  recursive true
end

execute "install restman" do
  command <<-EOH
    touch restman
    service ssg restart
  EOH
  cwd '/opt/SecureSpan/Gateway/node/default/etc/bootstrap/services'
end
