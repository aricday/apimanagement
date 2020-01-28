out.println("Starting a KafkaProducer connection: " + connection.name);
env.props = new env.Properties();
for (var paramName in parameters) {
    env.props.put(paramName, parameters[paramName]);
}
return {
    props: env.props,
    startupEnv: env,
    name: connection.name
};
