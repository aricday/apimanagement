print("Starting a JMSConsumer connection: " + connection.name);
var context = new env.DefaultCamelContext();
context.setName("Context_" + connection.name);

var JmsComponent =  Java.type("org.apache.camel.component.jms.JmsComponent");
var jmsComponent = new JmsComponent();

// Set component properties
var componentProperties = parameters["componentProperties"];

for (var key in componentProperties) {
    var methodName = "set" + key.charAt(0).toUpperCase() + key.substring(1);
    jmsComponent[methodName](componentProperties[key]);
}

// Add the component to the context.
context.addComponent("jms", jmsComponent);

context.start();

return {
    camelContext: context,
    startupEnv: env,
    connectionName: connection.name
};
