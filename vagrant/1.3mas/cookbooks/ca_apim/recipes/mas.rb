
execute "install cassandra" do
  command <<-EOH
    rpm -U cassandra21-2.1.7-1.noarch.rpm
    rpm -U cassandra21-tools-2.1.7-1.noarch.rpm
    rpm -U dsc21-2.1.7-1.noarch.rpm
  EOH
  cwd '/vagrant/vagrant_data/byo'
end

package "dsc21" do
  action :install
end

service "cassandra" do
  action :enable
end

service "cassandra" do
  action :start
end


execute "install mosquitto MQTT" do
  command <<-EOH
    yum install uuid tcp_wrappers -y
    rpm -U libmosquitto1-1.4.10-3.1.x86_64.rpm
    rpm -U libmosquittopp1-1.4.10-3.1.x86_64.rpm
    rpm -U libmosquitto-devel-1.4.10-3.1.x86_64.rpm
    rpm -U libmosquittopp-devel-1.4.10-3.1.x86_64.rpm
    rpm -U mosquitto-clients-1.4.10-3.1.x86_64.rpm
    rpm -U mosquitto-1.4.10-3.1.x86_64.rpm
  EOH
  cwd '/vagrant/vagrant_data/byo'
end

package "mosquitto" do
  action :install
end

service "mosquitto" do
  action :enable
end

service "mosquitto" do
  action :start
end

# # //Testing Branch
execute "set keyspace" do
    command <<-EOH
    cqlsh -u cassandra -p caasandra <<-EOF
  CREATE KEYSPACE IF NOT EXISTS mas_scim WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
  CREATE TABLE IF NOT EXISTS mas_scim.group (group_id uuid,group_name text,group_owner_id text,group_owner_name text,last_modified timestamp,created timestamp,PRIMARY KEY (group_id));
  CREATE TABLE IF NOT EXISTS mas_scim.group_name (group_name text,group_id uuid,PRIMARY KEY(group_name, group_id));
  CREATE TABLE IF NOT EXISTS mas_scim.group_owners (group_name text,group_owner_id text,group_id uuid,PRIMARY KEY (group_owner_id, group_name));
  CREATE TABLE IF NOT EXISTS mas_scim.members_by_group (group_id text,added timestamp,member_id text,display text,PRIMARY KEY (group_id, member_id));
  CREATE INDEX IF NOT EXISTS member_id_index ON mas_scim.members_by_group(member_id);
  CREATE TABLE IF NOT EXISTS mas_scim.groups_by_member (member_id text,added timestamp,group_id text,PRIMARY KEY (member_id, group_id));
  CREATE INDEX IF NOT EXISTS group_id_index ON mas_scim.groups_by_member(group_id);
  CREATE KEYSPACE IF NOT EXISTS myStorage WITH replication = {'class' : 'SimpleStrategy', 'replication_factor' : 1};
  CREATE TABLE IF NOT EXISTS myStorage.file_store (key varchar,content_type varchar,client_id varchar,org_id varchar,user_id varchar,created_date timestamp,last_updated_date timestamp,size int,value blob,PRIMARY KEY (org_id, client_id, user_id, key));
  CREATE TABLE IF NOT EXISTS myStorage.file_store_client_stats (org_id varchar,client_id varchar,size counter,PRIMARY KEY (org_id, client_id));
  CREATE TABLE IF NOT EXISTS myStorage.file_store_user_stats (org_id varchar,user_id varchar,size counter,PRIMARY KEY (org_id, user_id));
  EOF
    EOH
end

# execute "create cassandra key-spaces: mas_scim / myStorage" do
#   command <<-EOH
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE KEYSPACE IF NOT EXISTS mas_scim WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE TABLE IF NOT EXISTS mas_scim.group (group_id uuid,group_name text,group_owner_id text,group_owner_name text,last_modified timestamp,created timestamp,PRIMARY KEY (group_id));"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE TABLE IF NOT EXISTS mas_scim.group_name (group_name text,group_id uuid,PRIMARY KEY(group_name, group_id));"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE TABLE IF NOT EXISTS mas_scim.group_owners (group_name text,group_owner_id text,group_id uuid,PRIMARY KEY (group_owner_id, group_name));"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE TABLE IF NOT EXISTS mas_scim.members_by_group (group_id text,added timestamp,member_id text,display text,PRIMARY KEY (group_id, member_id));"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE INDEX IF NOT EXISTS member_id_index ON mas_scim.members_by_group(member_id);"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE TABLE IF NOT EXISTS mas_scim.groups_by_member (member_id text,added timestamp,group_id text,PRIMARY KEY (member_id, group_id));"
#     cqlsh localhost -u cassandra -p cassandra -e "CREATE INDEX IF NOT EXISTS group_id_index ON mas_scim.groups_by_member(group_id);"
#     cqlsh -e "CREATE KEYSPACE IF NOT EXISTS myStorage WITH replication = {'class' : 'SimpleStrategy', 'replication_factor' : 1};"
#     cqlsh -e "CREATE TABLE myStorage.file_store (key varchar,content_type varchar,client_id varchar,org_id varchar,user_id varchar,created_date timestamp,last_updated_date timestamp,size int,value blob,PRIMARY KEY (org_id, client_id, user_id, key));"
#     cqlsh -e "CREATE TABLE myStorage.file_store_client_stats (org_id varchar,client_id varchar,size counter,PRIMARY KEY (org_id, client_id));"
#     cqlsh -e "CREATE TABLE myStorage.file_store_user_stats (org_id varchar,user_id varchar,size counter,PRIMARY KEY (org_id, user_id));"
#     mkdir /cass_keysp
#   EOH
#   cwd '/vagrant/vagrant_data'
#   not_if { ::File.exists?('/cass_keysp') }
# end
