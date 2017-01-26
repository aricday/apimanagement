#!/usr/bin/env bash

# install java
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk

# install repos
wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/2.x/debian stable main' | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list
echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list


# update apt
sudo apt-get update

# install ELK
sudo apt-get -y install elasticsearch kibana logstash
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10
sudo update-rc.d kibana defaults 96 9
sudo service kibana start


# generate ssl certificates
sudo mkdir -p /etc/pki/tls/certs
sudo mkdir /etc/pki/tls/private
cd /etc/pki/tls; sudo openssl req -subj '/CN=elk.apim.ca/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
cp /etc/pki/tls/certs/logstash-forwarder.crt /vagrant/
# # adding nginx proxy (if security required)
# sudo apt-get install nginx apache2-utils -y
# sudo service nginx restart

# configure logstash
sudo cp /vagrant/02-beats-input.conf /etc/logstash/conf.d/
sudo cp /vagrant/10-syslog-filter.conf /etc/logstash/conf.d/
sudo cp /vagrant/30-elasticsearch-output.conf /etc/logstash/conf.d/
sudo service logstash configtest
sudo service logstash restart
sudo update-rc.d logstash defaults 96 9

# load kibana dashboards
cd /home/vagrant
curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
sudo apt-get -y install unzip
unzip beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh

# load filebeat index template
cd /home/vagrant
curl -O https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json

# install filebeat on this ELK server and monitor
sudo apt-get install filebeat
sudo echo "192.168.249.149  elk.apim.ca" >> /etc/hosts
rm -f /etc/filebeat/filebeat.yml
sudo cp /vagrant/filebeat.yml /etc/filebeat/filebeat.yml
sudo service filebeat restart
sudo update-rc.d filebeat defaults 95 10
