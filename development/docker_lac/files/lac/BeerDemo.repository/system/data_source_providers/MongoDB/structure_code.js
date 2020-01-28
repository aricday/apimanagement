(function () {
	'use strict';

	log.info("Begin MongoDB structure");
	var isFinestLoggingEnabled = log.isFinestEnabled();

	var structure = parameters.structure;

	// Example to look at a BSON Document for guess of data type
	// for each attribute.  If the value is null or missing, it will not show up
	// in the structured model.
	function genSchema(doc, attributes) {
		for (var colName in doc) {
			var value = doc.get(colName);
			var attribute = {
				name: colName,
				attrTypeName: null,
				isNullable: true,
				isAutoIncrement: false,
				isDefaulted: false
			};

			var classTypeName = value && value.getClass().getName() || "null";
			var attrTypeName, typeName;
			var attributeNames = [];
			var attributeTypes = [];
			var containedColumns = [];
			var attributeNullable = [];

			switch (classTypeName) {
			default:
				attrTypeName = dspFactory.createString("default", -1);
				break;
			case "null":
				typeName = "unknown";
				attrTypeName = dspFactory.createJSON(colName + "_json");
				break;
			case "org.bson.types.ObjectId":
				typeName = "_id_object";
				attrTypeName = dspFactory.createString("ObjectId", -1);
				attribute.isAutoIncrement = true;
				attribute.isNullable = false;
				break;
			case "java.lang.String":
				typeName = "string";
				attrTypeName = dspFactory.createString(typeName, -1);
				break;
			case "java.util.Date":
				typeName = "datetime";
				attrTypeName = dspFactory.createString(typeName, -1);
				break;
			case "java.lang.Long":
				typeName = "long";
				attrTypeName = dspFactory.createLong(typeName);
				break;
			case "java.lang.Double":
				typeName = "double";
				attrTypeName = dspFactory.createDouble(typeName);
				break;
			case "java.lang.Integer":
				typeName = "integer";
				attrTypeName = dspFactory.createInteger(typeName);
				break;
			case "java.lang.Boolean":
				typeName = "boolean";
				attrTypeName = dspFactory.createBoolean(typeName);
				break;
			case "java.util.ArrayList":
				typeName = colName + "_json";
				attrTypeName = dspFactory.createJSON(colName + "_json");
				break;
			case "org.bson.Document":
				attribute.typeName = colName + "_obj";
				containedColumns = [];
				if (value) {
					genSchema(value, containedColumns);
					for (var y = 0; y < containedColumns.length; y++) {
						var containedColumn = containedColumns[y];
						attributeNames.push(containedColumn.name);
						attributeTypes.push(containedColumn.attrTypeName);
						attributeNullable.push(containedColumn.isNullable);
					}
					attrTypeName = dspFactory.createObject(colName + "_obj", attributeNames, attributeTypes, attributeNullable);
				}
				break;
			}

			attribute.attrTypeName = attrTypeName;
			if (!attributes.hasOwnProperty(colName)) {
				attributes.push(attribute);
			}
		}
	}

	// Each collection is surfaced as a "table"
	var collectionList = connection.db.listCollectionNames().iterator();
	if (isFinestLoggingEnabled) {
		log.finest("MongoDB Collections: " + collectionList);
	}

	var filteredTables = {};
	var filteredProcedures = {};
	while (collectionList.hasNext()) {
		var collectionName = collectionList.next();
		if (!dspFactory.isTableRelevant(collectionName)) {
			//filteredTables.put(collectionName, true);
			continue;
		}
		var attributes = [];
		var scanNumberOfRecords = 1; //?? future merge multiple doc read
		try {
			var coll = connection.db.getCollection(collectionName);
			var docs = coll.find().limit(scanNumberOfRecords).iterator();
			while (docs.hasNext()) {
				var sampleRow = docs.next();
				genSchema(sampleRow, attributes);
			}
			//add the _id attribute if this is an empty collection
			if (attributes.length === 0) {
				attributes.push({
					name: "_id",
					attrTypeName: dspFactory.createString("ObjectId", -1),
					isNullable: false,
					isAutoIncrement: true,
					isDefaulted: false
				});
			}
		}
		catch (E) {
			print(E);
		}

		structure.tables.add(
			{
				name: collectionName,
				columns: attributes,
				keys: [
					{
						name: "_id",
						seq: 1,
						isDatabasePrimary: true,
						columns: [
							"_id"
						]
					}
				],
				parents: []
			}
		);
	}

	// Add functions
	var procedureDefinitions = [
		{
			name: "db.currentOp",
			isFunction: true,
			parameters: [],
			remarks: "Reports the current in-progress operations"
		},
		{
			name: "db.getLastError",
			isFunction: true,
			parameters: [],
			remarks: "Checks and returns the status of the last operation"
		},
		{
			name: "db.getName",
			isFunction: true,
			parameters: [],
			remarks: "Returns the name of the current database"
		},
		{
			name: "db.hostInfo",
			isFunction: true,
			parameters: [],
			remarks: "Returns a document with information about the system MongoDB runs on"
		},
		{
			name: "db.isMaster",
			isFunction: true,
			parameters: [],
			remarks: "Returns a document that reports the state of the replica set"
		},
		{
			name: "db.serverBuildInfo",
			isFunction: true,
			parameters: [],
			remarks: "Returns a document that displays the compilation parameters for the mongod instance"
		},
		{
			name: "db.serverStatus",
			isFunction: true,
			parameters: [],
			remarks: "Returns a document that provides an overview of the state of the database process"
		},
		{
			name: "db.stats",
			isFunction: true,
			parameters: [],
			remarks: "Returns a document that reports on the state of the current database"
		},
		{
			name: "db.version",
			isFunction: true,
			parameters: [],
			remarks: "Returns the version of the mongod instance"
		}
	];

	for (var idx in procedureDefinitions) {
		var proc = procedureDefinitions[idx];
		if (!dspFactory.isProcedureRelevant(proc.name)) {
			//filteredProcedures.put(procedureName, true);
			continue;
		}
		structure.procedures.add(proc);
	}

	if (isFinestLoggingEnabled) {
		log.finest("MongoDB functions added" + JSON.stringify(structure.procedures));
	}

	// Add user-defined functions, at least the ones in system.js
	var adminDb = connection.client.getDatabase("admin");
	if (adminDb) {
		var coll = adminDb.getCollection("system.js");
		if (coll) {
			var all = coll.find().iterator();
			while (all.hasNext()) {
				var funcDef = all.next();
				if (!funcDef.value) {
					//print("Ignoring function 1: " + funcDef._id);
					continue;
				}
				// Extract the parameters from the function declaration
				var codeStr = funcDef.value.toString();
				var expr = /^Code\{code=\'function\s*\(\s*([a-zA-Z0-9_]+)?(\s*,\s*[a-zA-Z0-9_]+)*\s*\)/;
				var paramsMatch = codeStr.match(expr);
				if (!paramsMatch) {
					continue;
				}
				var paramsDef = [];
				for (var i = 1; i < paramsMatch.length; i++) {
					var paramName = paramsMatch[i].trim();
					if (paramName.startsWith(",")) {
						paramName = paramName.substring(1);
					}
					paramName = paramName.trim();
					paramsDef.push({
						column_name: paramName,
						column_type: 1
					});
				}
				structure.procedures.push({
					name: funcDef._id,
					isFunction: false,
					parameters: paramsDef
				});
				if (isFinestLoggingEnabled) {
					log.finest("Added user-defined function: " + funcDef._id);
				}
			}
		}
	}

	if (log.isDebugEnabled()) {
		log.debug("End MongoDB get_metadata_code: " + JSON.stringify(structure));
	}

	structure.filteredTableCount = filteredTables.length;
	structure.filteredProcedureCount = filteredProcedures.length;
	log.info("End MongoDB structure");
})();
