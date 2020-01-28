(function () {
	log.info('DSP:JDBCExample - close begin');
	if (connection && !connection.isClosed()) {
		try {
			if (log.isFinestEnabled()) {
				log.finest('DSP:JDBCExample - close: ' + connection);
			}
			connection.close();
		}
		catch (e) {
			log.error('DSP:JDBCExample - close error ' + e.message);
			throw e;
		}
	}
	log.info('DSP:JDBCExample - close end');
})();
