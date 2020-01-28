(function () {
	'use strict';

	log.debug("Begin MongoDBAudit testConnection code.");
	var startTime = env.System.nanoTime();

	// Milliseconds to keep retrying if a Mongo host isn't available.
	var serverHitTimeOutInMillis = 10000;

	var credential = null;

	// Authentication is optional
	if (settings.username) {
		var pwChars = settings.password ? settings.password.toCharArray() : null;
		credential = env.MongoCredential.createCredential(settings.username,
			settings.dbname, pwChars);
	}

	var connStr = new env.ConnectionString(settings.connstr);

	var builder = env.MongoClientSettings.builder().applyConnectionString(connStr);
	if (credential) {
		builder.credential(credential);
	}
	var connSettings = builder.build();

	// Connecting..
	try {
		var mongoClient = env.MongoClients.create(connSettings);
		var db = mongoClient.getDatabase(settings.dbname);
		if (log.isFinestEnabled()) {
			log.finest("Testing connection to database: " + settings.connstr);
		}
		var pingDoc = new env.Document("ping", 1);
		var minLatency = 1000000000;
		// For truly unfathomable reasons, we need to do this several times, otherwise the first
		// execution takes several milliseconds against a local server. No idea why.
		for (var i = 0; i < 10; i++) {
			var startTime = env.System.nanoTime();
			db.runCommand(pingDoc);
			var endTime = env.System.nanoTime();
			if (endTime - startTime < minLatency) {
				minLatency = endTime - startTime;
			}
		}
	}
	catch (e) {
		e.printStackTrace();
		log.error("Error thrown during testConnection:" + e.message);
		return {
			status: "NOT OK",
			message: e.message
		}
	}

	if (null === db) {
		return {
			status: "NOT OK"
		}
	}

	//Latency
	var latencyInMillis = minLatency / 1000000;
	mongoClient.close();

	var returnedObj = {
		status: "OK",
		latency: latencyInMillis
	};

	if (log.isDebugEnabled()) {
		log.debug("MongoDBAudit - testConnection returning " + returnedObj);
	}

	return returnedObj;
})();
