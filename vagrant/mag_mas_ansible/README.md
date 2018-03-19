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

