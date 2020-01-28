(function () {
	'use strict';
	log.info('DSP:MongoDB - update begin');
	var logMessage = '';

	var metaEntity = parameters.metaEntity;

	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;
	var entityMetaColumns = metaEntity.getColumns();

	var query = null;
	var persistentKey = parameters.persistentKey;
	var pkMetaColumns = persistentKey.metaKey.columns;
	for (var idx in pkMetaColumns) {
		var metaColumn = pkMetaColumns[idx];
		var column = metaColumn.name;
		var value = persistentKey.getValueFor(column);

		if (column === '_id') {
			if (metaColumn.getGenericType() === 'string') {
				query = env.Filters.eq('_id', new env.ObjectId(value));
			}
			else {
				query = env.Filters.eq('_id', parseInt(value));
			}
		}
	}

	if (!query) {
		logMessage = 'Unable to update MongoDB object without an _id property';
		log.error(logMessage);
		throw logMessage;
	}

	var coll = connection.db.getCollection(entityName);
	if (!coll) {
		logMessage = 'MongoDB - No such MongoDB collection:' + entityName;
		log.error(logMessage);
		throw logMessage;
	}

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

	// re-read the record by _id key
	var doc = coll.find(query).first();

	if (!doc) {
		var errorMessage = 'No documents returned for ' + entityName + ' and using ' + query;
		log.error(errorMessage);
		throw errorMessage;
	}

	var payload = JSON.parse(doc.toJson());

	var changeList = parameters.changeList;
	var parmValues = [];
	for (var idx = 0; idx < changeList.length; ++idx) {
		var change = changeList[idx];
		var metaColumn = change.column;
		var newValue = change.value;

		if (!metaColumn.persistent) {
			continue;
		}

		if (metaColumn.name === '_id') {
			continue;
		}

		var value = metaColumn.getBaseType().mapValue(newValue);

		parmValues.push({
			metaColumn: metaColumn,
			value: value
		});

		if ('object' === typeof value) {
			payload[metaColumn.name] = convertArray(value);
		}
		else {
			payload[metaColumn.name] = value;
		}
	}

	try {
		var newObj = env.Document.parse(JSON.stringify(payload));
		var result = coll.replaceOne(query, newObj); // { upsert: false, writeConcern: wc , collation: c}

		if (log.isFinestEnabled()) {
			log.finest('MongoDB - Update - ReplaceOne : ' + newObj + ' using key ' + query + 'result ' + result);
		}
	}
	catch (e) {
		var errorMessage = 'DSP:MongoDB Update ' + entityName + ' failed.Error: ' + e.message;
		log.error(errorMessage);
		throw e;
	}

	log.info('DSP:MongoDB - update end');
})();
