(function () {
	'use strict';

	log.info('DSP:JDBCExample - testConnection begin');
	var startTime = env.System.nanoTime();

	var databaseName = settings && settings.databaseName || 'Northwind';
	var schema = settings && settings.schema || 'NORTHWIND';
	var username = settings && settings.username || 'NORTHWIND';
	var password = settings && settings.password;

	var url = env.jdbcInfo + databaseName;

	if (log.isFinestEnabled()) {
		log.finest('JDBCExample - testConnection url ' + url + ' username:' + username);
	}

	try {
		if (env.sqlSelectTest) {
			var sql = env.sqlSelectTest;
			if (log.isFinestEnabled()) {
				log.finest('JDBCExample - Test sql ' + sql);
			}
			var connection = env.DriverManager.getConnection(url, username, password);
			var stmt = connection.createStatement();
			var rs = stmt.executeQuery(sql);
			if (rs.next()) {
				log.debug('DSP:JDBCExample - Test Select ' + rs.getObject(1));
			}
			rs.close();
			stmt.close();
			connection.close();
		}
	}
	catch (e) {
		var result = {};
		log.error('DSP:JDBCExample - testConnection - error:' + e.message);
		result.status = 'NOT OK';
		result.message = e.message;
		return result;
	}

	var endTime = env.System.nanoTime();
	var latencyInMillis = (endTime - startTime) / 100000000;
	var resultObj = {
		status: 'OK',
		latency: latencyInMillis
	};

	if (log.isDebugEnabled()) {
		log.debug('DSP:JDBCExample - testConnection result: ' + resultObj);
	}

	log.info('DSP:JDBCExample - testConnection end');
	return resultObj;
})();
