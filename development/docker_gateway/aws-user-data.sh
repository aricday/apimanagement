#!/bin/bash

service mysql start
service ssg start
sleep 2m

mkdir -p /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license
mkdir -p /opt/SecureSpan/Gateway/node/default/etc/bootstrap/services
mkdir -p /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle
chmod -R 775 /opt/SecureSpan/Gateway/node/default/etc/bootstrap/
touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/license.xml
touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/05_samp_folder.req.bundle
curl -k https://s3.amazonaws.com/aricawslicense/CA_GW_9.xml >> /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/license.xml
curl -k https://s3.amazonaws.com/aricawslicense/samp_folder.bundle >> /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/05_samp_folder.req.bundle
touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/services/restman
chown -R layer7:gateway /opt/SecureSpan/Gateway/node/default/etc/bootstrap/
echo configure.db=true > create-node.properties
echo database.type=mysql >> create-node.properties
echo database.host=localhost >> create-node.properties
echo database.port=3306 >> create-node.properties
echo database.name=ssg >> create-node.properties
echo database.user=gateway >> create-node.properties
echo database.pass=7layer >> create-node.properties
echo database.admin.user=root >> create-node.properties
echo database.admin.pass=7layer  >> create-node.properties
echo node.enable=true >> create-node.properties
echo configure.node=true >> create-node.properties
echo admin.user=admin >> create-node.properties
echo admin.pass=CAdemo123 >> create-node.properties
echo cluster.host=`hostname` >> create-node.properties
echo cluster.pass=7layer >> create-node.properties
cat create-node.properties | /opt/SecureSpan/Gateway/config/bin/ssgconfig-headless create
sleep 1m
service ssg restart
