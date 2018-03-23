#!/bin/bash


type -p lacadmin &>/dev/null  || { echo "***** lacadmin command not found.  Install from https://github.com/EspressoLogicCafe/CALiveAPICreatorAdminCLI *****"; exit 1; }
echo "Deploying and configuring New License file to LAC Admin node"
lacadmin login -u sa -p Password1 http://ca-live-api-creator.cfapps.io:80/ -a pcf_lac
lacadmin license import --file /Users/AricDay/Documents/LiveAPI/LAClicense.json
lacadmin login -u admin -p Password1 http://ca-live-api-creator.cfapps.io:80/ -a pcf_lac
lacadmin api import --file jwt_testing.json --namecollision replace_existing
echo "Deployed and configured JWT Endpoint to LAC Admin node"
