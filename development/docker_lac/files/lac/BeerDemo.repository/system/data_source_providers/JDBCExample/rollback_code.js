(function () {
	log.info('DSP:JDBCExample - rollback begin');

	if (connection && !connection.isClosed()) {
		try {
			if (log.isFinestEnabled()) {
				log.finest('DSP:JDBCExample - Connection: ' + connection);
			}

			connection.rollback();
		}
		catch (e) {
			log.error('Rollback Error ' + e.message);
			throw e;
		}
	}

	log.info('DSP:JDBCExample - rollback end');
})();
