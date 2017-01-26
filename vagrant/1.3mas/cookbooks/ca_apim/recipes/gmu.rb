execute "centosENV Install" do
   command <<-EOH
   sleep 30
   ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle centosENV.xml --results argfiles/centosIn.xml
   ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle mas13.xml --results argfiles/mas13In.xml
   EOH
   cwd '/vagrant/GMU-1.3'
end

service 'ssg' do
    action :restart
end

# execute "MAS GMU_Bundle Install" do
#    command <<-EOH
#    sleep 30
#    ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle mas13.xml --results argfiles/mas13In.xml
#    EOH
#    cwd '/vagrant/GMU-1.3'
# end

# reboot 'reboot now' do
#     action :reboot_now
# end


# execute "reboot now" do
#    command <<-EOH
#    shutdown -r now
#    EOH
#    cwd '/vagrant'
# end

#   ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle mag33.xml --results argfiles/mag33In.xml
#   ./GatewayMigrationUtility.sh migrateIn -z centos.txt --bundle mas13.xml --results argfiles/mas13In.xml

