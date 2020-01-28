(function () {
	'use strict';

	function quoteIdentifier(env, s) {
		'use strict';
		return env.leftQuote + s.replace(/"/, '\\"') + env.rightQuote;
	}

	log.info("DSP:JDBCExample - delete begin");

	if (log.isDebugEnabled()) {
		var logMessage = "Delete entity " + entityName + "=" + parameters.entityKey;
		log.debug(logMessage);
	}

	var metaEntity = parameters.metaEntity;
	var persistentKey = parameters.persistentKey;

	var entityName = metaEntity.entity;

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
		+ 'delete from ' + quotedEntityName
	;
	if ('' !== filterSql) {
		sql += '\n where ' + filterSql
		;
	}

	if (log.isDebugEnabled()) {
		var logMessage = 'Delete SQL ' + sql;
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
			;
		}

		baseType.setSqlParameterValue(pstmt, jdbcIdx, parmValue.value);
	}

	var numRows = pstmt.executeUpdate();
	if (0 === numRows) {
		throw "Delete failed : object not found";
	}

	if (numRows > 1) {
		throw "Delete failed : too many objects deleted";
	}
	pstmt.close();

	log.info("DSP:JDBCExample - delete end");
})();
