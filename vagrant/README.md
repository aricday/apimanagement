CA API Management Vagrant Provisioning API Gateway 9.2, MAG 3.3, MAS 1.3
================================

This project includes the API Mangement modules for a fully functioning API Gateway utilizing Vagrant and Ansible or CHEF-SOLO. 


Ansible Local or AWS project: API Gateway 9.3, MAG 4.1, MAS 4.1
-------------------------
* mag_mas_ansible: 

Ansible Local and AWS projects: API Gateway 9.2, MAG 3.3, MAS 1.3
-------------------------
* local_ansible_92: 
* aws_ansible_92

Chef Local Build: MAG 3.3, MAS 1.3
-------------------------
* 3.3mag
* 1.3mas

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

