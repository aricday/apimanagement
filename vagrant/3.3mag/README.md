# CA MAG 3.3 and/or MAS 1.3 build using Vagrant w/ CHEF-SOLO provisioning.
## Gateway: 9.2 / OTK: 3.6 / MAG: 3.3 (+MAS: 1.3)

## Folder "3.3mag" - **MAG/OTK ONLY**  
centOS-6.7 base image
Vagrantfile includes recipe "gmu.rb" which imports MAG/OTK SSKAR and deploys "demo" folder to enable MFA iOS App.

## Folder "1.3mas" - MAS Install w/ Cassandra + Mosquitto  
centOS-7 base image
Vagrantfile includes recipe "mas.rb" which optionally deploys cassandra/mosquitto and installs MAS-Identity, MAS-Storage & MAS-Messaging.

## VAGRANTFILE EDIT REQUIRED:  property "config.vm.synced_folder"
Replace my vagrant directory mapping:  "/Users/AricDay/vagrant"  with "Your Project Root"

File Requirements
 - GW-9.x/MAG-3.x license files
 - ssg-9.2.00-6904.noarch.rpm
 - ssg-appliance-9.2.00-6904.x86_64.rpm

### Directory Structure:
Project Root
 - GMU-1.3
	* centosENV.xml
	* centos.txt
	* mag33.xml
	* mas13.xml
 - vagrant_data
	* create-node.properties
	* my.cnf
	* UnlimitedJCEPolicyJDK8
		* local_policy.jar
		* US_export_policy.jar
	* byo
		* SSG_Gateway_9.xml
		* SSG_MAG_9.xml
		* SSG_MAS_9.xml
		* jdk-8u91-linux-x64.rpm
		* ssg-appliance-9.2.00-6904.x86_64.rpm
		* ssg-9.2.00-6904.noarch.rpm
		* mosquitto-clients-1.4.10-3.1.x86_64.rpm
		* mosquitto-1.4.10-3.1.x86_64.rpm
		* libmosquittopp1-1.4.10-3.1.x86_64.rpm
		* libmosquittopp-devel-1.4.10-3.1.x86_64.rpm
		* libmosquitto1-1.4.10-3.1.x86_64.rpm
		* libmosquitto-devel-1.4.10-3.1.x86_64.rpm
		* cassandra21-2.1.7-1.noarch.rpm
		* cassandra21-tools-2.1.7-1.noarch.rpm
		* dsc21-2.1.7-1.noarch.rpm
 - 1.3mas
	* Vagrantfile
	* mysql
		* otk_db_schema.sql
		* mag_otk_db_data.sql
		* mag_db_schema.sql
		* mag_db_testdata.sql
		* mag_otk_db_testdata.sql
 	* cookbooks
		* ca_apim
			* recipes
				* mas.rb
				* gmu.rb
				* default.rb
				* admin_db.rb
 - 3.3mag
	* Vagrantfile
	* mysql
		* otk_db_schema.sql
		* mag_otk_db_data.sql
		* mag_db_schema.sql
		* mag_db_testdata.sql
		* mag_otk_db_testdata.sql
 	* cookbooks
		* ca_apim
			* recipes
				* gmu.rb
				* default.rb
				* admin_db.rb