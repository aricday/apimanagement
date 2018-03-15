#!/bin/bash


type -p lacadmin &>/dev/null  || { echo "***** lacadmin command not found.  Install from https://github.com/EspressoLogicCafe/CALiveAPICreatorAdminCLI *****"; exit 1; }
echo "Deploying and configuring New License file to LAC Admin node"
lacadmin login -u sa -p Password1 http://ca-live-api-creator.cfapps.io:80/ -a pcf_lac
lacadmin license import --file /Users/AricDay/Documents/LiveAPI/LAClicense.json
lacadmin login -u admin -p Password1 http://ca-live-api-creator.cfapps.io:80/ -a pcf_lac
lacadmin project import --file BeerData.json
lacadmin datasource update --prefix main --password root
echo "Deployed and configured Beer API Endpoint to LAC Admin node"
