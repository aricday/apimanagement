connection.camelContext.stop();
connection.camelContext = null;
print("Stopped RabbitMQProducer connection: " + connection.connectionName);
