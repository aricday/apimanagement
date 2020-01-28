(function () {
	'use strict';
	log.info("DSP:MongoDBAudit - insert begin");
	var logMessage = "";

	var metaEntity = parameters.metaEntity;

	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;

	function convertArray(value) {
		var arr = [];
		var classTypeName = value && value.getClass().getName() || "null";
		switch (classTypeName) {
		default:
			return value;
		case "java.util.List":
		case "java.util.ArrayList":
			for (var i = 0; i < value.size(); i++) {
				var val = value[i];
				if ('object' === typeof val) {
					val = convertArray(val);
				}
				arr.push(val);
			}
			break;
		case "java.util.LinkedHashMap":
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

	var coll = connection.db.getCollection(entityName);
	if (!coll) {
		logMessage = "Error fetching collection. No such MongoDB collection: " + entityName;
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
		var columnName = metaColumn.name;
		var newValue = bean.getValue(columnName);

		if (!metaColumn.persistent) {
			continue;
		}

		if (metaColumn.readOnly) {
			continue;
		}

		// we let the database handle the audo increment value
		if ("_id" === columnName) {
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


	if (log.isFinestEnabled()) {
		logMessage = "DSP:MongoDBAudit - Insert Payload :" + JSON.stringify(payload)
	}

	try {
		var newObj = env.Document.parse(JSON.stringify(payload));
		coll.insertOne(newObj);

		// return the generated or passed key _id
		var idValue = newObj["_id"];
		bean.setValue("_id", idValue);
	}
	catch (e) {
		var errorMessage = "Insert to " + entityName + " failed.Error: " + e.message;
		log.error(errorMessage);
		throw e;
	}

	log.finest("DSP:MongoDBAudit - Insert completed successfully");

	log.info("DSP:MongoDBAudit - insert end");
})();
