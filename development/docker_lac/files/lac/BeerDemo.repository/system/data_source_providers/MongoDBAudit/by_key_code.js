(function () {
	'use strict';
	log.info("Begin MongoDBAudit byKeyCode");
	var metaEntity = parameters.metaEntity;
	var persistentKey = parameters.persistentKey;
	var metaColumns = parameters.metaColumns;
	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;

	var parmValues = [];
	var key = [];
	var pkMetaColumns = persistentKey.metaKey.columns;
	for (var idx in pkMetaColumns) {
		var metaColumn = pkMetaColumns[idx];
		var column = metaColumn.name;
		parmValues.push({
			metaColumn: metaColumn,
			value: persistentKey.getValueFor(column)
		});
		key.push(persistentKey.getValueFor(column));
	}

	// Validation
	if (key && key.length === 0) {
		var errorMessage = "No key was provided to retrieve a single MongoDB object.";
		log.error(errorMessage);
		throw new Error(errorMessage);
	}

	var coll = connection.db.getCollection(entityName);
	var idQuery = new env.BasicDBObject();
	if (log.isFinestEnabled()) {
		log.finest("MongoDB - Collection for entity " + entityName + " is " + coll.toString());
	}

	// Mongo allows you to either set your own _id with a value of your choosing,
	// like a number or a string, or let it generate an _id, in which case it
	// will be an ObjectId.
	// Here we look at the key -- if it's exactly 24 hexadecimals, then we assume
	// it's an ObjectId. If it's surrounded by single quotes, we treat it as a string.
	// If it's between 1 and 15 decimals, then it's an integer. In all other cases,
	// it's a string.
	var keyIsString = false;

	var key = key[0] !== null ? key[0].toString() : "";
	if (key.match(/^\s*\{\s*\"\$oid\"\s*:\s*\"[a-fA-F0-9]{24}\"\s*\}$/)) {
		var keyObj = JSON.parse(key);
		idQuery.put("_id", new env.ObjectId(keyObj["$oid"]));
	}
	else if (key.match(/^[0-9a-fA-F]{24}$/)) {
		idQuery.put("_id", new env.ObjectId(key));
	}
	else {
		if (key.length > 2 && key.charAt(0) === "'" && key.charAt(key.length - 1) === "'") {
			idQuery.put("_id", key.substring(1, key.length - 1));
			keyIsString = true;
		}
		else {
			if (key.length <= 15 && key.match(/^[0-9]+$/)) {
				idQuery.put("_id", parseInt(key));
			}
			else {
				idQuery.put("_id", key);
				keyIsString = true;
			}
		}
	}
	var data = parameters.result.resultData;
	var doc = coll.find(idQuery).first();

	if (log.isFinestEnabled()) {
		var logMessage = "MongoDB - Querying Entity: " + entityName + " with key:" + idQuery;
		log.finest(logMessage);
	}

	if (!doc) {
		var errorMessage = "No documents returned for " + entityName + " and key " + key;
		log.error(errorMessage);
		return null;
	}
	//////////////////////////
	//Convert to model map
	//////////////////////////
	var idValue = doc.get("_id");
	if ('string' === typeof idValue) {
		idValue = "'" + idValue + "'";
	}
	else {
		idValue = idValue.toString();
	}

	//convert the result row to baseType
	function formatJson(results, columns) {
		var row = dspFactory.createRow();
		var result = (Array.isArray(results) && results.length > 0) ? results[0] : results;
		var value;
		for (var idx = 0; idx < columns.length; idx++) {
			var column = columns[idx];
			var colname = column && column["name"] || 'unknown';
			var baseType = column.getBaseType();
			var generic_type = column.getGenericType();
			if (result && result.hasOwnProperty(colname)) {
				value = result[colname];
				if (null === value) {
					row[colname] = null;
					continue;
				}
				if ("_id" === colname) {
					value = idValue;
					generic_type = 'string';
				}

				switch (generic_type) {
				default:
				case "object":
				case"collection":
					if (generic_type && generic_type === 'object'
						|| generic_type === 'collection') {
						value = baseType.mapValue(value);
					}
					break;
				case "double":
				case "string":
				case "integer":
				case "boolean":
					break;
				case "long":
					if (value instanceof Object) {
						value = new java.lang.Long(value["$numberLong"]);
					}
					break;
				case "date":
					if (value.hasOwnProperty("$date")) {
						var newDT = new Date(value["$date"]);
						value = baseType.mapValue(newDT);
					}
					break;
				}
				row[colname] = value;
			}
		}
		return row;
	}


	var result = JSON.parse(doc.toJson());
	var columns = metaEntity.getColumns();
	var row = formatJson(result, columns);

	data.add(row);
	if (log.isDebugEnabled()) {
		logMessage = "Mongo byKeyCode result for key " + key[0] + " is " + data;
		log.debug(logMessage);
	}

	log.info("End MongoDB byKeyCode");

})();
