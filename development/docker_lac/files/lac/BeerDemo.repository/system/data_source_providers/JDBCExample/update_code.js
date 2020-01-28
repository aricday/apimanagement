(function () {
	'use strict';

	function quoteIdentifier(env, s) {
		'use strict';
		return env.leftQuote + s.replace(/"/, '\\"') + env.rightQuote;
	}

	log.info('DSP:JDBCExample - update begin');

	var metaEntity = parameters.metaEntity;
	var persistentKey = parameters.persistentKey;
	var entityName = metaEntity.entity;
	var changeList = parameters.changeList;

	var parmValues = [];

	var sep = '';
	var updateColumnList = '';
	for (var idx = 0; idx < changeList.length; ++idx) {
		var change = changeList[idx];
		var metaColumn = change.column;
		var newValue = change.value;

		if (!metaColumn.persistent) {
			continue;
		}

		parmValues.push({
			metaColumn: metaColumn,
			value: newValue
		});
		var columnName = metaColumn.name;
		var quotedColumnName = quoteIdentifier(env, columnName);
		updateColumnList += sep + quotedColumnName + ' = ?';
		sep = '\n      ,';
	}

	var quotedEntityName = quoteIdentifier(env, entityName);

	var joinPrefix = '';

	var pkMetaColumns = persistentKey.metaKey.columns;

	var filterSql = '';
	for (var idx in pkMetaColumns) {
		var metaColumn = pkMetaColumns[idx];
		var column = metaColumn.name;

		var quotedColumn = quoteIdentifier(env, column);
		filterSql += joinPrefix + quotedColumn + ' = ?';
		joinPrefix = '\n   and ';
		parmValues.push({
			metaColumn: metaColumn,
			value: persistentKey.getValueFor(column)
		});
	}

	var sql = ''
		+ 'update ' + quotedEntityName + '\n'
		+ '   set ' + updateColumnList + '\n'
		+ ' where ' + filterSql;

	if (log.isDebugEnabled()) {
		var logMessage = 'Update SQL statement: ' + sql;
		log.debug(logMessage);
	}

	var pstmt = connection.prepareStatement(sql);

	for (var idx = 0; idx < parmValues.length; ++idx) {
		var jdbcIdx = 1 + idx;
		var parmValue = parmValues[idx];
		var baseType = parmValue.metaColumn.baseType;

		if (log.isDebugEnabled()) {
			var logMessage = 'JDBCExample - PKey colName = ' + parmValue.metaColumn.name + ', value = ' + parmValue.value;
			log.debug(logMessage);
		}

		var value = parmValue.value;
		switch (metaColumn.getGenericType()) {
		default:
			pstmt.setObject(jdbcIdx, value);
			break;
		case 'date':
			var dateValue = value.asDateString();
			pstmt.setObject(jdbcIdx, dateValue);
			break;
		case 'time':
			var timeValue = value.asTimeString();
			pstmt.setObject(jdbcIdx, timeValue);
			break;
		case 'timestamp with time zone':
		case 'timestamp':
			var ts = value.asJavaSqlTimestamp();
			pstmt.setTimestamp(jdbcIdx, ts);
			break;
		}
	}

	pstmt.executeUpdate();
	pstmt.close();

	log.info('DSP:JDBCExample - update end');
})();
