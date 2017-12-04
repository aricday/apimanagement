#!/bin/bash


type -p lacadmin &>/dev/null  || { echo "***** lacadmin command not found.  Install from https://github.com/EspressoLogicCafe/CALiveAPICreatorAdminCLI *****"; exit 1; }
echo "Deploying and configuring New License file to LAC Admin node"
lacadmin login -u sa -p Password1 http://localhost:80/ -a lac_cluster
lacadmin license import --file /Users/AricDay/Documents/LiveAPI/LAClicense.json
lacadmin login -u admin -p Password1 http://localhost:80/ -a lac_cluster
lacadmin project import --file files/lac/BeerData.json
lacadmin datasource update --prefix main --password root
echo "Deployed and configured Beer API Endpoint to LAC Admin node"
echo "Restart Beers microservice with new license file applied - Admin"
docker-compose -f docker-compose.beers.yml restart
