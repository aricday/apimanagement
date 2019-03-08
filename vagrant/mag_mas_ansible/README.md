API Management Vagrant Ansible
================================

This project includes the API Mangement modules for a fully functioning API Gateway utilizing Vagrant and Ansible. The apim.yaml Vagrant confgiuration contains an API Gateway role name with the coresponding Ansible provisioning roles and extra variables.

*Clustering and high-availability configurations are not configured in this project*

*Release tags are required to identify each version*

Diretory Structure
-------------------------

The application folder structure is defined below:

    <project>/
        Vagrantfile
        vagrant_configs/apim.yaml
        provisioning/
            roles/
               gateway/
               otk/
               mobile/
               portal/

Modify Provisioning Path
-------------------------
Modify Directory for your local path so package dependencies are resolved
  `SOURCE_PATH='/Users/AricDay/API/apim_vagrant_ansible_files'; DESTINATION_PATH='/<YOUR_PATH>/apim_vagrant_ansible_files'; grep -rl $SOURCE_PATH provisioning/group_vars | xargs sed -i "" -e "s@$SOURCE_PATH@$DESTINATION_PATH@g"`
  
  `grep -r $DESTINATION_PATH provisioning/group_vars`

Please contact your CA representative for additional information on required license files and packages.

Required Dependencies
-------------------------

### MySQL Dependencies
    * /Users/AricDay/API/apim_vagrant_ansible_files/mysql-community-server-5.7.21-1.el6.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/mysql-community-libs-5.7.21-1.el6.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/mysql-community-client-5.7.21-1.el6.x86_64.rpm

### Java 
    * /Users/AricDay/API/apim_vagrant_ansible_files/jdk-8u91-linux-i586.rpm

### Cassandra
    * /Users/AricDay/API/apim_vagrant_ansible_files/cassandra21-2.1.7-1.noarch.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/cassandra21-tools-2.1.7-1.noarch.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/dsc21-2.1.7-1.noarch.rpm
    
### provisioning/group_vars/gateway.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/SSG_Gateway_9.xml
    * /Users/AricDay/API/apim_vagrant_ansible_files/ssg-9.4.00-8872.noarch.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/ssg-appliance-9.4.00-8872.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/ssg-platform-1.8.00-346.noarch.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/MySQL-python-1.2.3-0.3.c1.1.el6.x86_64.rpm

### provisioning/group_vars/mas_messaging.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/MAS-Messaging-4.1.00-b775.sskar

### provisioning/group_vars/mosquitto.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/mosquitto-1.4.8-1.1.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/mosquitto-clients-1.4.8-1.1.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/libmosquitto1-1.4.8-1.1.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/tcp_wrappers-7.6-57.el6.x86_64.rpm
    * /Users/AricDay/API/apim_vagrant_ansible_files/uuid-1.6.1-10.el6.x86_64.rpm

### provisioning/group_vars/otk.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/OTK_Installers_4.3.00-3789.zip

### provisioning/group_vars/mobile.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/SSG_MAG_9.xml
    * /Users/AricDay/API/apim_vagrant_ansible_files/MAG_Installers_4.1.00-2591.zip

### provisioning/group_vars/mas.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/SSG_MAS_9.xml

### provisioning/group_vars/mas_storage.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/MAS-Storage-4.1.00-b439.sskar

### provisioning/group_vars/mas_identity.yml
    * /Users/AricDay/API/apim_vagrant_ansible_files/MAS-Identity-4.1.00-b595.sskar


Quick Start
-------------------------

* First run verify you have installed Vagrant and/or Ansible on your host machine
* Update a vagrant_config yaml configuration with the appropriate settings
    * change the Vagrantfile gateway_role declaration or specify the GATEWAY_ROLE=<GATEWAY_ROLE> environment variable
* Vagrant:
    * virtualbox:
        * `vagrant up`
    * AWS:
        * Replace the local Vagrantfile with the AWS file located in the aws directory and move local into sub-directory
        * `AWS_ACCESS_KEY_ID=<YOUR_KEY> AWS_SECRET_ACCESS_KEY=<YOUR_SECRET> AWS_PRIVATE_KEY_FILE=/Users/AricDay/AWScert.pem AWS_PRIVATE_KEY_NAME=AWScert vagrant up`

