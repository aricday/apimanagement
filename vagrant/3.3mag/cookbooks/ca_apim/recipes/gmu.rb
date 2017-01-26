execute "install GMU bundle" do
   command <<-EOH
   sleep 30
   ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle centosENV.xml --results argfiles/centosIn.xml
   ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle mag33.xml --results argfiles/mag33In.xml
   service ssg restart
   sleep 30
   EOH
   cwd '/vagrant/GMU-1.3'
end

#reboot 'reboot now' do
#    action :reboot_now
#end


execute "reboot now" do
    command <<-EOH
    shutdown -r now
    EOH
    cwd '/vagrant'
end
