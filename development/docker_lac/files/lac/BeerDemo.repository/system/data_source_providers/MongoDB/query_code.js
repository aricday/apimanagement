(function () {
	'use strict';
	log.info("DSP:MongoDB - query begin");
	var theFilters = [];
	var logMessage;

	if (log.isFinestEnabled()) {
		logMessage = "DSP:MongoDB - query - Processing filters started";
		log.finest(logMessage);
	}

	var metaEntity = parameters.metaEntity;
	var idValue = null;
	var entityName = metaEntity.entity;
	var entityNameWithPrefix = metaEntity.entityName;

	var pagesize = parameters.pagesize;
	var offset = parameters.offset;

	//convert the result row to baseType
	function formatJson(results, columns) {
		var row = dspFactory.createRow();
		var result = (Array.isArray(results) && results.length > 0) ? results[0] : results;
		var value;
		for (var idx = 0; idx < columns.length; idx++) {
			var column = columns[idx];
			var colname = column && column["name"] || 'unknown';
			var baseType = column.getBaseType();
			var attrTypeName = baseType.getAttrTypeName();
			var generic_type = column.getGenericType();
			if (result && result.hasOwnProperty(colname)) {
				value = result[colname];
				if (null === value) {
					row[colname] = null;
					continue;
				}
				if (colname === '_id') {
					value = idValue;
				}

				switch (generic_type) {
				default:
				case "object":
				case"collection":
					try {
						if (value && generic_type === 'object'
							|| generic_type === 'collection') {
							value = baseType.mapValue(value);
						}
					}
					catch (E) {
						log.error(E);
						print(E.getMessage());
					}
					break;
				case "double":
				case "string":
				case "integer":
				case "boolean":
					break;
				case "number":
					if (value.hasOwnProperty("$numberLong")) {
						value = new java.lang.Long(value["$numberLong"]);
					}
					else if (value.hasOwnProperty("$numberDecimal")) {
						value = new java.lang.BigDecimal(value["$numberDecimal"]);
					}
					else if (value.hasOwnProperty("$numberInt")) {
						value = value["$numberInt"];
					}
					break;
				case "long":
					if (value instanceof Object) {
						value = new java.lang.Long(value["$numberLong"]);
					}
					break;
				case "timestamp with time zone":
				case  "timestamp":
					var newDT = new Date(value["$date"]).toISOString();
					value = baseType.mapValue(newDT);
					break;
				case "date":
					if (value.hasOwnProperty("$date")) {
						var newDT = new Date(value["$date"]);
						value = newDT.toISOString();
					}
					else if (value.hasOwnProperty("ISODate")) {
						value = new Date(value["ISODate"]);
					}
					break;
				}
				row[colname] = value;
			}
		}
		return row;
	}

	var sysFilters = parameters.filters.sysfilters || [];
	for (var idx = 0; idx < sysFilters.length; ++idx) {
		var thisFilter = sysFilters[idx];
		var filterName = thisFilter.name;
		if (log.isFinestEnabled()) {
			log.finest('FilterName is: ' + filterName);
		}

		//sysFilters.forEach(function (k, v) {
		//for (var i = 0; i < v.size(); i++) {
		for (var paramIdx in thisFilter.columnValueList) {
			var innerJoinPrefix = 0 === paramIdx ? '' : thisFilter.useAndSemantics ? ' and ' : ' or ';

			var param = thisFilter.columnValueList[paramIdx];
			//var param = v[i].parameters[paramIdx];
			var paramValue = param.value;
			if (paramValue) {
				var key = param.column.name;
				if (key == '_id') {
					if (paramValue["$oid"]) {
						paramValue = new env.ObjectId(paramValue["$oid"]);
					}
					else if (paramValue.match && paramValue.match(/^[0-9a-fA-F]{24}$/)) {
						paramValue = new env.ObjectId(paramValue);
					}
				}

				switch (filterName) {
				case 'equal' :
					theFilters.push(env.Filters.eq(key, paramValue));
					break;
				case 'notequal' :
					theFilters.push(env.Filters.ne(key, paramValue));
					break;
				case 'greater' :
					theFilters.push(env.Filters.gt(key, paramValue));
					break;
				case 'greaterequal' :
					theFilters.push(env.Filters.gte(key, paramValue));
					break;
				case 'less' :
					theFilters.push(env.Filters.lt(key, paramValue));
					break;
				case 'lessequal' :
					theFilters.push(env.Filters.lte(key, paramValue));
					break;
				case 'like' :
					theFilters.push(env.Filters.regex(key, paramValue));
					break;
				default:
					// Do nothing?
				}
				//need to add and or or between
			}
		}
	}

	if (log.isFinestEnabled()) {
		log.finest("DSP:MongoDB - Processing filters for getByQuery finished with filters " + JSON.stringify(theFilters));
	}

	// Deal with sorts
	log.finest("DSP:MongoDB - Processing sorts for query started");
	var sortObjs = new env.BasicDBObject();
	var orders = parameters.orders || [];
	for (var i = 0; i < orders.size(); i++) {
		var param = orders[i];
		switch (param.sortAction) {
		case 'asc':
			sortObjs.put(param.column.name, 1);
			break;
		case 'desc':
			sortObjs.put(param.column.name, -1);
			break;
		case 'asc_uc':
		case 'asc_lc':
		case 'desc_uc':
		case 'desc_lc':
		case 'null_first':
		case 'null_last':
		default:
			throw 'DSP:MongoDB does not support the sort action of ' + param.sortAction;
		}
	}

	if (log.isFinestEnabled()) {
		log.finest("DSP:MongoDB - query - Processing sorts finished with sorts " + sortObjs.toString());
	}

	var coll = connection.db.getCollection(entityName);
	if (!coll) {
		logMessage = "No such Mongo collection: " + entityName;
		log.error(logMessage);
		throw logMessage;
	}

	var docs = null;
	log.finest("DSP:MongoDB - query - Calling find() on the collection to fetch data.");
	if (theFilters.length) {
		docs = coll.find(env.Filters.and(theFilters)).limit(pagesize).sort(sortObjs).skip(offset).iterator();
	}
	else {
		docs = coll.find().limit(pagesize + 1).sort(sortObjs).skip(offset).iterator();
	}

	if (log.isFinestEnabled()) {
		logMessage = "DSP:MongoDB - query - Completed find() on the collection to fetch data.Data " + docs.toString();
		log.finest(logMessage);
	}

	// Now add the metadata sections to all top-level objects
	log.finest("DSP:MongoDB - query - Postprocessing results started.");
	var result = "[";
	var numObjects = 0;

	while (docs.hasNext()) {
		numObjects++;
		var doc = docs.next();
		idValue = doc.get("_id");

		var result = JSON.parse(doc.toJson());
		var columns = metaEntity.getColumns();
		var row = formatJson(result, columns);

		parameters.result.resultData.add(row);
	}

	log.finest("MongoDB - getByQuery - Adding pagination logic.");

	if (log.isDebugEnabled()) {
		logMessage = "DSP:MongoDB - query - Result " + result;
		log.debug(logMessage);
	}
	log.info("DSP:MongoDB - query end");
})();
