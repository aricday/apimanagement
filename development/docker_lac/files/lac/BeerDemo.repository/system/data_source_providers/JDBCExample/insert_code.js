(function () {
	'use strict';

	function quoteIdentifier(env, s) {
		'use strict';
		return env.leftQuote + s.replace(/"/, '\\"') + env.rightQuote;
	}

	log.info('DSP:JDBCExample - Begin insert code');

	var metaEntity = parameters.metaEntity;

	var DataMap = Java.type('com.kahuna.server.data.DataMap');
	var SqlStrategy = Java.type('com.kahuna.server.db.SqlStrategy');
	var JavaSqlTypes = Java.type('java.sql.Types');

	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;

	var insertColumnList = '';
	var valueOrParams = '';
	var entityMetaColumns = metaEntity.getColumns();
	var parms = [];
	var generatedNames = [];
	var bean = parameters.bean;

	var sep = '';
	for (var idx = 0; idx < entityMetaColumns.length; ++idx) {
		var metaColumn = entityMetaColumns[idx];
		if (!metaColumn.persistent) {
			continue;
		}

		if (metaColumn.readOnly) {
			continue;
		}

		var columnName = metaColumn.name;
		var quotedColumnName = quoteIdentifier(env, columnName);
		var value = bean.getValue(columnName);

		// there is a difference between null, default and not-included in the insert statement
		if (null === value) {
			if (metaColumn.autoIncrement) {
				insertColumnList += sep + quotedColumnName;
				valueOrParams += sep + 'default';
				generatedNames.push(columnName);
			}
			else {
				// skip this column
				// optionally, could do:
				//  insertColumnList += sep + quotedColumnName;
				//  valueOrParams += sep + 'null';
			}
		}
		else {
			insertColumnList += sep + quotedColumnName;
			valueOrParams += sep + '?';
			parms.push({
				column: metaColumn,
				value: value
			});
		}
		sep = ',';
	}

	var sql = 'insert into ' + quoteIdentifier(env, entityName)
		+ '(' + insertColumnList + ') \n'
		+ 'values (' + valueOrParams + ')';
	if (log.isDebugEnabled()) {
		var logMessage = 'Insert SQL statement: ' + sql;
		log.debug(logMessage);
	}

	var pstmt;
	if (0 === generatedNames.length) {
		pstmt = connection.prepareStatement(sql);
	}
	else {
		pstmt = connection.prepareStatement(sql, Java.to(generatedNames, 'java.lang.String[]'));
	}
	for (var idx = 0; idx < parms.length; ++idx) {
		var jdbcIdx = idx + 1;
		var parm = parms[idx];
		var metaColumn = parm.column;
		var baseType = parm.column.baseType;
		var value = parm.value;

		if (log.isDebugEnabled()) {
			var logMessage = parm.column.name + ' value = ' + value;
			log.debug(logMessage);
		}

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

	var numRows = pstmt.executeUpdate();

	if (0 !== generatedNames.length) {
		var rs = pstmt.getGeneratedKeys();
		if (null != rs && rs.next()) {
			for (var i = 0; i < generatedNames.length; ++i) {
				var jdbcIdx = i + 1;
				var genName = generatedNames[i];
				var value = rs.getObject(jdbcIdx);
				var metaColumn = metaEntity.getColumnByName(genName);
				var mappedValue = metaColumn.baseType.mapValue(value);
				bean.setValue(genName, mappedValue);
			}
		}
	}
	pstmt.close();

	log.info('DSP:JDBCExample - End insert code');
})();
