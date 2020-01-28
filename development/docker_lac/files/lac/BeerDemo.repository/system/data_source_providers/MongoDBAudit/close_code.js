(function () {
	log.info('DSP:MongoDBAudit - close begin');
	if (connection && connection.client.isConnected(null)) {
		try {
			if (log.isFinestEnabled()) {
				log.finest('DSP:MongoDBAudit - close - connection: ' + connection);
			}
			connection.client.close();
		}
		catch (e) {
			log.error('DSP:MongoDBAudit - close - connection error ' + e.message);
			throw e;
		}
	}
	log.info('DSP:MongoDBAudit  - close end');
})();
