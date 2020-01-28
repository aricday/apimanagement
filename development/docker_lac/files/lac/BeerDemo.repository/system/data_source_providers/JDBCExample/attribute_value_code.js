(function () {
	'use strict';

	function quoteIdentifier(env, s) {
		'use strict';
		return env.leftQuote + s.replace(/"/, '\\"') + env.rightQuote;
	}

	log.info('DSP:JDBCExample - attributeValue begin');

	var result = parameters.result;

	var metaEntity = parameters.metaEntity;
	var persistentKey = parameters.persistentKey;
	var inlineStrategy = parameters.inlineStrategy;

	var JavaSqlTypes = Java.type('java.sql.Types');

	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;

	var sep = '';
	var selectColumnList = '';
	var entityMetaColumns = [];
	var metaColumn = parameters.wantedAttribute;
	entityMetaColumns.push(metaColumn);
	var attributeName = metaColumn.getName();

	var column = metaColumn.name;
	// need to fix column name to database specs - different for each database
	// a'b -> a''b
	// a"b -> a""b
	// "a"b" -> a\"b
	var quotedColumn = quoteIdentifier(env, column);
	selectColumnList += sep + quotedColumn;
	sep = '\n      ,';

	var quotedEntityName = quoteIdentifier(env, entityName);

	var joinPrefix = '';

	var parmValues = [];
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
		+ 'select ' + selectColumnList + '\n'
		+ '  from ' + quotedEntityName
	;
	if ('' !== filterSql) {
		sql += '\n where ' + filterSql;
	}

	if (log.isDebugEnabled()) {
		var logMessage = 'SQL Query: ' + sql;
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

		baseType.setSqlParameterValue(pstmt, jdbcIdx, parmValue.value);
	}

	var rs = pstmt.executeQuery();
	var numObjects = 0;

	var meta = rs.getMetaData();

	result.moreData = false;
	result.nextOffset = parameters.offset;

	while (rs.next()) {
		++numObjects;
		if (numObjects > 1) {
			// only expect a single record to be found
			throw 'More than one record found';
		}

		++result.nextOffset;

		var row = dspFactory.createRow();
		for (var idx = 0; idx < entityMetaColumns.length; ++idx) {
			var jdbcIdx = idx + 1;
			var metaColumn = entityMetaColumns[idx];
			var name = metaColumn.name;
			var sqlType = meta.getColumnType(jdbcIdx);

			var value;
			switch (sqlType) {
			case JavaSqlTypes.BLOB:
				var blob = rs.getBlob(jdbcIdx);
				if (null === blob || rs.wasNull()) {
					value = null;
				}
				else {
					var lobLength = blob.length();
					value = blob.getBytes(1, lobLength);
				}
				break;
			case JavaSqlTypes.CLOB:
				var clob = rs.getClob(jdbcIdx);
				if (null === clob || rs.wasNull()) {
					value = null;
				}
				else {
					var lobLength = clob.length();
					value = clob.getBytes(1, lobLength);
				}
				break;
			default:
				value = rs.getObject(jdbcIdx);
				break;
			}

			row[name] = value;
		}

		result.resultData.add(row);
	}

	rs.close();
	pstmt.close();

	if (log.isDebugEnabled()) {
		var logMessage = 'DSP:JDBCExample - attributeValue - Result ' + result;
		log.debug(logMessage);
	}

	log.info('DSP:JDBCExample - attributeValue end');
})();
