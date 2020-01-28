(function () {
	'use strict';
	var metaEntity = parameters.metaEntity;
	var persistentKey = parameters.persistentKey;
	var idQuery = new env.BasicDBObject();
	var entityName = metaEntity.entity;
	var parmValues = [];
	var pkMetaColumns = persistentKey.metaKey.columns;
	var key = [];
	var filterSql = '';
	var logMessage;

	for (var idx in pkMetaColumns) {
		var metaColumn = pkMetaColumns[idx];
		var column = metaColumn.name;
		var baseType = metaColumn.getBaseType();
		var keyValue = String(persistentKey.getValueFor(column));
		key.push(keyValue);
		if ("_id" === column) {
			if (keyValue.match(/^[0-9a-fA-F]{24}$/)) {
				idQuery.put("_id", new env.ObjectId(keyValue));
			}
			else {
				idQuery.put("_id", baseType.mapValue(keyValue));
			}
		}
		else {
			idQuery.put(column, keyValue);
		}
	}

	if (key.length === 0) {
		logMessage = "No key was provided for DELETE. Please provide a key in the URL.";
		log.error(logMessage);
		throw new Error(logMessage);
	}

	var coll = connection.db.getCollection(entityName);

	if (log.isFinestEnabled()) {
		log.finest("MongoDB - Collection :" + coll.toString());
	}

	if (log.isFinestEnabled()) {
		log.finest("MongoDBAudit - Query before deleting " + key + ". Query object : " + idQuery.toString());
	}
	var doc = coll.find(idQuery).first();
	if (!doc) {
		logMessage = "MongoDBAudit - Could not find the entity to be deleted using filter: " + idQuery;
		log.error(logMessage);
		throw new env.KahunaException(4045, [entityName, key, entityName, entityName]);
	}

	log.debug("Deleting an entity:" + entityName + " using: " + idQuery);

	var result = coll.deleteOne(doc);

	log.debug("Delete completed successfully");
	if (!result.deletedCount && result.deletedCount !== 1) {
		logMessage = "MongoDB - Exception while deleting using filter " + idQuery;
		log.error(logMessage);
		throw new env.KahunaException(4045, [entityName, key, entityName, entityName]);
	}

	if (log.isDebugEnabled()) {
		logMessage = "MongoDB - delete - Returned " + result;
		log.debug(logMessage);
	}

	log.info("End MongoDBAudit delete code");
})();
