
execute "mysql yum repo" do
  command <<-EOH
    rpm -U http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
    yum install mysql-community-server -y
    service mysqld start
    mkdir /mysql_installed
  EOH
  not_if { ::File.exists?('/mysql_installed') }
end

execute "setup OTK schemas" do
  command <<-EOH
mysql -u root <<-EOF 
CREATE DATABASE otk_db;
GRANT SELECT,UPDATE,DELETE,INSERT ON otk_db.* TO 'otk_usr'@'localhost' identified by '7layer';
EOF
mysql -u root -e "source /vagrant/mysql/otk_db_schema.sql" otk_db
mysql -u root -e "source /vagrant/mysql/mag_db_schema.sql" otk_db
mysql -u root -e "source /vagrant/mysql/mag_db_testdata.sql" otk_db
mysql -u root -e "source /vagrant/mysql/mag_otk_db_data.sql" otk_db
mysql -u root -e "source /vagrant/mysql/mag_otk_db_testdata.sql" otk_db
mkdir /otk_schema
  EOH
  cwd '/vagrant/vagrant_data'
  not_if { ::File.exists?('/otk_schema') }
end

execute "set mysql password" do
  command <<-EOH
mysql -u root <<-EOF 
UPDATE mysql.user SET Password=PASSWORD('7layer') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES; 
EOF
mkdir /mysql_password_set
  EOH
  not_if { ::File.exists?('/mysql_password_set') }
end

execute "my.cnf copy" do
    command <<-EOH
    rm -f /etc/my.cnf
    cp my.cnf /etc/
    service mysqld restart
    EOH
    cwd '/vagrant/vagrant_data'
end
