#
#  Copyright (c) 2017 CA. All rights reserved.
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
## Unlock RESTMan
FROM caapim/gateway:latest

USER root

## Load bundles
# ADD ./files/bundles/*.* /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/
COPY ./files/bundles/deployment-1.0.0.gw7 /opt/docker/rc.d/deployment.gw7

## Mount license file(s)
ADD ./config/gwlicense/*.xml /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/
RUN chmod -R 750 "/opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/"

## Deploy RESTMAN
RUN touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/services/restman

# Switch back to the ENTRYPOINT userID so the container does not run with the root user 
USER ${ENTRYPOINT_UID}

