(function () {
	'use strict';
	log.info('DSP:JDBCExample - structure begin');

	var structure = parameters.structure;
	var schemaName = settings.schema || connection.getSchema();

	// connection is passed in from open_code.js
	var databaseMetaData = connection.getMetaData();
	var catalogName = null;

	var type = Java.to(['TABLE', 'VIEW'], 'java.lang.String[]'); // In Nashorn, new java.lang.String[] does not work?

	function determineFKRule(ruleCode) {
		if (null === ruleCode) {
			ruleCode = 3;
		}
		switch (ruleCode) {
		case 0: // DatabaseMetaData.importedKeyCascade;
			return 'CASCADE';
		case 1: // DatabaseMetaData.importedKeyRestrict
			return 'NO_ACTION';
		case 2: // DatabaseMetaData.importedKeySetNull
			return 'SET_NULL';
		case 3: // DatabaseMetaData.importedKeyNoAction
			return 'NO_ACTION';
		case 4: // DatabaseMetaData.importedKeySetDefault
			return 'SET_DEFAULT';
		case 5: // DatabaseMetaData.importedKeyInitiallyDeferred
		case 6: // DatabaseMetaData.importedKeyInitiallyImmediate
		case 7: // DatabaseMetaData.importedKeyNotDeferrable
		default:
			return 'NO_ACTION';
		}
	}

	function determineProcedureDirection(directionCode) {
		switch (directionCode) {
		default:
		case 0:// DatabaseMetaData.procedureColumnUnknown
			return 'IN_OUT';
		case 1:// DatabaseMetaData.procedureColumnIn
			return 'IN';
		case 2: // DatabaseMetaData.procedureColumnInOut
			return 'IN_OUT';
		case 3: // DatabaseMetaData.procedureColumnResult
			return 'OUT';
		case 4: // DatabaseMetaData.procedureColumnOut
			return 'OUT';
		case 5: // DatabaseMetaData.procedureColumnReturn
			return 'OUT';
		}
	}

	function determineProcedureParameterName(name, directionCode) {
		switch (directionCode) {
		default:
			return name;
		case 3: // DatabaseMetaData.procedureColumnResult
		case 5: // DatabaseMetaData.procedureColumnReturn
			return 'FUNCTION_RETURN_VALUE';
		}
	}

	function determineFunctionDirection(directionCode) {
		switch (directionCode) {
		default:
		case 0: // DatabaseMetaData.functionColumnUnknown (0): Unknown type.
			return 'IN_OUT';
		case 1: // DatabaseMetaData.functionColumnIn (1): Input parameter.
			return 'IN';
		case 2: // DatabaseMetaData.functionColumnInOut (2): Input/Output parameter.
			return 'IN_OUT';
		case 3: // DatabaseMetaData.functionColumnOut (3): Output parameter.
			return 'OUT';
		case 4: // DatabaseMetaData.functionReturn (4): Function return value.
			return 'OUT';
		case 5: // DatabaseMetaData.functionColumnResult (5): A parameter or column is a column in the result set.
			return 'OUT';
		}
	}

	function determineFunctionParameterName(name, directionCode) {
		switch (directionCode) {
		default:
			return name;
		case 4: // DatabaseMetaData.functionReturn
		case 5: // DatabaseMetaData.functionColumnResult
			return 'FUNCTION_RETURN_VALUE';
		}
	}

	// This is DERBY specific - you will need to adjust for each different database and as each databases evolves.
	// returns the provided typeName value - so a fluent coding style can be used
	function createAttrType(type, typeName, size, length, precision, scale) {
		var attrTypeName;
		switch (type) {
		default:
			attrTypeName = (null === typeName) ? 'unknown' : typeName;
			return dspFactory.createString(attrTypeName, length);

		case 16: // java.sql.Types.BOOLEAN;
			attrTypeName = 'BOOLEAN';
			return dspFactory.createBoolean(attrTypeName);

		case 7: // java.sql.Types.REAL
			attrTypeName = 'REAL';
			return dspFactory.createFloat(attrTypeName);

		case 8: // java.sql.Types.DOUBLE
			attrTypeName = 'DOUBLE';
			return dspFactory.createDouble(attrTypeName);

		case 5: // java.sql.Types.SMALLINT
			attrTypeName = 'SMALLINT';
			return dspFactory.createSmallInt(attrTypeName);

		case 4: // java.sql.Types.INTEGER;
			attrTypeName = 'INTEGER';
			return dspFactory.createInteger(attrTypeName);

		case -5: // java.sql.Types.BIGINT
			attrTypeName = 'BIGINT';
			return dspFactory.createLong(attrTypeName);

		case 3: // java.sql.Types.DECIMAL
		case 2: // java.sql.Types.NUMERIC
			attrTypeName = 'DECIMAL(' + precision + ',' + scale + ')';
			return dspFactory.createDecimal(attrTypeName, precision, scale);

		case 91: // java.sql.Types.DATE
			attrTypeName = (null === typeName) ? 'DATE' : typeName;
			return dspFactory.createDate(attrTypeName);

		case 1: // java.sql.Types.CHAR
		case -15: // java.sql.Types.NCHAR
			attrTypeName = 1 === size ? 'CHAR' : ('CHAR(' + size + ')');
			return dspFactory.createFixedString(attrTypeName, size);

		case -9: // java.sql.Types.NVARCHAR
		case 12: // java.sql.Types.VARCHAR
			attrTypeName = 'VARCHAR(' + size + ')';
			return dspFactory.createString(attrTypeName, size);

		case -1: // java.sql.Types.LONGVARCHAR
		case -16: // java.sql.Types.LONGNVARCHAR
			attrTypeName = 'LONG VARCHAR';
			return dspFactory.createString(attrTypeName, 32700);

		case 2004: // java.sql.Types.BLOB
			attrTypeName = lobName('BLOB', size);
			return dspFactory.createBLOB(attrTypeName, size);

		case 2005: // java.sql.Types.CLOB
			attrTypeName = lobName('CLOB', size);
			return dspFactory.createCLOB(attrTypeName, size);

		case -2: // java.sql.Types.BINARY
			attrTypeName = 'CHAR(' + size + ') FOR BIT DATA';
			return dspFactory.createFixedBinary(attrTypeName, size);

		case -3: // java.sql.Types.VARBINARY
			attrTypeName = 'VARCHAR(' + size + ') FOR BIT DATA';
			return dspFactory.createBinary(attrTypeName, size);

		case -4: // java.sql.Types.LONGVARBINARY
			attrTypeName = 'LONG VARCHAR FOR BIT DATA';
			return dspFactory.createBinary(attrTypeName, 32700);

		case 93: // java.sql.Types.TIMESTAMP;
			attrTypeName = 'TIMESTAMP';
			return dspFactory.createTimestamp(attrTypeName, 9);

		case 92: // java.sql.Types.TIME
			attrTypeName = 'TIME';
			return dspFactory.createTime(attrTypeName, 0);
		}
	}

	function lobName(lobName, size) {
		if (2147483647 === size) {
			return lobName;
		}
		var num = 1024 * 1024 * 1024;
		if (0 === size % num) {
			return lobName + '(' + (size / num) + 'G)';
		}
		num = 1024 * 1024;
		if (0 === size % num) {
			return logName + '(' + (size / num) + 'M)';
		}
		num = 1024;
		if (0 === size % num) {
			return logName + '(' + (size / num) + 'K)';
		}
		return logName + '(' + size + ')';
	}

	var tbls = databaseMetaData.getTables(catalogName, schemaName, '%', type);
	var key;

	var filteredTables = dspFactory.createRow();
	while (tbls.next()) {
		var tableName = tbls.getString('TABLE_NAME');
		if (!dspFactory.isTableRelevant(tableName)) {
			filteredTables[tableName] = true;
			continue;
		}

		var entity = {
			name: tableName,
			columns: [],
			keys: [],
			parents: []
		};

		if ('VIEW' === tbls.getString('TABLE_TYPE')) {
			structure.views.add(entity);
		}
		else {
			structure.tables.add(entity);
		}

		// Entity Column (Tables and Views)
		var columnsRS = databaseMetaData.getColumns(catalogName, schemaName, entity.name, null);
		while (columnsRS.next()) {
			var columnName = columnsRS.getString('COLUMN_NAME');

			var dataType = columnsRS.getInt('DATA_TYPE');
			var typeName = columnsRS.getString('TYPE_NAME');
			var length = columnsRS.getInt('CHAR_OCTET_LENGTH');
			var size;
			try {
				size = columnsRS.getInt('COLUMN_SIZE');
			}
			catch (e1) {
				out.println('urk - ' + entity.name + ' -> ' + columnName + ' ' + e1);
				size = 9999;
			}
			var scale = columnsRS.getInt('DECIMAL_DIGITS');
			var precision = size;
			var defaulted;
			try {
				var defValue = columnsRS.getString('COLUMN_DEF');
				defaulted = null !== defValue;
			}
			catch (e2) {
				defaulted = false;
			}

			// createAttrType takes the arguments, determines an appropriate underlying type model, and
			// a unique attrTypeName.
			// It returns the attrTypeName.
			// Duplicate calls to createAttrType will always return the same name.
			var column = {
				name: columnName,
				attrTypeName: createAttrType(dataType, typeName, size, length, precision, scale),
				isNullable: 'YES' === columnsRS.getString('IS_NULLABLE'),
				isAutoIncrement: 'YES' === columnsRS.getString('IS_AUTOINCREMENT'),
				isDefaulted: defaulted
			};
			entity.columns.push(column);
		}
		columnsRS.close();

		// Primary Keys
		var primaryKeysRS = databaseMetaData.getPrimaryKeys(catalogName, schemaName, entity.name);
		key = {};
		key.columns = [];
		while (primaryKeysRS.next()) {
			key.seq = primaryKeysRS.getInt('KEY_SEQ');
			key.name = primaryKeysRS.getString('PK_NAME') || 'PRIMARY';
			if (key.seq === 1) {
				key.isDatabasePrimary = true;
			}

			var keyColumnName = primaryKeysRS.getString('COLUMN_NAME');
			key.columns.push(keyColumnName);
		}
		primaryKeysRS.close();
		if (key.name && key.columns.length > 0) {
			entity.keys.push(key);
		}

		// Foreign Keys
		var foreignKeysRS = databaseMetaData.getImportedKeys(catalogName, schemaName, entity.name);
		var foreignKey;
		while (foreignKeysRS.next()) {
			var seq = foreignKeysRS.getInt('KEY_SEQ');
			if (seq === 1) {
				foreignKey = {
					name: foreignKeysRS.getString('FK_NAME'),
					updateRule: determineFKRule(foreignKeysRS.getShort('UPDATE_RULE')),
					deleteRule: determineFKRule(foreignKeysRS.getShort('DELETE_RULE')),
					parent: {
						name: foreignKeysRS.getString('PKTABLE_NAME')
					}
					, child: {
						name: entity.name
					}
					, columns: []
				};
				structure.foreignKeys.add(foreignKey);
			}
			foreignKey.columns.push({
				parent: foreignKeysRS.getString('PKCOLUMN_NAME'),
				child: foreignKeysRS.getString('FKCOLUMN_NAME')
			});
		}
		foreignKeysRS.close();
	}

	// Stored Procedures
	var filteredProcedures = dspFactory.createRow();

	var proceduresRS = databaseMetaData.getProcedures(catalogName, schemaName, null);
	while (proceduresRS.next()) {
		var procedureName = proceduresRS.getString('PROCEDURE_NAME');

		if (!dspFactory.isProcedureRelevant(procedureName)) {
			filteredProcedures[procedureName] = true;
			continue;
		}

		var proc = {
			name: procedureName,
			isFunction: false,
			remarks: proceduresRS.getString('REMARKS'),
			parameters: []
		};
		structure.procedures.add(proc);
	}
	proceduresRS.close();

	var functionsRS = databaseMetaData.getFunctions(catalogName, schemaName, null);
	while (functionsRS.next()) {
		var functionName = functionsRS.getString('FUNCTION_NAME');

		if (!dspFactory.isProcedureRelevant(functionName)) {
			filteredProcedures[functionName] = true;
			continue;
		}

		var proc = {
			name: functionName,
			isFunction: true,
			remarks: functionsRS.getString('REMARKS'),
			parameters: []
		};
		structure.procedures.add(proc);
	}
	functionsRS.close();

	// add the procedure parameters (if any) for ea
	for (var i = 0; i < structure.procedures.length; ++i) {
		var proc = structure.procedures[i];
		if (proc.isFunction) {
			continue;
		}

		var procColumnsRS = databaseMetaData.getProcedureColumns(catalogName, schemaName, proc.name, null);
		var argPosition = 0;
		while (procColumnsRS.next()) {
			var procParameterName = procColumnsRS.getString('COLUMN_NAME');

			var procColumnType = procColumnsRS.getInt('COLUMN_TYPE');
			var procDataType = procColumnsRS.getInt('DATA_TYPE');
			var procTypeName = procColumnsRS.getString('TYPE_NAME');
			var procLength = procColumnsRS.getInt('CHAR_OCTET_LENGTH');
			var procSize = procColumnsRS.getInt('LENGTH');
			var procPrecision = procColumnsRS.getInt('PRECISION');
			var procScale = procColumnsRS.getInt('SCALE');
			procParameterName = determineProcedureParameterName(procParameterName, procColumnType);
			var procDirection = determineProcedureDirection(procColumnType);
			if ("@RETURN_VALUE".equals(procParameterName)) {
				argPosition = 0;
			}
			else {
				++argPosition;
			}
			var procParameter = {
				name: procParameterName,
				attrTypeName: createAttrType(procDataType, procTypeName, procSize, procLength, procPrecision, procScale),
				argPosition: argPosition,
				direction: procDirection,
				isNullable: 'YES' === procColumnsRS.getString('IS_NULLABLE'),
			};
			proc.parameters.push(procParameter);
		}

		procColumnsRS.close();
	}

	// add the function parameters (if any) for ea
	for (var i = 0; i < structure.procedures.length; ++i) {
		var proc = structure.procedures[i];
		if (!proc.isFunction) {
			continue;
		}

		var fnColumnsRS = databaseMetaData.getFunctionColumns(catalogName, schemaName, proc.name, null);
		var argPosition = 0;
		while (fnColumnsRS.next()) {
			var fnParameterName = fnColumnsRS.getString('COLUMN_NAME');
			var fnColumnType = fnColumnsRS.getInt('COLUMN_TYPE');
			var fnDataType = fnColumnsRS.getInt('DATA_TYPE');
			var fnTypeName = fnColumnsRS.getString('TYPE_NAME');
			var fnLength = fnColumnsRS.getInt('CHAR_OCTET_LENGTH');
			var fnSize = fnColumnsRS.getInt('LENGTH');
			var fnPrecision = fnColumnsRS.getInt('PRECISION');
			var fnScale = fnColumnsRS.getInt('SCALE');
			fnParameterName = determineFunctionParameterName(fnParameterName, fnColumnType);
			var fnDirection = determineFunctionDirection(fnColumnType);
			argPosition = fnColumnsRS.getInt("ORDINAL_POSITION");
			var fnParameter = {
				name: fnParameterName,
				attrTypeName: createAttrType(fnDataType, fnTypeName, fnSize, fnLength, fnPrecision, fnScale),
				argPosition: argPosition,
				direction: fnDirection,
				isNullable: 'YES' === fnColumnsRS.getString('IS_NULLABLE'),
			};
			proc.parameters.push(fnParameter);
		}

		fnColumnsRS.close();
	}

	structure.filteredTableCount = filteredTables.length;
	structure.filteredProcedureCount = filteredProcedures.length;

	log.info('DSP:JDBCExample structure - end');
})();
