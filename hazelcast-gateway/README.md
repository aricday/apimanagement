# docker-gateway

This repository contains some of my labs and tests using the Broadcom Layer7 API Gateway docker form factor.

## Getting Started

As of this version, you're going to find 3 docker-compose files as follows:

* **gateway-derby.yml** - deployment of a database-less gateway and not use the hazelcast cluster
* **hazelcast.yml** - hazelcast cluster and management ui. I modified the original repository that can be found [here](https://github.com/hazelcast/hazelcast-code-samples/tree/master/hazelcast-integration/docker-compose).
* **gateway-hazelcast.yml** - same database-less gateway form factor, however using the hazelcast cluster

## Pre-requisites

Before running this project, make sure you have the following:

* Docker and docker-compose installed and working
* Add the gateway file under the folder **license**. The file name **must** be **ssg_license.xml**, unless you want to change both the **gateway-derby.yml** and **gateway-hazelcast.yml** to include a different license name

## Running the containers

I created a Makefile with some commands to make it easier for anyone to standup the containers without having to type much. You can open and inspect the Makefile yourself, but below are some of the common commands:

### Starting a hazelcast cluster and a gateway all together

The following make command will create a Hazelcast cluster, its management UI and also an API gateway form factor.

```bash
make run
```
The Hazelcast Management UI can be accessed by the following URL:

(http://localhost:8081/hazelcast-mancenter)

For some reason the hazelcast management container will log a different port. I had to change the UI port to 8081 to avoid conflicting with the API gateway HTTP port, which is the same.

After launching the Hazelcast Management UI for the first time you're going to need to define a password for the user admin.

Within the Hazelcast Management UI look for the following options to see the API gateway interactions:

* **Clients** - Here you can see all the API Gateway, and other clients, connected to the Hazelcast Cluster
![Clients](images/hcmgm1.png)
* **Maps** - All the maps created by the API Gateway
![Maps](images/hcmgm2.png)

### Getting the logs

Run the following make command to get attached to all the logs

```bash
make log
```

### Destroying everything

Very handy when you need to start fresh and from scratch. This will kill the containers and also delete the volumes

```bash
make clean
```

### Create a Hazelcast cluster only

If you just want a hazelcast cluster and its management UI, just run the following:

```bash
make hazelcast-cluster
````

Please inspect the **Makefile** for more available commands
