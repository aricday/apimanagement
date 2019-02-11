#
#  Copyright (c) 2017 CA. All rights reserved.
#
#  This software may be modified and distributed under the terms
#  of the MIT license. See the LICENSE file for details.
#
## Unlock RESTMan
FROM caapim/gateway:latest

## Load bundles
# ADD ./files/bundles/*.* /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/

## Mount license file(s)
ADD ./config/gwlicense/*.xml /opt/SecureSpan/Gateway/node/default/etc/bootstrap/license/

## Deploy RESTMAN
RUN touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/services/restman