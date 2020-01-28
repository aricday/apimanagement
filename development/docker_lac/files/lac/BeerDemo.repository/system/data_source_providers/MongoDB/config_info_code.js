log.info("Begin MongoDB configInfoCode()");
var configInfo = {
	ui_config: [{
		display: "Connection String",
		type: "string",
		length: 200,
		required: true,
		parameterName: "connstr",
		placeholder: "Enter the connection string",
		description: "MongoDB connection strings have the format:<p>" +
			"<code>mongodb://host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database.collection][?options]]</code><p/>" +
			"See the <a href='https://docs.mongodb.com/manual/reference/connection-string/' target='_blank'>MongoDB documentation</a> " +
			"for details."
	}, {
		display: "Database Name",
		type: "string",
		length: 80,
		required: true,
		parameterName: "dbname",
		placeholder: "Enter the database name",
		description: "The name of your MongoDB database, for instance \"local\""
	}, {
		display: "Username",
		type: "string",
		length: 200,
		required: false,
		parameterName: "username",
		placeholder: "Enter the authentication username, if there is one",
		description: "Authorized username for your MongoDB Database, if you are using authentication"
	}, {
		display: "Password",
		type: "secret",
		length: 200,
		required: false,
		parameterName: "password",
		placeholder: "The secret password for your MongoDB user",
		description: "Password for your authorized MongoDB Database user."
	}
	],
	// Environment
	env: {
		System: Java.type("java.lang.System"),
		BasicDBObject: Java.type("com.mongodb.BasicDBObject"),
		ConnectionString: Java.type("com.mongodb.ConnectionString"),
		Document: Java.type("org.bson.Document"),
		Filters: Java.type("com.mongodb.client.model.Filters"),
		KahunaException: Java.type("com.kahuna.server.KahunaException"),
		MongoClients: Java.type("com.mongodb.client.MongoClients"),
		MongoClientOptions: Java.type("com.mongodb.MongoClientOptions"),
		MongoClientSettings: Java.type("com.mongodb.MongoClientSettings"),
		MongoCredential: Java.type("com.mongodb.MongoCredential"),
		ObjectId: Java.type("org.bson.types.ObjectId"),
		Sorts: Java.type("com.mongodb.client.model.Sorts"),
		ServerAddress: Java.type("com.mongodb.ServerAddress")
	},
	// Capabilities
	options: {
		canCommit: false
	}
};
log.info("End MongoDB configInfoCode()");

return configInfo;
