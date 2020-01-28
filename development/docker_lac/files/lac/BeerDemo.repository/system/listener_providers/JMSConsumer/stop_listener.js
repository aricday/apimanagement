var routeIdToStop = context["routeId"];
context.camelContext.stopRoute(routeIdToStop);
context.camelContext.removeRoute(routeIdToStop);
print('Stopped JMSConsumer listener ' + listener.name);
