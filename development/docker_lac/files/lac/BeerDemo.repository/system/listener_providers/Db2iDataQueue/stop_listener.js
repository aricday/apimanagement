var routeIdToStop = context["routeId"];
context.camelContext.stopRoute(routeIdToStop);
context.camelContext.removeRoute(routeIdToStop);
log.debug('Stopped Db2iDataQueue listener ' + listener.name);
