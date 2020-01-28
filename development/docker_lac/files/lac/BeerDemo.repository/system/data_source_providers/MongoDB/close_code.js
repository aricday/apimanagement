(function () {
	log.info('DSP:MongoDB - close begin');
	if (connection && connection.client) {
		try {
			if (log.isFinestEnabled()) {
				log.finest('DSP:MongoDB - close - connection: ' + connection);
			}
			connection.client.close();
		}
		catch (e) {
			log.error('DSP:MongoDB - close - connection error ' + e.message);
			throw e;
		}
	}
	log.info('DSP:MongoDB  - close end');
})();
