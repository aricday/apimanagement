print("Starting a RabbitMQConsumer connection: " + connection.name);
var context = new env.DefaultCamelContext();
context.setName("Context_"+connection.name);
context.start();
return {
    camelContext: context,
    startupEnv: env,
    connectionName: connection.name
};
