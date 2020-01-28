log.info("DSP:MongoDBAudit - open begin");
var isDebugEnabled = log.isDebugEnabled();

var conn = {};

var credential = null;
if (settings.username) {
	var pwChars = settings.password ? settings.password.toCharArray() : null;
	credential = env.MongoCredential.createCredential(settings.username, settings.dbname, pwChars);
}

var connStr = new env.ConnectionString(settings.connstr);

var builder = env.MongoClientSettings.builder().applyConnectionString(connStr);
if (credential) {
	builder.credential(credential);
}
var dbSettings = builder.build();

// Connecting
try {
	conn.client = env.MongoClients.create(dbSettings);
	conn.db = conn.client.getDatabase(settings.dbname);
	if (isDebugEnabled) {
		log.debug("DSP:MongoDBAudit - open - Connecting to the database: " + settings.dbname);
	}
}
catch (e) {
	var errorMessage = "Error thrown while connecting to MongoDB:" + e.message;
	log.error(errorMessage);
	throw e;
}

if (isDebugEnabled) {
	log.debug("DSP:MongoDBAudit - open completed successfully. Connection " + conn);
}

log.info("DSP:MongoDBAudit - open end");
return conn;
