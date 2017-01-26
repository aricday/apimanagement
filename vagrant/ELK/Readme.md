## ELK server built using Ubuntu 14.04 image

### Components Installed
    - Elasticsearch 2.x
    - Logstash 2.2
    - Kibana 4.4
    - filebeat

### NOTE:  must customize yourIP in /etc/hosts (line 79) in bootstrap.sh
    - echo "yourIP  elk.apim.ca" >> /etc/hosts
    - edit the following line in Vagrantfile
        *   config.vm.network "private_network", ip: "yourIP"

### The bootstrap.sh installer also places filebeat on the server for self-monitoring of /var/logs/*.log

#### The Logstash beat requires a TLS certificate.  This cert is generated and saved in the /ELK directory for client scp

## Browse to: http://elk.apim.ca:5601
