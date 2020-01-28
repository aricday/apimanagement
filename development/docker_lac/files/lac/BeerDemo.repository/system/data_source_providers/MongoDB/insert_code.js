(function () {
	'use strict';
	log.info('DSP:MongoDB - insert begin');
	var logMessage = '';

	var metaEntity = parameters.metaEntity;

	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;

	function convertArray(value) {
		var arr = [];
		var classTypeName = value && value.getClass().getName() || 'null';
		switch (classTypeName) {
		default:
			return value;
		case 'java.util.ArrayList':
		case 'java.util.Vector':
			for (var i = 0; i < value.size(); i++) {
				var val = value[i];
				if ('object' === typeof val) {
					val = convertArray(val);
				}
				arr.push(val);
			}
			break;
		case 'java.util.LinkedHashMap':
		case 'java.util.HashMap':
			var result = {};
			for (var key in value) {
				var val = value[key];
				if ('object' === typeof val) {
					val = convertArray(val);
				}
				result[key] = val;
			}
			return result;
		}
		return arr;
	}

	function testNumericIDColumn() {
		var idValue = null;
		var idColumn = metaEntity.getColumnByName("_id");
		var type = idColumn.getGenericType();
		for (var idx = 0; idx < entityMetaColumns.length; ++idx) {
			var metaColumn = entityMetaColumns[idx];
			if (!metaColumn.persistent) {
				continue;
			}

			if (metaColumn.readOnly) {
				continue;
			}

			if ('_id' === metaColumn.name) {
				idValue = bean.getValue(metaColumn.name);
			}
		}

		if (null === idValue && 'number' === type) {
			throw "DSP Requires a numeric _id for insert into MongoDB Collection " + entityName;
		}
	}

	var coll = connection.db.getCollection(entityName);
	if (!coll) {
		logMessage = 'Error fetching collection. No such MongoDB collection: ' + entityName;
		log.error(logMessage);
		throw logMessage;
	}

	var insertColumnList = '';
	var valueOrParams = '';
	var entityMetaColumns = metaEntity.getColumns();
	var parms = [];
	var generatedNames = [];
	var bean = parameters.bean;
	var payload = {};

	for (var idx = 0; idx < entityMetaColumns.length; ++idx) {
		var metaColumn = entityMetaColumns[idx];
		if (!metaColumn.persistent) {
			continue;
		}

		if (metaColumn.readOnly) {
			continue;
		}

		var newValue = bean.getValue(metaColumn.name);

		if (metaColumn.isAutoIncrement && null === newValue) {
			continue;
		}

		var value = metaColumn.getBaseType().mapValue(newValue);
		if ('object' === typeof value) {
			payload[metaColumn.name] = convertArray(value);
		}
		else {
			payload[metaColumn.name] = value;
		}
	}

	testNumericIDColumn();

	if (log.isFinestEnabled()) {
		logMessage = 'DSP:MongoDB - Insert Payload :' + JSON.stringify(payload)
	}

	try {
		var newObj = env.Document.parse(JSON.stringify(payload));
		coll.insertOne(newObj);

		// return the generated or passed key _id
		var idValue = newObj["_id"];
		bean.setValue("_id", idValue);
	}
	catch (e) {
		var errorMessage = 'DSP:MongoDB Insert to ' + entityName + ' failed.Error: ' + e.message;
		log.error(errorMessage);
		throw e;
	}

	log.info('DSP:MongoDB - insert end');
})();
